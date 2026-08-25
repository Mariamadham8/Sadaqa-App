import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../data/models/group_model.dart';
import '../manager/group cubit/group_cubit.dart';
import '../manager/membership Cubit/membership_cubit.dart';
import '../widgets/admin_group_details_body.dart';
import '../widgets/group_details_body.dart';

class GroupDetailsView extends StatefulWidget {
  const GroupDetailsView({super.key, required this.group});

  final GroupModel group;

  @override
  State<GroupDetailsView> createState() => _GroupDetailsViewState();
}

class _GroupDetailsViewState extends State<GroupDetailsView> {
  @override
  void initState() {
    super.initState();
    context.read<GroupCubit>().loadGroup(widget.group.id);
    context.read<MembershipCubit>().getUserRole(
      userId: FirebaseAuth.instance.currentUser!.uid,
      groupId: widget.group.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _GroupDetailsAppBar(groupName: widget.group.name),
      body: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, groupState) {
          if (groupState is GroupLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (groupState is GroupFailure) {
            return Center(
              child: Text(
                groupState.error.message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.danger,
                ),
              ),
            );
          }

          final group = groupState is GroupLoaded ? groupState.group : widget.group;

          return BlocBuilder<MembershipCubit, MembershipState>(
            buildWhen: (previous, current) =>
                previous.isLoadingRole != current.isLoadingRole ||
                previous.role != current.role ||
                previous.roleError != current.roleError,
            builder: (context, membershipState) {
              if (membershipState.isLoadingRole) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (membershipState.roleError != null) {
                return Center(
                  child: Text(
                    membershipState.roleError!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.danger,
                    ),
                  ),
                );
              }

              final isAdmin = membershipState.role == 'admin';

              return isAdmin
                  ? AdminGroupDetailsBody(group: group)
                  : GroupDetailsBody(group: group);
            },
          );
        },
      ),
    );
  }
}

// ── AppBar ────────────────────────────────────────────────────────────────────
class _GroupDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _GroupDetailsAppBar({required this.groupName});

  final String groupName;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        groupName,
        style: AppTextStyles.headingLarge.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.more_horiz_rounded,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            // TODO: show group options bottom sheet
          },
        ),
      ],
    );
  }
}