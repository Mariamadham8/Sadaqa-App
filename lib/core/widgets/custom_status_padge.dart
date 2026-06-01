import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

enum BadgeType { paid, pending, admin, custom }

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.type = BadgeType.custom,
    this.icon,
    this.color,
    this.backgroundColor,
    this.size = BadgeSize.medium,
  });

  // ── named constructors ──────────────────────────────────
  const AppBadge.paid({super.key, this.size = BadgeSize.medium})
    : label = 'Paid',
      type = BadgeType.paid,
      icon = Icons.check_circle_rounded,
      color = null,
      backgroundColor = null;

  const AppBadge.pending({super.key, this.size = BadgeSize.medium})
    : label = 'Pending',
      type = BadgeType.pending,
      icon = Icons.schedule_rounded,
      color = null,
      backgroundColor = null;

  const AppBadge.admin({super.key, this.size = BadgeSize.medium})
    : label = 'Admin',
      type = BadgeType.admin,
      icon = Icons.shield_rounded,
      color = null,
      backgroundColor = null;

  final String label;
  final BadgeType type;
  final IconData? icon;
  final Color? color;
  final Color? backgroundColor;
  final BadgeSize size;

  // ── resolved colors ──────────────────────────────────────
  Color get _fg => switch (type) {
    BadgeType.paid => AppColors.primaryDark,
    BadgeType.pending => const Color(0xFF8B5E00),
    BadgeType.admin => const Color(0xFF1A4BAD),
    BadgeType.custom => color ?? AppColors.primaryDark,
  };

  Color get _bg => switch (type) {
    BadgeType.paid => AppColors.primaryLight,
    BadgeType.pending => AppColors.goldLight,
    BadgeType.admin => const Color(0xFFE8F0FD),
    BadgeType.custom => backgroundColor ?? AppColors.primaryLight,
  };

  // ── sizing ───────────────────────────────────────────────
  double get _fontSize => switch (size) {
    BadgeSize.small => 10,
    BadgeSize.medium => 12,
    BadgeSize.large => 13,
  };

  double get _iconSize => switch (size) {
    BadgeSize.small => 11,
    BadgeSize.medium => 13,
    BadgeSize.large => 14,
  };

  EdgeInsets get _padding => switch (size) {
    BadgeSize.small => const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    BadgeSize.medium => const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    BadgeSize.large => const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: _iconSize, color: _fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: _fontSize,
              color: _fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

enum BadgeSize { small, medium, large }
