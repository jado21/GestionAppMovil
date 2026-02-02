import 'package:flutter/material.dart';
import 'package:app_unmsm/theme/app_styles.dart';

class SidebarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const SidebarButton({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      child: ListTile(
        onTap: onTap,
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
        leading: Icon(
          icon,
          color: isActive ? AppColors.primaryDarkMode : AppColors.textSecondaryDark,
          size: 20,
        ),
        title: Text(
          label,
          style: AppTextStyles.bodySm.copyWith(
            color: isActive ? Colors.white : AppColors.textSecondaryDark,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        tileColor: isActive ? AppColors.surfaceDark.withValues(alpha: 0.5) : Colors.transparent,
        hoverColor: AppColors.surfaceDark,
      ),
    );
  }
}
