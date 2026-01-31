import 'package:flutter/material.dart';
import 'horarios_screen.dart';
import '../theme/app_styles.dart';
// import 'asignaturas_screen.dart'; // La crearás luego

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Portal Administrativo")),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            _buildMenuCard(
              context, 
              "HORARIOS ACADÉMICOS", 
              Icons.calendar_month, 
              const HorariosScreen(),
              colors
            ),
            const SizedBox(height: AppSpacing.gapSm),
            _buildMenuCard(
              context, 
              "ASIGNATURAS Y GRUPOS", 
              Icons.class_, 
              const Center(child: Text("Módulo de Asignaturas")), // Temporal
              colors
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String titulo,
    IconData icono,
    Widget destino,
    ColorScheme colors,
  ) {
    return Card(
      elevation: 4,
      child: ListTile(
        contentPadding: AppSpacing.tilePadding,
        leading: Icon(icono, size: 40, color: colors.primary),
        title: Text(titulo, style: AppTextStyles.menuTitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destino)),
      ),
    );
  }
}
