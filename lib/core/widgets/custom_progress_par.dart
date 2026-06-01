import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

class ProgressBarWidget extends StatefulWidget {
  const ProgressBarWidget({
    super.key,
    required this.value,
    this.height = 10.0,
    this.showLabel = true,
    this.showPercentage = true,
    this.label,
    this.backgroundColor,
    this.animate = true,
  }) : assert(value >= 0 && value <= 1, 'value must be between 0 and 1');

  /// 0.0 → 1.0
  final double value;
  final double height;
  final bool showLabel;
  final bool showPercentage;

  /// e.g. "3 of 5 paid"
  final String? label;
  final Color? backgroundColor;
  final bool animate;

  @override
  State<ProgressBarWidget> createState() => _ProgressBarWidgetState();
}

class _ProgressBarWidgetState extends State<ProgressBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(ProgressBarWidget old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value && widget.animate) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.value * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── header row ──────────────────────────────────────
        if (widget.showLabel || widget.showPercentage) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.showLabel && widget.label != null)
                Text(
                  widget.label!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              if (widget.showPercentage)
                Text(
                  '$percentage%',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
        ],

        // ── bar ─────────────────────────────────────────────
        AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            final animatedValue = widget.value * _animation.value;
            return LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final filledWidth = totalWidth * animatedValue;

                return Container(
                  width: totalWidth,
                  height: widget.height,
                  decoration: BoxDecoration(
                    color:
                        widget.backgroundColor ??
                        AppColors.textMuted.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(widget.height / 2),
                  ),
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: Duration.zero,
                        width: filledWidth.clamp(0, totalWidth),
                        height: widget.height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                          ),
                          borderRadius: BorderRadius.circular(
                            widget.height / 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.35),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
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
        ),
      ],
    );
  }
}
