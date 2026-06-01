import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary
  static const Color primary = Color(0xFF1DB954);
  static const Color primaryLight = Color(0xFFE8F8F0);
  static const Color primaryDark = Color(0xFF0F6E56);

  // Gold / Pending
  static const Color gold = Color(0xFFE8A020);
  static const Color goldLight = Color(0xFFFDF3E0);

  // Danger
  static const Color danger = Color(0xFFD85A30);
  static const Color dangerLight = Color(0xFFFAECE7);

  // Surface & Background
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F7F6);

  // Text
  static const Color text = Color(0xFF1A1A1A);
  static const Color textMuted = Color(0xFF6B7280);

  // Borders
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF0F2F1);

  // Status badges
  static const Color paidBg = primaryLight;
  static const Color paidText = primaryDark;
  static const Color pendingBg = goldLight;
  static const Color pendingText = Color(0xFF92580A);
  static const Color adminBg = Color(0xFFEFF6FF);
  static const Color adminText = Color(0xFF1E40AF);

  // Gradient stops
  static const Color progressStart = primary;
  static const Color progressEnd = primaryDark;
}
