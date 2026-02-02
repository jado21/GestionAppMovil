import 'package:flutter/material.dart';
import 'package:app_unmsm/theme/app_styles.dart';
import 'package:app_unmsm/widgets/sidebar_button.dart';

class MainSidebar extends StatelessWidget {
  const MainSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundDark,
      child: SafeArea(
        child: Column(
          children: [
            // 1. Header de Perfil
            const _SidebarHeader(),

            const SizedBox(height: AppSpacing.md),

            // 2. Lista de navegación scrolleable
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SidebarButton(
                    icon: Icons.grid_view_rounded,
                    label: "Dashboard",
                    isActive: true, // Ejemplo
                    onTap: () {},
                  ),

                  const _SectionLabel(label: "GESTIÓN ACADÉMICA"),
                  
                  SidebarButton(
                    icon: Icons.calendar_today_outlined,
                    label: "Períodos Académicos",
                    onTap: () {},
                  ),
                  SidebarButton(
                    icon: Icons.business_outlined,
                    label: "Facultades",
                    onTap: () {},
                  ),
                  SidebarButton(
                    icon: Icons.school_outlined,
                    label: "Escuelas",
                    onTap: () {},
                  ),
                  SidebarButton(
                    icon: Icons.assignment_outlined,
                    label: "Planes de Estudio",
                    onTap: () {},
                  ),
                  SidebarButton(
                    icon: Icons.menu_book_outlined,
                    label: "Asignaturas",
                    onTap: () {},
                  ),

                  const _SectionLabel(label: "PROGRAMACIÓN"),

                  SidebarButton(
                    icon: Icons.groups_outlined,
                    label: "Grupos",
                    onTap: () {},
                  ),
                  SidebarButton(
                    icon: Icons.access_time_outlined,
                    label: "Horarios",
                    onTap: () {},
                  ),
                  SidebarButton(
                    icon: Icons.description_outlined,
                    label: "Importar Excel",
                    onTap: () {},
                  ),
                  SidebarButton(
                    icon: Icons.person_add_alt_1_outlined,
                    label: "Gestión de Vacantes",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: const Icon(Icons.person_pin_circle_outlined, color: AppColors.primaryDarkMode),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Invitado",
                style: AppTextStyles.title.copyWith(color: AppColors.primaryDarkMode),
              ),
              Text(
                "Psicología",
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryDark),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.md, AppSpacing.sm),
      child: Text(
        label,
        style: AppTextStyles.sectionTitle.copyWith(
          color: AppColors.textSecondaryDark.withValues(alpha: 0.7),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
