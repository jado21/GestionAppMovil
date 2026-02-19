import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/horario_response.dart';

class ResultadoScreen extends StatefulWidget {
  final HorarioResponse horarioResponse;

  const ResultadoScreen({super.key, required this.horarioResponse});

  @override
  State<ResultadoScreen> createState() => _ResultadoScreenState();
}

class _ResultadoScreenState extends State<ResultadoScreen> {
  // CONFIGURACIÓN DE DIMENSIONES
  final double widthColumnaHora = 50.0;
  final double widthColumnaDia = 110.0;
  final double heightHora = 80.0;
  final double heightHeader = 50.0;
  final Color rojoOscuro = const Color(0xFFA80010);

  final List<String> diasSemana = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'];

  // MAPA DE COLORES (Flutter)
  final Map<String, Color> mapaColoresCursos = {
    'REDACCIÓN': const Color(0xFFD32F2F),
    'CÁLCULO': const Color(0xFFFF9800),
    'ÁLGEBRA': const Color(0xFF1976D2),
    'METODOS DE ESTUDIOS UNIVERSITARIOS': const Color(0xFFFFFDD0),
    'BIOLOGÍA': const Color(0xFF388E3C),
    'PROGRAMACIÓN Y COMPUTACIÓN': const Color(0xFF795548),
    'MEDIO AMBIENTE': const Color(0xFFCCFF00),
    'DESARROLLO Y LIDERAZGO': const Color(0xFFFFEB3B),
  };

  // --- LÓGICA DE APOYO ---

  Color _obtenerColorCurso(String nombre) {
    String n = nombre.toUpperCase();
    for (var e in mapaColoresCursos.entries) {
      if (n.contains(e.key)) return e.value;
    }
    return Colors.blueGrey;
  }

  double _parseHora(String horaString) {
    try {
      final parts = horaString.split(':');
      return int.parse(parts[0]) + (int.parse(parts[1]) / 60.0);
    } catch (e) {
      return 0.0;
    }
  }

  // --- EXPORTACIÓN PDF ---

