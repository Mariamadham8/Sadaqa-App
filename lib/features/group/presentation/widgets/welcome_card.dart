import 'package:flutter/material.dart';
import 'package:sadaqa_app/core/utils/app_colors.dart';
import 'package:sadaqa_app/core/utils/app_fonts.dart';
import 'package:sadaqa_app/core/widgets/custom_progress_par.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({required this.paidCount, required this.total});

  final int paidCount;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F8F0), Color(0xFFD4F2E4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello, Mariem', style: AppTextStyles.displaySmall),
                const SizedBox(height: 4),
                Text(
                  '$paidCount/$total groups paid this month',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ProgressBarWidget(
                  value: total == 0 ? 0 : paidCount / total,
                  showLabel: false,
                  showPercentage: false,
                  height: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Text('🤝', style: TextStyle(fontSize: 44)),
        ],
      ),
    );
  }
}
