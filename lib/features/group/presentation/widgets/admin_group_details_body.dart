import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sadaqa_app/features/group/data/models/contribution_model.dart';
import 'package:sadaqa_app/features/group/data/models/membership_model.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/group_contributions_tapbar.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/group_info_section.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../../../core/utils/cyclic_utils_helper.dart';
import '../../../../core/widgets/custom_progress_par.dart';
import '../../data/models/group_model.dart';
import '../manager/contribution Cubit/contribution_cubit.dart';
import '../manager/membership Cubit/membership_cubit.dart';


const List<String> _kMonthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];


class AdminGroupDetailsBody extends StatefulWidget {
  const AdminGroupDetailsBody({super.key, required this.group});

  final GroupModel group;

  @override
  State<AdminGroupDetailsBody> createState() => _AdminGroupDetailsBodyState();
}

class _AdminGroupDetailsBodyState extends State<AdminGroupDetailsBody> {
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
    if (_cycleKey == null) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Text('Unable to determine the current billing cycle'),
        ),
      );
    }

    return BlocBuilder<ContributionCubit, ContributionState>(
      builder: (context, contributionState) {
        return BlocBuilder<MembershipCubit, MembershipState>(
          builder: (context, membershipState) {
            final isLoading = contributionState is ContributionLoading ||
                membershipState.isLoadingMembers;

            if (isLoading) {
              return const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (contributionState is ContributionFailure) {
              return _ErrorMessage(message: contributionState.message);
            }
            if (membershipState.membersError != null) {
              return _ErrorMessage(message: membershipState.membersError!);
            }

            final contributions = contributionState is GroupContributionsLoaded
                ? contributionState.contributions
                : <ContributionModel>[];
            final totalCollected = contributionState is GroupContributionsLoaded
                ? contributionState.totalCollected
                : 0.0;
            final members = membershipState.members ?? const <MembershipModel>[];

            final paidCount = contributions.where((c) => c.isConfirmed).length;
            final goal = widget.group.monthlyAmount * members.length;

             return SingleChildScrollView(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _AdminHeroSection(
        groupName: widget.group.name,
        totalCollected: totalCollected,
        goal: goal,
        paidCount: paidCount,
        totalMembers: members.length,
        monthLabel: _monthLabel(),
      ),
      GroupInfoSection(group: widget.group),
      ContactPaymentSection(group: widget.group),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CONTRIBUTIONS',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            AdminContributionsTabBar(
              members: members,
              contributions: contributions,
            ),
          ],
        ),
      ),
    ],
  ),
);
          },
        );
      },
    );
  }

  String _monthLabel() {
    final now = DateTime.now();
    return '${_kMonthNames[now.month - 1]} ${now.year}';
  }
}

// ── hero ─────────────────────────────────────────────────────────────────────
class _AdminHeroSection extends StatelessWidget {
  const _AdminHeroSection({
    required this.groupName,
    required this.totalCollected,
    required this.goal,
    required this.paidCount,
    required this.totalMembers,
    required this.monthLabel,
  });

  final String groupName;
  final double totalCollected;
  final double goal;
  final int paidCount;
  final int totalMembers;
  final String monthLabel;

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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              monthLabel,
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            groupName,
            style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
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
              _StatItem(label: 'Paid', value: '$paidCount/$totalMembers'),
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

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Text(
          message,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}