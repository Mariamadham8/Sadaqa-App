import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../../../core/widgets/custom_status_padge.dart';
import '../../../../core/widgets/custom_progress_par.dart';
import '../../data/models/group_model.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    super.key,
    required this.group,
    required this.isPaid,
    this.onPayPressed,
    this.onTap,
  });

  final GroupModel group;
  final bool isPaid;
  final VoidCallback? onPayPressed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderLight, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── top row ──────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.group_rounded,
                      color: AppColors.primaryDark,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(group.name, style: AppTextStyles.headingLarge),
                        const SizedBox(height: 2),
                        Text(
                          '\$${group.monthlyAmount.toStringAsFixed(0)}/month',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (isPaid)
                    const AppBadge.paid(size: BadgeSize.small)
                  else
                    const AppBadge.pending(size: BadgeSize.small),
                ],
              ),

              const SizedBox(height: 14),

              // ── progress bar ─────────────────────────────
              ProgressBarWidget(
                value: 0.7,
                showLabel: false,
                showPercentage: false,
              ),

              const SizedBox(height: 8),

              // ── next payment date ─────────────────────────
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 13,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Next: ${dateFormat.format(group.endDate)}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),

              // ── pay now button (pending only) ─────────────
              if (!isPaid && onPayPressed != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onPayPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Pay Now',
                      style: AppTextStyles.buttonMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
