import 'package:flutter/material.dart';
import 'package:sadaqa_app/core/utils/app_colors.dart';
import 'package:sadaqa_app/core/utils/app_fonts.dart';


class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo / brand mark
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: const Text('✨', style: TextStyle(fontSize: 26)),
        ),
        const SizedBox(height: 20),
        Text(title, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 6),
        Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
      ],
    );
  }
}