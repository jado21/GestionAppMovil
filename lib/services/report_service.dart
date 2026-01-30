import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart'; // Versión actualizada
import '../models/horario_view_model.dart';

class ReportService {
  /// Genera un PDF organizado de Lunes a Sábado con los datos filtrados
  Future<void> generarPDF(List<HorarioDetallado> horarios) async {
    final pdf = pw.Document();

    // 1. Ordenar los horarios por día y luego por hora
    final ordenDias = {
      'Lunes': 1, 
      'Martes': 2, 
      'Miércoles': 3, 
      'Jueves': 4, 
      'Viernes': 5, 
      'Sábado': 6
    };

    // Creamos una copia para no alterar la lista original de la UI
    List<HorarioDetallado> listaParaPdf = List.from(horarios);

    listaParaPdf.sort((a, b) {
      int comp = (ordenDias[a.horario.dia] ?? 7).compareTo(ordenDias[b.horario.dia] ?? 7);
      if (comp != 0) return comp;
      return a.horario.horaInicio.compareTo(b.horario.horaInicio);
    });

    // 2. Estructura del Documento
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape, // Horizontal para FISI
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader(listaParaPdf),
          pw.SizedBox(height: 20),
          _buildTable(listaParaPdf),
          pw.Spacer(),
          _buildFooter(),
        ],
      ),
    );

    // 3. Guardar y abrir el archivo
    try {
      final output = await getTemporaryDirectory();
      // Limpiamos el nombre del archivo de caracteres extraños
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String path = "${output.path}/Horario_FISI_$timestamp.pdf";
      
      final file = File(path);
      await file.writeAsBytes(await pdf.save());
      
      // Abrir el PDF automáticamente
      await OpenFile.open(path);
    } catch (e) {
      debugPrint("Error al generar o abrir el PDF: $e");
    }
  }

  pw.Widget _buildHeader(List<HorarioDetallado> horarios) {
    String periodo = horarios.isNotEmpty ? horarios.first.horario.periodo : 'N/A';
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              "UNIVERSIDAD NACIONAL MAYOR DE SAN MARCOS",
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              "FACULTAD DE INGENIERÍA DE SISTEMAS E INFORMÁTICA",
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
        pw.Divider(thickness: 2, color: PdfColors.blue900),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("REPORTE DE HORARIO ACADÉMICO", 
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xFF002244))),
            pw.Container(
              padding: const pw.EdgeInsets.all(5),
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),
              child: pw.Text("PERIODO: $periodo", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
          ],
        ),
      ]
    );
  }

  pw.Widget _buildTable(List<HorarioDetallado> horarios) {
    final headers = ['Día', 'Hora', 'Curso', 'Tipo', 'G.', 'Aula', 'Docente'];

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: horarios.map((h) => [
        h.horario.dia,
        "${h.horario.horaInicio} - ${h.horario.horaFin}",
        h.nombreCurso,
        h.horario.tipo,
        h.horario.grupoNumero.toString(),
        h.horario.aulaId.toString(),
        h.nombreDocente,
      ]).toList(),
      border: pw.TableBorder.all(color: PdfColors.grey300),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF002244)),
      cellHeight: 25,
      cellStyle: const pw.TextStyle(fontSize: 9),
      columnWidths: {
        0: const pw.FixedColumnWidth(60), // Día
        1: const pw.FixedColumnWidth(80), // Hora
        2: const pw.FlexColumnWidth(3),   // Curso
        3: const pw.FixedColumnWidth(40), // Tipo
        4: const pw.FixedColumnWidth(25), // Grupo
        5: const pw.FixedColumnWidth(40), // Aula
        6: const pw.FlexColumnWidth(2),   // Docente
      },
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
        6: pw.Alignment.centerLeft,
      },
    );
  }

  pw.Widget _buildFooter() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text("Software de Gestión de Horarios FISI", 
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
        pw.Text("Página 1 de 1", 
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
      ]
    );
  }
}