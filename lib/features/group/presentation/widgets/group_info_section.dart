import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../data/models/group_model.dart';


class GroupInfoSection extends StatelessWidget {
  const GroupInfoSection({super.key, required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Group Info'),
          InfoCard(
            children: [
              if (group.discriptoin.isNotEmpty)
                InfoRow(
                  icon: Icons.info_outline_rounded,
                  label: 'Description',
                  value: group.discriptoin,
                ),
              InfoRow(
                icon: Icons.calendar_today_rounded,
                label: 'Next Payment',
                value:
                    '${group.endDate.day}/${group.endDate.month}/${group.endDate.year}',
              ),
              InfoRow(
                icon: Icons.person_rounded,
                label: 'Admin',
                value: group.adminName.isEmpty ? 'N/A' : group.adminName,
              ),
              InviteLinkRow(link: group.inviteLink),
            ],
          ),
        ],
      ),
    );
  }
}

/// بيانات التواصل مع الأدمن وطريقة الدفع.
class ContactPaymentSection extends StatelessWidget {
  const ContactPaymentSection({super.key, required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Payment Details'),
          InfoCard(
            children: [
              InfoRow(
                icon: Icons.phone_rounded,
                label: 'Admin Contact',
                value: group.adminContact.isEmpty ? 'N/A' : group.adminContact,
              ),
              InfoRow(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Payment Method',
                value:
                    group.paymentMethod.isEmpty ? 'N/A' : group.paymentMethod,
                isLast: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── reusable building blocks ────────────────────────────────────────────────

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
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

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.children});
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

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
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

class InviteLinkRow extends StatelessWidget {
  const InviteLinkRow({super.key, required this.link});
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