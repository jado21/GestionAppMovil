import 'package:flutter/material.dart';
import '../services/document_service.dart';
import '../services/report_service.dart'; 
import '../services/api_service.dart';    
import '../models/horario_model.dart';

class GestionDatosScreen extends StatefulWidget {
  const GestionDatosScreen({super.key});

  @override
  State<GestionDatosScreen> createState() => _GestionDatosScreenState();
}

class _GestionDatosScreenState extends State<GestionDatosScreen> {
  final DocumentService _docService = DocumentService();
  final ReportService _reportService = ReportService();
  final ApiService _apiService = ApiService();

  bool _archivoCargado = false;
  bool _isUploading = false;
  String _periodoSeleccionado = "25 - 0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Módulo de Carga FISI"),
        backgroundColor: const Color(0xFF002244),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView( 
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _archivoCargado ? Icons.check_circle : Icons.cloud_upload,
                  size: 80,
                  color: _archivoCargado ? Colors.green : const Color(0xFF002244),
                ),
                const SizedBox(height: 30),

                // BOTÓN DE CARGA EXCEL
                _isUploading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: () async {
                          // CORRECCIÓN Imagen 1 y 6: Guardamos el Messenger ANTES del await
                          final messenger = ScaffoldMessenger.of(context);
                          
                          setState(() => _isUploading = true);

                          try {
                            List<Horario> nuevosDatos = await _docService.importarDesdeExcel();
                            
                            // CORRECCIÓN Imagen 1, 6, 7 y 8: Verificamos si el widget sigue vivo
                            if (!mounted) return;

                            if (nuevosDatos.isNotEmpty) {
                              // Esto funcionará tras corregir el ApiService
                              await _apiService.guardarMuchosHorarios(nuevosDatos);

                              setState(() {
                                _archivoCargado = true;
                                _isUploading = false;
                              });
                              
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text("Excel procesado con éxito"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              setState(() => _isUploading = false);
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text("No se seleccionó ningún archivo"),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          } catch (e) {
                            if (!mounted) return;
                            setState(() => _isUploading = false);
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text("Error: $e"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.upload_file),
                        label: const Text("SUBIR PLAN DE ESTUDIOS"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(250, 60),
                          backgroundColor: const Color(0xFF002244),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                const SizedBox(height: 40),
                const Divider(),
                const SizedBox(height: 40),

                if (_archivoCargado) ...[
                  const Text(
                    "Opciones de Reporte",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  DropdownButton<String>(
                    value: _periodoSeleccionado,
                    onChanged: (val) => setState(() => _periodoSeleccionado = val!),
                    items: ["24 - I", "24 - II", "25 - 0"].map((String p) {
                      return DropdownMenuItem(value: p, child: Text("Periodo: $p"));
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final horarios = await _apiService.cargarHorariosCompletos();
                      
                      if (!mounted) return;

                      if (horarios.isNotEmpty) {
                        await _reportService.generarPDF(horarios);
                      } else {
                        messenger.showSnackBar(
                          const SnackBar(content: Text("No hay datos para generar el PDF")),
                        );
                      }
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text("DESCARGAR REPORTE PDF"),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(250, 50),
                      side: const BorderSide(color: Color(0xFF002244), width: 1.5),
                      foregroundColor: const Color(0xFF002244),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Botón para limpiar los datos cargados
                  TextButton.icon(
                    onPressed: () {
                      _apiService.limpiarDatos();
                      setState(() => _archivoCargado = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Datos limpiados")),
                      );
                    },
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                    label: const Text("LIMPIAR CARGA", style: TextStyle(color: Colors.red)),
                  ),
                ] else 
                  const Text(
                    "Cargue un archivo para habilitar reportes", 
                    style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}