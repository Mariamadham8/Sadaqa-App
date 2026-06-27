import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../data/models/group_model.dart';
import '../manager/group_cubit.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _GroupDetailsAppBar(groupName: widget.group.name),
      body: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          if (state is GroupLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is GroupFailure) {
            return Center(
              child: Text(
                state.error.message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.danger,
                ),
              ),
            );
          }

          // use loaded group if available, else fall back to passed group
          final group = state is GroupLoaded ? state.group : widget.group;
          return GroupDetailsBody(group: group);
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
