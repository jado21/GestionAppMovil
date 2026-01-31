import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF002244);
  static const Color primaryDark = Color(0xFF003366);
  static const Color background = Color(0xFFF5F5F5);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnPrimaryMuted = Colors.white70;
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;
  static const Color danger = Colors.red;
  static const Color neutralHint = Colors.grey;
}

class AppSpacing {
  static const EdgeInsets screenPadding = EdgeInsets.all(20);
  static const EdgeInsets screenPaddingLarge = EdgeInsets.all(30);
  static const EdgeInsets listPadding = EdgeInsets.all(12);
  static const EdgeInsets tilePadding = EdgeInsets.all(20);
  static const EdgeInsets cardMarginBottom = EdgeInsets.only(bottom: 10);
  static const EdgeInsets filterPadding =
      EdgeInsets.symmetric(horizontal: 15, vertical: 10);
  static const double gapXs = 10;
  static const double gapSm = 15;
  static const double gapMd = 20;
  static const double gapLgAlt = 24;
  static const double gapLg = 30;
  static const double gapXl = 40;
}

class AppRadii {
  static final BorderRadius card = BorderRadius.circular(12);
  static final BorderRadius badge = BorderRadius.circular(8);
}

class AppTextStyles {
  static const TextStyle buttonLarge = TextStyle(fontSize: 18);
  static const TextStyle menuTitle = TextStyle(fontWeight: FontWeight.bold);
  static const TextStyle sectionTitle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  static const TextStyle horarioTitle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
  static const TextStyle onPrimary = TextStyle(color: AppColors.textOnPrimary);
  static const TextStyle helper =
      TextStyle(color: AppColors.neutralHint, fontStyle: FontStyle.italic);
  static const TextStyle danger = TextStyle(color: AppColors.danger);
  static const TextStyle splashTitle = TextStyle(
    color: AppColors.textOnPrimary,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
  );
  static const TextStyle splashSubtitle = TextStyle(
    color: AppColors.textOnPrimaryMuted,
    fontSize: 18,
  );
  static const TextStyle chipDay = TextStyle(
    color: AppColors.textOnPrimary,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle chipTime = TextStyle(
    color: AppColors.textOnPrimaryMuted,
    fontSize: 10,
  );
}
