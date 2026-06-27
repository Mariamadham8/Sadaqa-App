import 'package:flutter/material.dart';
import 'package:sadaqa_app/core/utils/app_colors.dart';
import 'package:sadaqa_app/core/utils/app_fonts.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    required this.date,
    required this.hint,
    required this.onTap,
  });

  final DateTime? date;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = date == null
        ? hint
        : '${date!.day}/${date!.month}/${date!.year}';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              size: 15,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: date == null ? AppColors.textMuted : AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
