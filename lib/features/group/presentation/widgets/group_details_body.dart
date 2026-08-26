import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/group_info_section.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../../../core/utils/cyclic_utils_helper.dart';
import '../../../../core/widgets/custom_progress_par.dart';
import '../../data/models/group_model.dart';
import '../../data/models/membership_model.dart';
import '../manager/contribution Cubit/contribution_cubit.dart';
import '../manager/membership Cubit/membership_cubit.dart';

class GroupDetailsBody extends StatefulWidget {
  const GroupDetailsBody({super.key, required this.group});

  final GroupModel group;

  @override
  State<GroupDetailsBody> createState() => _GroupDetailsBodyState();
}

class _GroupDetailsBodyState extends State<GroupDetailsBody> {
  String? _cycleKey;

  @override
  void initState() {
    super.initState();
    _cycleKey = CycleUtils.currentCycleKeyForGroup(widget.group.startDate);

    if (_cycleKey != null) {
      context.read<ContributionCubit>().getGroupContributions(
        groupId: widget.group.id,
        month: _cycleKey,
      );
    }
    context.read<MembershipCubit>().getGroupMembers(widget.group.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContributionCubit, ContributionState>(
      builder: (context, contributionState) {
        return BlocBuilder<MembershipCubit, MembershipState>(
          builder: (context, membershipState) {
            final isLoading = contributionState is ContributionLoading ||
                membershipState.isLoadingMembers;

            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (membershipState.membersError != null) {
              return Center(child: Text(membershipState.membersError!));
            }

            final totalCollected = contributionState is GroupContributionsLoaded
                ? contributionState.totalCollected
                : 0.0;
            final members = membershipState.members ?? const <MembershipModel>[];
            final goal = widget.group.monthlyAmount * members.length;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroSection(
                    group: widget.group,
                    totalCollected: totalCollected,
                    goal: goal,
                    totalMembers: members.length,
                  ),
                GroupInfoSection(group: widget.group),
                ContactPaymentSection(group: widget.group),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ── hero ──────────────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.group,
    required this.totalCollected,
    required this.goal,
    required this.totalMembers,
  });

  final GroupModel group;
  final double totalCollected;
  final double goal;
  final int totalMembers;

  @override
  Widget build(BuildContext context) {
    final progress = goal > 0 ? (totalCollected / goal).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.group_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            group.name,
            style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '\$${group.monthlyAmount.toStringAsFixed(0)}/month',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                label: 'Collected',
                value: '\$${totalCollected.toStringAsFixed(0)}',
              ),
              const _StatDivider(),
              _StatItem(
                label: 'Goal',
                value: '\$${goal.toStringAsFixed(0)}',
              ),
              const _StatDivider(),
              _StatItem(
                label: 'Progress',
                value: '${(progress * 100).toStringAsFixed(0)}%',
              ),
            ],
          ),
          const SizedBox(height: 16),
          ProgressBarWidget(
            value: progress,
            showLabel: false,
            showPercentage: false,
            height: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.25),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.amountMedium.copyWith(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white.withValues(alpha: 0.25),
    );
  }
}

