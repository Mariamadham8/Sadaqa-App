import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../data/models/contribution_model.dart';
import '../../data/models/membership_model.dart';

/// تاب بار الأدمن: تاب "Paid" فيه اللي دفعوا والمبلغ اللي دفعوه،
/// وتاب "Not Paid" فيه اللي لسه ماشيش، مع زرار Send Reminder جمب كل واحد
/// (اللوجيك بتاعه لسه stub، هيتوصل بعدين).
class AdminContributionsTabBar extends StatefulWidget {
  const AdminContributionsTabBar({
    super.key,
    required this.members,
    required this.contributions,
    this.onSendReminder,
  });

  final List<MembershipModel> members;
  final List<ContributionModel> contributions;

  /// بيتنده لما حد يدوس Send Reminder. لو سيبتيها null، هيظهر Snackbar
  /// "قريبًا" بدالها لحد ما نوصل اللوجيك الحقيقي.
  final ValueChanged<MembershipModel>? onSendReminder;

  @override
  State<AdminContributionsTabBar> createState() =>
      _AdminContributionsTabBarState();
}

class _AdminContributionsTabBarState extends State<AdminContributionsTabBar> {
  int _selectedIndex = 0;

  List<MembershipModel> get _paidMembers {
    final confirmedIds = widget.contributions
        .where((c) => c.isConfirmed)
        .map((c) => c.userId)
        .toSet();
    return widget.members.where((m) => confirmedIds.contains(m.userId)).toList();
  }

  List<MembershipModel> get _notPaidMembers {
    final confirmedIds = widget.contributions
        .where((c) => c.isConfirmed)
        .map((c) => c.userId)
        .toSet();
    return widget.members
        .where((m) => !confirmedIds.contains(m.userId))
        .toList();
  }

  ContributionModel? _contributionFor(String userId) {
    for (final c in widget.contributions) {
      if (c.userId == userId) return c;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final paid = _paidMembers;
    final notPaid = _notPaidMembers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SegmentedControl(
          selectedIndex: _selectedIndex,
          paidCount: paid.length,
          notPaidCount: notPaid.length,
          onChanged: (index) => setState(() => _selectedIndex = index),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            final slide = Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(animation);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slide, child: child),
            );
          },
          child: _selectedIndex == 0
              ? _PaidList(
                  key: const ValueKey('paid'),
                  members: paid,
                  contributionFor: _contributionFor,
                )
              : _NotPaidList(
                  key: const ValueKey('not_paid'),
                  members: notPaid,
                  onSendReminder: (member) {
                    if (widget.onSendReminder != null) {
                      widget.onSendReminder!(member);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reminder feature is coming soon'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
        ),
      ],
    );
  }
}

// ── segmented control ───────────────────────────────────────────────────────
class _SegmentedControl extends StatelessWidget {
  const _SegmentedControl({
    required this.selectedIndex,
    required this.paidCount,
    required this.notPaidCount,
    required this.onChanged,
  });

  final int selectedIndex;
  final int paidCount;
  final int notPaidCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final segmentWidth = constraints.maxWidth / 2;
        return Container(
          height: 46,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                alignment: selectedIndex == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: segmentWidth - 4,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.28),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  _SegmentLabel(
                    label: 'Paid',
                    count: paidCount,
                    isSelected: selectedIndex == 0,
                    onTap: () => onChanged(0),
                  ),
                  _SegmentLabel(
                    label: 'Not Paid',
                    count: notPaidCount,
                    isSelected: selectedIndex == 1,
                    onTap: () => onChanged(1),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SegmentLabel extends StatelessWidget {
  const _SegmentLabel({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.white : AppColors.textMuted;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: AppTextStyles.labelMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
          child: Center(
            child: Text('$label ($count)'),
          ),
        ),
      ),
    );
  }
}

// ── paid list ────────────────────────────────────────────────────────────────
class _PaidList extends StatelessWidget {
  const _PaidList({super.key, required this.members, required this.contributionFor});

  final List<MembershipModel> members;
  final ContributionModel? Function(String userId) contributionFor;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const _EmptyState(
        icon: Icons.hourglass_empty_rounded,
        message: 'No one has paid yet',
      );
    }

    return Column(
      children: members.map((member) {
        final contribution = contributionFor(member.userId);
        return _MemberRow(
          member: member,
          isLast: member == members.last,
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${(contribution?.amount ?? 0).toStringAsFixed(0)}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (contribution?.updatedAt != null)
                Text(
                  '${contribution!.updatedAt!.day}/${contribution.updatedAt!.month}/${contribution.updatedAt!.year}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── not paid list ────────────────────────────────────────────────────────────
class _NotPaidList extends StatelessWidget {
  const _NotPaidList({
    super.key,
    required this.members,
    required this.onSendReminder,
  });

  final List<MembershipModel> members;
  final ValueChanged<MembershipModel> onSendReminder;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const _EmptyState(
        icon: Icons.celebration_rounded,
        message: 'Everyone has paid! 🎉',
      );
    }

    return Column(
      children: members.map((member) {
        return _MemberRow(
          member: member,
          isLast: member == members.last,
          avatarBg: AppColors.goldLight,
          avatarColor: AppColors.pendingText,
          trailing: OutlinedButton.icon(
            onPressed: () => onSendReminder(member),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(Icons.notifications_active_rounded, size: 14),
            label: const Text('Remind'),
          ),
        );
      }).toList(),
    );
  }
}

// ── shared row ───────────────────────────────────────────────────────────────
class _MemberRow extends StatelessWidget {
  const _MemberRow({
    required this.member,
    required this.trailing,
    this.isLast = false,
    this.avatarBg = AppColors.primaryLight,
    this.avatarColor = AppColors.primaryDark,
  });

  final MembershipModel member;
  final Widget trailing;
  final bool isLast;
  final Color avatarBg;
  final Color avatarColor;

  @override
  Widget build(BuildContext context) {
    final initial = member.name.isNotEmpty ? member.name[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: avatarBg,
            child: Text(
              initial,
              style: AppTextStyles.labelMedium.copyWith(
                color: avatarColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              member.name.isEmpty ? 'Unknown' : member.name,
              style: AppTextStyles.labelMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(icon, size: 32, color: AppColors.textMuted),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}