import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../../../core/widgets/custom_progress_par.dart';
import '../../data/models/group_model.dart';

class GroupDetailsBody extends StatelessWidget {
  const GroupDetailsBody({super.key, required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    // 🔍 DEBUG — الداتا اللي فعلاً وصلت للـ widget من الـ extra: group
    debugPrint('=== [GroupDetailsBody] received group ===');
    debugPrint('name: "${group.name}"');
    debugPrint('discriptoin: "${group.discriptoin}"');
    debugPrint('adminName: "${group.adminName}"');
    debugPrint('adminContact: "${group.adminContact}"');
    debugPrint('paymentMethod: "${group.paymentMethod}"');
    debugPrint('inviteLink: "${group.inviteLink}"');
    debugPrint('monthlyAmount: ${group.monthlyAmount}');
    debugPrint('endDate: ${group.endDate}');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroSection(group: group),
          _InfoSection(group: group),
          _ContactPaymentSection(group: group),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── hero ──────────────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context) {
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
          // ── icon ──────────────────────────────────────
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

          // ── stats row ─────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(label: 'Collected', value: '\$350'),
              _StatDivider(),
              _StatItem(label: 'Goal', value: '\$500'),
              _StatDivider(),
              _StatItem(label: 'Progress', value: '70%'),
            ],
          ),

          const SizedBox(height: 16),

          // ── progress bar on hero ──────────────────────
          ProgressBarWidget(
            value: 0.7,
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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white.withValues(alpha: 0.25),
    );
  }
}

// ── info section ──────────────────────────────────────────────────────────────
class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('Group Info'),
          _InfoCard(
            children: [
              if (group.discriptoin.isNotEmpty)
                _InfoRow(
                  icon: Icons.info_outline_rounded,
                  label: 'Description',
                  value: group.discriptoin,
                ),
              _InfoRow(
                icon: Icons.calendar_today_rounded,
                label: 'Next Payment',
                value:
                    '${group.endDate.day}/${group.endDate.month}/${group.endDate.year}',
              ),
              _InfoRow(
                icon: Icons.person_rounded,
                label: 'Admin',
                value: group.adminName.isEmpty ? 'N/A' : group.adminName,
              ),
              _InviteLinkRow(link: group.inviteLink),
            ],
          ),
        ],
      ),
    );
  }
}

// ── contact & payment section ─────────────────────────────────────────────────
class _ContactPaymentSection extends StatelessWidget {
  const _ContactPaymentSection({required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('Payment Details'),
          _InfoCard(
            children: [
              _InfoRow(
                icon: Icons.phone_rounded,
                label: 'Admin Contact',
                value: group.adminContact.isEmpty ? 'N/A' : group.adminContact,
              ),
              _InfoRow(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Payment Method',
                value: group.paymentMethod.isEmpty
                    ? 'N/A'
                    : group.paymentMethod,
                isLast: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── reusable building blocks ──────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textMuted,
          letterSpacing: 0.8,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.labelMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _InviteLinkRow extends StatelessWidget {
  const _InviteLinkRow({required this.link});
  final String link;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          const Icon(Icons.link_rounded, size: 16, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(
            'Invite Link',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: link));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Invite link copied!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.copy_rounded,
                    size: 13,
                    color: AppColors.primaryDark,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Copy',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}