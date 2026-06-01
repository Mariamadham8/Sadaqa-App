import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

enum AppButtonVariant { primary, secondary, ghost }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final bool fullWidth;

  // ── sizing ──────────────────────────────────────────────
  double get _height => switch (size) {
    AppButtonSize.small => 36,
    AppButtonSize.medium => 48,
    AppButtonSize.large => 56,
  };

  EdgeInsets get _padding => switch (size) {
    AppButtonSize.small => const EdgeInsets.symmetric(horizontal: 14),
    AppButtonSize.medium => const EdgeInsets.symmetric(horizontal: 20),
    AppButtonSize.large => const EdgeInsets.symmetric(horizontal: 28),
  };

  double get _fontSize => switch (size) {
    AppButtonSize.small => 13,
    AppButtonSize.medium => 15,
    AppButtonSize.large => 16,
  };

  double get _iconSize => switch (size) {
    AppButtonSize.small => 16,
    AppButtonSize.medium => 18,
    AppButtonSize.large => 20,
  };

  // ── colors per variant ───────────────────────────────────
  Color _bgColor(bool disabled) {
    if (disabled) return AppColors.textMuted.withOpacity(0.12);
    return switch (variant) {
      AppButtonVariant.primary => AppColors.primary,
      AppButtonVariant.secondary => AppColors.primaryLight,
      AppButtonVariant.ghost => Colors.transparent,
    };
  }

  Color _fgColor(bool disabled) {
    if (disabled) return AppColors.textMuted;
    return switch (variant) {
      AppButtonVariant.primary => Colors.white,
      AppButtonVariant.secondary => AppColors.primaryDark,
      AppButtonVariant.ghost => AppColors.primaryDark,
    };
  }

  BorderSide _border(bool disabled) {
    if (variant == AppButtonVariant.ghost && !disabled) {
      return BorderSide(
        color: AppColors.primaryDark.withOpacity(0.3),
        width: 1.5,
      );
    }
    return BorderSide.none;
  }

  @override
  Widget build(BuildContext context) {
    final bool effectivelyDisabled = isDisabled || isLoading;

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: _iconSize,
            height: _iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(_fgColor(effectivelyDisabled)),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: _iconSize, color: _fgColor(effectivelyDisabled)),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: AppTextStyles.displayMedium.copyWith(
            fontSize: _fontSize,
            color: _fgColor(effectivelyDisabled),
          ),
        ),
      ],
    );

    final button = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: _height,
      decoration: BoxDecoration(
        color: _bgColor(effectivelyDisabled),
        borderRadius: BorderRadius.circular(12),
        border: Border.fromBorderSide(_border(effectivelyDisabled)),
        boxShadow: (!effectivelyDisabled && variant == AppButtonVariant.primary)
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.28),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: effectivelyDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          splashColor: _fgColor(false).withOpacity(0.08),
          highlightColor: _fgColor(false).withOpacity(0.04),
          child: Padding(
            padding: _padding,
            child: Center(child: content),
          ),
        ),
      ),
    );

    if (fullWidth) return SizedBox(width: double.infinity, child: button);
    return button;
  }
}
