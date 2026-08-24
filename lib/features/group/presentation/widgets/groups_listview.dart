import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sadaqa_app/core/router/app_router.dart';
import 'package:sadaqa_app/features/group/presentation/manager/group%20cubit/group_cubit.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/payment_dialog.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/welcome_card.dart';
import '../../../../core/utils/app_fonts.dart';
import 'group_card.dart';

class GroupsListBody extends StatelessWidget {
  const GroupsListBody({super.key});

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
          const paidCount = 1; 
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
                  final isPaid = index == 0; 
                  return GroupCard(
                    group: group,
                    isPaid: isPaid,
                    onPayPressed: isPaid
                        ? null
                        : () {
                            PaymentDialog();
                          },
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