  Future<void> _exportarPDF() async {
    final pdf = pw.Document();
    const int horaInicio = 5;
    const int horaFin = 23;

    final double anchoTotal = widthColumnaHora + (diasSemana.length * widthColumnaDia);
    final double altoTotal = heightHeader + ((horaFin - horaInicio) * heightHora);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(anchoTotal, altoTotal, marginAll: 0),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              _dibujarGrillaPdf(horaFin - horaInicio, horaInicio, anchoTotal),
              _dibujarCabecerasPdf(),
              ..._generarBloquesPdf(horaInicio),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) => pdf.save(),
      name: 'Horario_Grupo_${widget.horarioResponse.grupo}.pdf',
    );
  }

  // --- INTERFAZ DE USUARIO (APP) ---

  @override
  Widget build(BuildContext context) {
    final double anchoTotal = widthColumnaHora + (diasSemana.length * widthColumnaDia);
    const int horaInicio = 5;
    const int horaFin = 23;
    final double altoTotal = heightHeader + ((horaFin - horaInicio) * heightHora);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Horario - Grupo: ${widget.horarioResponse.grupo}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: rojoOscuro,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportarPDF,
            tooltip: 'Exportar a PDF',
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: SizedBox(
            width: anchoTotal,
            height: altoTotal,
            child: Stack(
              children: [
                _dibujarGrillaFondoUI(horaFin - horaInicio, horaInicio, anchoTotal),
                _dibujarCabecerasUI(),
                ..._generarBloquesUI(horaInicio), // Restaurado
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dibujarGrillaFondoUI(int total, int inicio, double ancho) {
    return Column(children: [
      SizedBox(height: heightHeader),
      ...List.generate(total, (i) => Container(
        height: heightHora, width: ancho,
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
        child: Row(children: [
          Container(
            width: widthColumnaHora, alignment: Alignment.topCenter, padding: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey[300]!))),
            child: Text('${inicio + i}:00', style: TextStyle(fontSize: 12, color: rojoOscuro, fontWeight: FontWeight.bold)),
          )
        ]),
      ))
    ]);
  }

  Widget _dibujarCabecerasUI() {
    return Row(children: [
      Container(width: widthColumnaHora, height: heightHeader, color: rojoOscuro),
      ...diasSemana.map((dia) => Container(
        width: widthColumnaDia, height: heightHeader, color: rojoOscuro, alignment: Alignment.center,
        child: Text(dia.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
      )),
    ]);
  }

  List<Widget> _generarBloquesUI(int horaInicioGrid) {
    List<Widget> bloques = [];
    if (widget.horarioResponse.horarios.isEmpty) return [];

    final diasData = widget.horarioResponse.horarios.first.dias;

    for (var diaData in diasData) {
      int indexColumna = diasSemana.indexWhere((d) => 
        d.toLowerCase().contains(diaData.dia.toLowerCase().substring(0, 3))
      );
      if (indexColumna == -1) continue;

      for (var clase in diaData.clases) {
        final double inicio = _parseHora(clase.horaInicio);
        final double fin = _parseHora(clase.horaFin);
        final double top = heightHeader + ((inicio - horaInicioGrid) * heightHora);
        final double height = (fin - inicio) * heightHora;
        final double left = widthColumnaHora + (indexColumna * widthColumnaDia);

        final Color colorFondo = _obtenerColorCurso(clase.curso);
        final Color colorTexto = colorFondo.computeLuminance() > 0.6 ? Colors.black87 : Colors.white;

        bloques.add(
          Positioned(
            left: left + 2, top: top + 1,
            width: widthColumnaDia - 4, height: height - 2,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorFondo,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(clase.curso, 
                    style: TextStyle(color: colorTexto, fontSize: 10, fontWeight: FontWeight.bold, height: 1.1),
                    maxLines: 3, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(clase.aula, 
                    style: TextStyle(color: colorTexto.withOpacity(0.8), fontSize: 9),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        );
      }
    }
    return bloques;
  }

  // --- MÉTODOS ESPEJO PARA PDF (pw.Widget) ---

  pw.Widget _dibujarGrillaPdf(int total, int inicio, double ancho) {
    return pw.Column(children: [
      pw.SizedBox(height: heightHeader),
      ...List.generate(total, (i) => pw.Container(
        height: heightHora, width: ancho,
        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200))),
        child: pw.Row(children: [
          pw.Container(
            width: widthColumnaHora, alignment: pw.Alignment.topCenter, padding: const pw.EdgeInsets.only(top: 5),
            decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(color: PdfColors.grey300))),
            child: pw.Text('${inicio + i}:00', style: pw.TextStyle(fontSize: 10, color: PdfColor.fromInt(rojoOscuro.value), fontWeight: pw.FontWeight.bold)),
          )
        ]),
      ))
    ]);
  }

  pw.Widget _dibujarCabecerasPdf() {
    return pw.Row(children: [
      pw.Container(width: widthColumnaHora, height: heightHeader, color: PdfColor.fromInt(rojoOscuro.value)),
      ...diasSemana.map((dia) => pw.Container(
        width: widthColumnaDia, height: heightHeader, color: PdfColor.fromInt(rojoOscuro.value), alignment: pw.Alignment.center,
        child: pw.Text(dia.toUpperCase(), style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 12)),
      )),
    ]);
  }

  List<pw.Widget> _generarBloquesPdf(int horaInicioGrid) {
    List<pw.Widget> bloques = [];
    final diasData = widget.horarioResponse.horarios.first.dias;

    for (var diaData in diasData) {
      int indexCol = diasSemana.indexWhere((d) => d.toLowerCase().contains(diaData.dia.toLowerCase().substring(0, 3)));
      if (indexCol == -1) continue;

      for (var clase in diaData.clases) {
        final double inicio = _parseHora(clase.horaInicio);
        final double fin = _parseHora(clase.horaFin);
        final double top = heightHeader + ((inicio - horaInicioGrid) * heightHora);
        final double height = (fin - inicio) * heightHora;
        final double left = widthColumnaHora + (indexCol * widthColumnaDia);

        final Color c = _obtenerColorCurso(clase.curso);
        final PdfColor colorF = PdfColor.fromInt(c.value);
        final PdfColor colorT = c.computeLuminance() > 0.6 ? PdfColors.black : PdfColors.white;

        bloques.add(
          pw.Positioned(
            left: left + 2, top: top + 1,
            child: pw.Container(
              width: widthColumnaDia - 4, height: height - 2,
              padding: const pw.EdgeInsets.all(5),
              decoration: pw.BoxDecoration(color: colorF, borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6))),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(clase.curso, style: pw.TextStyle(color: colorT, fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 2),
                  pw.Text(clase.aula, style: pw.TextStyle(color: colorT, fontSize: 7)),
                ],
              ),
            ),
          ),
        );
      }
    }
    return bloques;
  }
}