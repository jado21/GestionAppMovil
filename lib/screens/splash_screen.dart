import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3 segundos es el tiempo ideal; 5 segundos (del segundo código) suele cansar al usuario.
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Usamos rutas nombradas para mantener el estándar de tu proyecto
        Navigator.pushReplacementNamed(context, '/horarios');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.primary, // Azul institucional UNMSM
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: 100,
              color: colors.onPrimary,
            ),
            const SizedBox(height: AppSpacing.gapLgAlt),
            Text(
              "SISTEMA ACADÉMICO",
              style: AppTextStyles.splashTitle.copyWith(color: colors.onPrimary),
            ),
            Text(
              "FISI - UNMSM",
              style: AppTextStyles.splashSubtitle.copyWith(color: colors.onPrimary),
            ),
            const SizedBox(height: AppSpacing.gapXl),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colors.onPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
