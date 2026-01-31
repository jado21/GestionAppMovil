import 'package:flutter/material.dart';
import '../theme/app_styles.dart';

class GestionScreen extends StatefulWidget {
  const GestionScreen({super.key});

  @override
  State<GestionScreen> createState() => _GestionScreenState();
}

class _GestionScreenState extends State<GestionScreen> {
  String periodoSeleccionado = '25 - 0';
  bool datosCargados = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Gestión de Datos")),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // BOTÓN: CARGAR DATOS (Boceto 1)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
              ),
              onPressed: () {
                setState(() => datosCargados = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Excel procesado exitosamente")),
                );
              },
              child: const Text("SUBIR EXCEL / CSV", style: AppTextStyles.buttonLarge),
            ),

            const SizedBox(height: AppSpacing.gapXl),
            const Divider(),
            const SizedBox(height: AppSpacing.gapXl),

            // SECCIÓN REPORTE (Boceto 2)
            if (datosCargados) ...[
              DropdownButtonFormField<String>(
                initialValue: periodoSeleccionado,
                decoration: const InputDecoration(labelText: "Seleccionar Periodo"),
                items: ['24 - I', '24 - II', '25 - 0'].map((p) {
                  return DropdownMenuItem(value: p, child: Text(p));
                }).toList(),
                onChanged: (val) => setState(() => periodoSeleccionado = val!),
              ),
              const SizedBox(height: AppSpacing.gapLg),
              // El corazón de tu boceto como icono decorativo
              Icon(Icons.favorite, color: colors.error, size: 50),
              const SizedBox(height: AppSpacing.gapLg),
              
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  // Aquí irá la lógica de PDF
                },
                icon: const Icon(Icons.download),
                label: const Text("DESCARGAR REPORTE HORARIOS"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
