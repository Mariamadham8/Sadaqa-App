import 'package:flutter/material.dart';
import 'package:sadaqa_app/core/utils/app_colors.dart';


class CreateGroupFab extends StatelessWidget {
  const CreateGroupFab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: 52,  
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child:  const Icon(Icons.add_rounded, color: Colors.white, size: 30),

      ),
    );
  }
}
