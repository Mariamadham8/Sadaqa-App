import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sadaqa_app/core/dependancy%20injection/di.dart';
import 'package:sadaqa_app/core/router/app_router.dart';
import 'package:sadaqa_app/core/utils/cyclic_utils_helper.dart';
import 'package:sadaqa_app/features/group/presentation/manager/contribution%20Cubit/contribution_cubit.dart';
import 'package:sadaqa_app/features/group/presentation/manager/group%20cubit/group_cubit.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/payment_dialog.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/welcome_card.dart';
import '../../../../core/utils/app_fonts.dart';
import 'group_card.dart';

class GroupsListBody extends StatefulWidget {
  const GroupsListBody({super.key});

  @override
  State<GroupsListBody> createState() => _GroupsListBodyState();
}

class _GroupsListBodyState extends State<GroupsListBody> {

  final Set<String> _paidGroupIds = {};

  Future<void> _openPaymentDialog(BuildContext context, dynamic group) async {
    final cycleKey = CycleUtils.currentCycleKeyForGroup(group.startDate);
    if (cycleKey == null) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => BlocProvider(
        create: (_) => get<ContributionCubit>()
          ..getUserStatus(
            userId: FirebaseAuth.instance.currentUser!.uid,
            groupId: group.id,
            month: cycleKey,
          ),
        child: PaymentDialog(
          groupId: group.id,
          month: cycleKey,
        ),
      ),
    );

    if (result == true) {
      setState(() {
        _paidGroupIds.add(group.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, state) {
        if (state is GroupLoading || state is GroupInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GroupFailure) {
          print('Error loading groups: ${state.error.message}');
          return Center(child: Text(state.error.message));
        }

        if (state is UserGroupsLoaded) {
          final groups = state.groups;
          final paidCount = groups.where((g) => _paidGroupIds.contains(g.id)).length;
          final total = groups.length;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: WelcomeCard(paidCount: paidCount, total: total),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
                  child: Text('Your Groups', style: AppTextStyles.headingLarge),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final group = groups[index];
                  final isPaid = _paidGroupIds.contains(group.id);
                  return GroupCard(
                    group: group,
                    isPaid: isPaid,
                    onPayPressed: isPaid
                        ? null
                        : () => _openPaymentDialog(context, group),
                    onTap: () {
                      context.push(AppRouter.groupDetails, extra: group);
                    },
                  );
                }, childCount: groups.length),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}