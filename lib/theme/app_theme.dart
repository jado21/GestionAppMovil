import 'package:flutter/material.dart';
import 'app_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.primaryDark,
        error: AppColors.danger,
        onPrimary: AppColors.textOnPrimary,
        tertiary: AppColors.success,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        centerTitle: true,
        elevation: 2,
      ),
      cardTheme: CardThemeData(
        // color: AppColors.background,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.card,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.splashTitle,
        headlineMedium: AppTextStyles.sectionTitle,
        labelLarge: AppTextStyles.buttonLarge,
        bodySmall: AppTextStyles.helper,
      )
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,  // con esto flutter sabe que es oscuro
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryDarkMode,
        primary: AppColors.primaryDarkMode,
        brightness: Brightness.dark,
        surface: AppColors.surfaceDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textOnPrimaryDark,
        centerTitle: true,
      ),

      textTheme: const TextTheme(
        displayLarge: AppTextStyles.splashTitle,
        headlineMedium: AppTextStyles.sectionTitle,
        labelLarge: AppTextStyles.buttonLarge,
        bodySmall: AppTextStyles.helper,
      )
    );
  }
}
