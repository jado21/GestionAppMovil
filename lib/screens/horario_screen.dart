import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/horario_response.dart';
import '../models/clase.dart';
import '../utils/format_helpers.dart';
import 'cursos_screen.dart';

class ResultadoScreen extends StatefulWidget {
  final HorarioResponse horarioResponse;
  final String periodo;
  final String escuela;
  final String ciclo;
  final String grupo;

  const ResultadoScreen({
    super.key,
    required this.horarioResponse,
    required this.periodo,
    required this.escuela,
    required this.ciclo,
    required this.grupo,
  });

  @override
  State<ResultadoScreen> createState() => _ResultadoScreenState();
}

class _ResultadoScreenState extends State<ResultadoScreen> {
  final double anchoColumnaHora = 44.0;
  double anchoColumnaDia = 90.0;
  final double altoHora = 55.0;
  final double altoCabecera = 40.0;
  final Color rojoOscuro = const Color(0xFFA80010);

  final int horaInicioGlobal = 8;
  final int horaFinGlobal = 22;

  final List<String> diasSemana = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'
  ];

  late Map<String, Color> _cursoColores;

  final List<Color> _paletaColores = const [
    Color(0xFF3B82F6),
    Color(0xFF10B981),
    Color(0xFFF97316),
    Color(0xFFA855F7),
    Color(0xFFF43F5E),
    Color(0xFF14B8A6),
    Color(0xFFF59E0B),
    Color(0xFF0EA5E9),
    Color(0xFFEF4444),
    Color(0xFF6366F1),
  ];

  @override
  void initState() {
    super.initState();
    _cursoColores = {};
    Map<String, String> cursosAgrupados = {};

    for (var clasesDelDia in widget.horarioResponse.horarios.values) {
      for (var clase in clasesDelDia) {
        final nombreCurso = clase.curso.trim();
        if (nombreCurso.isEmpty) continue;
        
        final key = nombreCurso.toLowerCase();
        if (!cursosAgrupados.containsKey(key)) {
          cursosAgrupados[key] = nombreCurso;
        }
      }
    }
    
    List<String> listaCursos = cursosAgrupados.values.toList()..sort();
    
    for (int i = 0; i < listaCursos.length; i++) {
      _cursoColores[listaCursos[i]] = _paletaColores[i % _paletaColores.length];
      _cursoColores[listaCursos[i].toLowerCase()] = _paletaColores[i % _paletaColores.length];
    }
  }

  Color _obtenerColorCurso(String nombre) {
    return _cursoColores[nombre.trim()] ?? _cursoColores[nombre.trim().toLowerCase()] ?? const Color(0xFF607D8B);
  }

  IconData _obtenerIconoTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'teoria':
      case 'teoría':
        return Icons.menu_book_rounded;
      case 'laboratorio':
        return Icons.science_rounded;
      case 'practica':
      case 'práctica':
        return Icons.edit_note_rounded;
      default:
        return Icons.class_rounded;
    }
  }



  Color _obtenerColorTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'teoria':
      case 'teoría':
        return const Color(0xFF1E88E5);
      case 'laboratorio':
        return const Color(0xFF43A047);
      case 'practica':
      case 'práctica':
        return const Color(0xFFFB8C00);
      default:
        return const Color(0xFF607D8B);
    }
  }

  double _parseHora(String horaString) {
    try {
      final parts = horaString.split(':');
      return int.parse(parts[0]) + (int.parse(parts[1]) / 60.0);
    } catch (e) {
      return 0.0;
    }
  }


  void _mostrarDetalleClase(Clase clase, String dia) {
    final colorTipo = _obtenerColorTipo(clase.tipo);
    final iconTipo = _obtenerIconoTipo(clase.tipo);

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * value),
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: child,
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.82,
                constraints: const BoxConstraints(maxWidth: 380),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 30,
                      spreadRadius: 2,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 22, 16, 18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _obtenerColorCurso(clase.curso),
                            _obtenerColorCurso(clase.curso).withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  clase.curso,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.access_time_rounded,
                                    color: Colors.white, size: 14),
                                const SizedBox(width: 5),
                                Text(
                                  '$dia • ${clase.horaInicio} - ${clase.horaFin}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                      child: Column(
                        children: [
                          _DetalleRow(
                            icon: Icons.person_rounded,
                            iconColor: const Color(0xFF546E7A),
                            label: 'Docente',
                            value: FormatHelpers.formatDocente(clase.docente),
                          ),
                          const SizedBox(height: 14),

                          _DetalleRow(
                            icon: iconTipo,
                            iconColor: colorTipo,
                            label: 'Tipo de clase',
                            value: FormatHelpers.formatTipoClase(clase.tipo),
                            badgeColor: colorTipo,
                          ),
                          const SizedBox(height: 14),

                          _DetalleRow(
                            icon: Icons.room_rounded,
                            iconColor: const Color(0xFFE53935),
                            label: 'Aula',
                            value: FormatHelpers.formatAula(clase.aula, conPrefijo: true),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Exportación a PDF

  Future<void> _exportarPDF() async {
    final pdf = pw.Document();

    final String tituloPrincipal = 'Horario ${widget.periodo} | Ciclo ${widget.ciclo}';
    final String subtitulo = (widget.ciclo == '1' || widget.ciclo == 'I') ? 'Grupo ${widget.grupo}' : 'Grupo ${widget.grupo} | ${widget.escuela}';
    final double altoHeaderPdf = subtitulo.isEmpty ? 35.0 : 45.0;

    final double anchoColumnaDiaPdf = (PdfPageFormat.a4.width - anchoColumnaHora) / diasSemana.length;

    final double anchoTotal =
        anchoColumnaHora + (diasSemana.length * anchoColumnaDiaPdf);
    final double altoTotal =
        altoCabecera + ((horaFinGlobal - horaInicioGlobal + 1) * altoHora) + altoHeaderPdf;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(anchoTotal, altoTotal, marginAll: 0),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 10, top: 10, right: 10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      tituloPrincipal,
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    if (subtitulo.isNotEmpty) ...[
                      pw.SizedBox(height: 3),
                      pw.Text(
                        subtitulo,
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              pw.SizedBox(height: 5),
              pw.SizedBox(
                width: anchoTotal,
                height: altoTotal - altoHeaderPdf - 5,
                child: pw.Stack(
                  children: [
                    _dibujarGrillaPdf(
                        horaFinGlobal - horaInicioGlobal + 1, horaInicioGlobal, anchoTotal),
                    _dibujarCabecerasPdf(anchoColumnaDiaPdf),
                    ..._generarBloquesPdf(horaInicioGlobal, anchoColumnaDiaPdf),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) => pdf.save(),
      name: 'Horario_Grupo.pdf',
    );
  }



  @override
  Widget build(BuildContext context) {
    final double anchoPantalla = MediaQuery.of(context).size.width;
    final double anchoCalculado = (anchoPantalla - anchoColumnaHora) / diasSemana.length;
    anchoColumnaDia = anchoCalculado > 90.0 ? anchoCalculado : 90.0;

    final double anchoTotal =
        anchoColumnaHora + (diasSemana.length * anchoColumnaDia);
    final int totalFilas = horaFinGlobal - horaInicioGlobal + 1;
    final double altoTotal = altoCabecera + (totalFilas * altoHora);

    final String tituloPrincipal = 'Horario ${widget.periodo} • Ciclo ${widget.ciclo}';
        
    final String subtitulo = (widget.ciclo == '1' || widget.ciclo == 'I')
        ? 'Grupo ${widget.grupo}'
        : 'Grupo ${widget.grupo} • ${widget.escuela}';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tituloPrincipal,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitulo.isNotEmpty)
              Text(
                subtitulo,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
        backgroundColor: rojoOscuro,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded, size: 22),
            onPressed: _exportarPDF,
            tooltip: 'Exportar a PDF',
          ),
          IconButton(
            icon: const Icon(Icons.menu_book_rounded, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 400),
                  reverseTransitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return CursosScreen(
                      horarioResponse: widget.horarioResponse,
                      periodo: widget.periodo,
                      escuela: widget.escuela,
                      ciclo: widget.ciclo,
                      grupo: widget.grupo,
                    );
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    final curved = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                    );
                    return FadeTransition(
                      opacity: curved,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0),
                          end: Offset.zero,
                        ).animate(curved),
                        child: child,
                      ),
                    );
                  },
                ),
              );
            },
            tooltip: 'Ver cursos',
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app_rounded, size: 22),
            onPressed: () => SystemNavigator.pop(),
            tooltip: 'Salir',
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
                _dibujarGrillaFondoUI(totalFilas, horaInicioGlobal, anchoTotal),
                _dibujarCabecerasUI(),
                ..._generarBloquesUI(horaInicioGlobal),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dibujarGrillaFondoUI(int total, int inicio, double ancho) {
    return Column(
      children: [
        SizedBox(height: altoCabecera),
        ...List.generate(
          total,
          (i) => Container(
            height: altoHora,
            width: ancho,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: anchoColumnaHora,
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    border: Border(
                      right: BorderSide(color: Colors.grey[300]!, width: 0.5),
                    ),
                  ),
                  child: Text(
                    '${inicio + i}:00',
                    style: TextStyle(
                      fontSize: 10,
                      color: rojoOscuro,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dibujarCabecerasUI() {
    return Row(
      children: [
        Container(
          width: anchoColumnaHora,
          height: altoCabecera,
          decoration: BoxDecoration(
            color: rojoOscuro,
          ),
        ),
        ...diasSemana.map(
          (dia) => Container(
            width: anchoColumnaDia,
            height: altoCabecera,
            decoration: BoxDecoration(
              color: rojoOscuro,
              border: Border(
                left: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 0.5,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              dia.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _generarBloquesUI(int horaInicioGrid) {
    List<Widget> bloques = [];
    if (widget.horarioResponse.horarios.isEmpty) return [];

    //final diasData = widget.horarioResponse.horarios.first.dias;

    for (var diaData in diasSemana) {

      final clasesDelDia=widget.horarioResponse.horarios[diaData];

      if (clasesDelDia == null) continue;

      int indexColumna = diasSemana.indexWhere(
          (d) => d.toLowerCase().contains(diaData.toLowerCase().substring(0, 3)));
      if (indexColumna == -1) continue;

      for (var clase in clasesDelDia) {
        final double inicio = _parseHora(clase.horaInicio);
        final double fin = _parseHora(clase.horaFin);

        final double top =
            altoCabecera + ((inicio - horaInicioGrid) * altoHora);
        final double height = (fin - inicio) * altoHora;
        final double left = anchoColumnaHora + (indexColumna * anchoColumnaDia);

        final Color colorFondo = _obtenerColorCurso(clase.curso);
        final Color colorTexto =
            colorFondo.computeLuminance() > 0.6 ? Colors.black87 : Colors.white;

        bloques.add(
          Positioned(
            left: left + 1.5,
            top: top + 1,
            width: anchoColumnaDia - 3,
            height: height - 2,
            child: GestureDetector(
              onTap: () => _mostrarDetalleClase(clase, diaData),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorFondo,
                      colorFondo.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: colorFondo.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      clase.curso,
                      style: TextStyle(
                        color: colorTexto,
                        fontSize: 8.5,
                        fontWeight: FontWeight.bold,
                        height: 1.15,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    if (clase.tipo.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: colorTexto.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          FormatHelpers.formatTipoClase(clase.tipo),
                          style: TextStyle(
                            color: colorTexto.withValues(alpha: 0.9),
                            fontSize: 7,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    const SizedBox(height: 1),
                    Text(
                      FormatHelpers.formatAula(clase.aula, conPrefijo: true),
                      style: TextStyle(
                        color: colorTexto.withValues(alpha: 0.75),
                        fontSize: 7.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),),
              ),
            ),
          ),
        );
      }
    }
    return bloques;
  }

  pw.Widget _dibujarGrillaPdf(int total, int inicio, double ancho) {
    return pw.Column(
      children: [
        pw.SizedBox(height: altoCabecera),
        ...List.generate(
          total,
          (i) => pw.Container(
            height: altoHora,
            width: ancho,
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200)),
            ),
            child: pw.Row(
              children: [
                pw.Container(
                  width: anchoColumnaHora,
                  alignment: pw.Alignment.topCenter,
                  padding: const pw.EdgeInsets.only(top: 4),
                  decoration: const pw.BoxDecoration(
                    border:
                        pw.Border(right: pw.BorderSide(color: PdfColors.grey300)),
                  ),
                  child: pw.Text(
                    '${inicio + i}:00',
                    style: pw.TextStyle(
                      fontSize: 9,
                      color: PdfColor.fromInt(rojoOscuro.toARGB32()),
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _dibujarCabecerasPdf(double anchoColDiaPdf) {
    return pw.Row(
      children: [
        pw.Container(
          width: anchoColumnaHora,
          height: altoCabecera,
          color: PdfColor.fromInt(rojoOscuro.toARGB32()),
        ),
        ...diasSemana.map(
          (dia) => pw.Container(
            width: anchoColDiaPdf,
            height: altoCabecera,
            color: PdfColor.fromInt(rojoOscuro.toARGB32()),
            alignment: pw.Alignment.center,
            child: pw.Text(
              dia.toUpperCase(),
              style: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<pw.Widget> _generarBloquesPdf(int horaInicioGrid, double anchoColDiaPdf) {
    List<pw.Widget> bloques = [];
    if (widget.horarioResponse.horarios.isEmpty) return [];
    
    //final diasData = widget.horarioResponse.horarios.first.dias;


    for (var diaData in diasSemana) {

      final clasesDelDia = widget.horarioResponse.horarios[diaData];

      if (clasesDelDia == null) continue;

      int indexCol = diasSemana.indexWhere(
          (d) => d.toLowerCase().contains(diaData.toLowerCase().substring(0, 3)));
      if (indexCol == -1) continue;

      for (var clase in clasesDelDia) {
        final double inicio = _parseHora(clase.horaInicio);
        final double fin = _parseHora(clase.horaFin);
        final double top =
            altoCabecera + ((inicio - horaInicioGrid) * altoHora);
        final double height = (fin - inicio) * altoHora;
        final double left = anchoColumnaHora + (indexCol * anchoColDiaPdf);

        final Color c = _obtenerColorCurso(clase.curso);
        final PdfColor colorF = PdfColor.fromInt(c.toARGB32());
        final PdfColor colorT =
            c.computeLuminance() > 0.6 ? PdfColors.black : PdfColors.white;

        bloques.add(
          pw.Positioned(
            left: left + 1.5,
            top: top + 1,
            child: pw.Container(
              width: anchoColDiaPdf - 3,
              height: height - 2,
              padding: const pw.EdgeInsets.all(4),
              decoration: pw.BoxDecoration(
                color: colorF,
                borderRadius:
                    const pw.BorderRadius.all(pw.Radius.circular(5)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    clase.curso,
                    style: pw.TextStyle(
                      color: colorT,
                      fontSize: 7,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    FormatHelpers.formatTipoClase(clase.tipo),
                    style: pw.TextStyle(color: colorT, fontSize: 6),
                  ),
                  pw.SizedBox(height: 1),
                  pw.Text(
                    FormatHelpers.formatAula(clase.aula, conPrefijo: true),
                    style: pw.TextStyle(color: colorT, fontSize: 6),
                  ),
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

class _DetalleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? badgeColor;

  const _DetalleRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              badgeColor != null
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor!.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: badgeColor!.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        value,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : Text(
                      value,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}