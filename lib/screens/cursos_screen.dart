import 'package:flutter/material.dart';
import '../models/horario_response.dart';

class CursosScreen extends StatelessWidget {
  final HorarioResponse horarioResponse;

  const CursosScreen({super.key, required this.horarioResponse});
  
  static const Map<String, Color> mapaColoresCursos = {
    'REDACCIÓN': Color(0xFF3B82F6),
    'CÁLCULO': Color(0xFF10B981),
    'CALCULO': Color(0xFF10B981), // Versión sin tilde por si acaso
    'ÁLGEBRA': Color(0xFFF97316),
    'METODOS': Color(0xFFA855F7),
    'BIOLOGÍA': Color(0xFFF43F5E),
    'PROGRAMACIÓN': Color(0xFF14B8A6),
    'MEDIO AMBIENTE': Color(0xFFF59E0B),
    'DESARROLLO': Color(0xFF0EA5E9),
    'FÍSICA': Color(0xFFEF4444),
    'QUÍMICA': Color(0xFF6366F1),
  };

  Color _obtenerColorCurso(String nombre) {
    String n = nombre.toUpperCase();
    for (var e in mapaColoresCursos.entries) {
      if (n.contains(e.key)) return e.value;
    }
    return Colors.blueGrey; 
  }

  @override
  Widget build(BuildContext context) {
    const Color rojoOscuro = Color(0xFFA80010);
    const Color headerBackground = Color(0xFFF5F5F5);

    final cursosAgrupados = _agruparCursos(horarioResponse);
    final rows = _buildRows(cursosAgrupados, '');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Cursos - Ciclo ',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: rojoOscuro,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: rows.isEmpty
            ? const Center(
                child: Text(
                  'No hay cursos para mostrar.',
                  style: TextStyle(color: Colors.black54),
                ),
              )
            : DecoratedBox(
                decoration: BoxDecoration(
                  color: headerBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(headerBackground),
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      dataRowMinHeight: 34,
                      dataRowMaxHeight: double.infinity,
                      columns: [
                        DataColumn(
                          label: SizedBox(
                            width: 220,
                            child: _CursoHeader(),
                          ),
                        ),
                      
                      const DataColumn(label: Text('Docente')),
                      const DataColumn(label: Text('Tipo')),
                      const DataColumn(label: Text('Día')),
                      const DataColumn(label: Text('Hora Inicio')),
                      const DataColumn(label: Text('Hora Fin')),
                      const DataColumn(label: Text('Aula')),
                      //const DataColumn(label: Text('Grupo')),
                    ],
                      rows: rows,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  // ... (Métodos _agruparCursos, _docentePrincipal, etc. se mantienen igual)

  Map<String, _CursoAgrupado> _agruparCursos(HorarioResponse response) {
  final cursos = <String, _CursoAgrupado>{};

  for (final entry in response.horarios.entries) {
    final nombreDia = entry.key;
    final clases = entry.value;

    for (final clase in clases) {
      final nombreCurso = clase.curso.trim();
      if (nombreCurso.isEmpty) continue;

      final key = nombreCurso.toLowerCase();
      final curso = cursos.putIfAbsent(
        key,
        () => _CursoAgrupado(nombre: nombreCurso),
      );

      curso.sesiones.add(
        _SesionCurso(
          docente: _displayValue(clase.docente),
          tipo: _formatTipo(clase.tipo),
          dia: nombreDia,
          horaInicio: clase.horaInicio,
          horaFin: clase.horaFin,
          aula: _displayAula(clase.aula),
        ),
      );
    }
  }

  for (final curso in cursos.values) {
    curso.sesiones.sort((a, b) {
      final diaComp = _ordenDia(a.dia).compareTo(_ordenDia(b.dia));
      if (diaComp != 0) return diaComp;
      return a.horaInicio.compareTo(b.horaInicio);
    });
  }

  return cursos;
}

  List<DataRow> _buildRows(Map<String, _CursoAgrupado> cursos, String grupo) {
    final listaCursos = cursos.values.toList()
      ..sort((a, b) => a.nombre.compareTo(b.nombre));

    return listaCursos.map((curso) {
      // Obtenemos el color dinámico para este curso específico
      final Color colorFondo = _obtenerColorCurso(curso.nombre);
      // Calculamos si el texto debe ser blanco o negro según el fondo
      final Color colorTexto = colorFondo.computeLuminance() > 0.6 ? Colors.black87 : Colors.white;

      return DataRow(cells: [
        DataCell(
          SizedBox(
            width: 220,
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: colorFondo, // COLOR DINÁMICO APLICADO
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                curso.nombre,
                softWrap: true,
                style: TextStyle(
                  color: colorTexto, // COLOR DE TEXTO INTELIGENTE
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        DataCell(_buildDocenteCell(curso.sesiones)),
        DataCell(_buildMiniRows(curso.sesiones, (s) => s.tipo, width: 110)),
        DataCell(_buildMiniRows(curso.sesiones, (s) => s.dia, width: 110)),
        DataCell(_buildMiniRows(curso.sesiones, (s) => s.horaInicio, width: 95)),
        DataCell(_buildMiniRows(curso.sesiones, (s) => s.horaFin, width: 95)),
        DataCell(_buildMiniRows(curso.sesiones, (s) => s.aula, width: 115)),
        //DataCell(Text(grupo)),
      ]);
    }).toList();
  }

  // ... (Resto de métodos auxiliares: _buildDocenteCell, _buildMiniRows, _ordenDia, etc.)

  Widget _buildDocenteCell(List<_SesionCurso> sesiones) {
    if (sesiones.isEmpty) return const Text('-');
    return Text(_docentePrincipal(sesiones));
  }

  Widget _buildMiniRows(
    List<_SesionCurso> sesiones,
    String Function(_SesionCurso sesion) getText,
    {double width = 170}
  ) {
    if (sesiones.isEmpty) return const Text('-');

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: sesiones.map((sesion) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.5),
            child: Text(
              getText(sesion),
              style: const TextStyle(fontSize: 11.5, height: 1.1),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _docentePrincipal(List<_SesionCurso> sesiones) {
    final docentes = sesiones.map((s) => s.docente).toSet().toList();
    final primeroValido = docentes.firstWhere(
      (d) => d.trim().isNotEmpty && d != 'Sin asignar',
      orElse: () => docentes.first,
    );
    return primeroValido;
  }

  int _ordenDia(String dia) {
    final d = dia.toLowerCase();
    if (d.startsWith('lun')) return 1;
    if (d.startsWith('mar')) return 2;
    if (d.startsWith('mie')) return 3;
    if (d.startsWith('jue')) return 4;
    if (d.startsWith('vie')) return 5;
    if (d.startsWith('sab')) return 6;
    return 99;
  }

  String _displayValue(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'es none' || normalized == 'none' || normalized.isEmpty) {
      return 'Sin asignar';
    }
    return value;
  }

  String _displayAula(String aula) {
    if (aula == '0' || aula.trim().isEmpty || aula.toLowerCase() == 'none') {
      return 'Sin asignar';
    }
    return 'Aula $aula';
  }

  String _formatTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'teoria':
      case 'teoría':
        return 'Teoría';
      case 'laboratorio':
        return 'Laboratorio';
      case 'practica':
      case 'práctica':
        return 'Práctica';
      default:
        return tipo.isEmpty ? '-' : tipo;
    }
  }
}

// ... (Clases auxiliares _CursoAgrupado, _SesionCurso, _CursoHeader se mantienen igual)

class _CursoAgrupado {
  final String nombre;
  final List<_SesionCurso> sesiones = [];

  _CursoAgrupado({required this.nombre});
}

class _SesionCurso {
  final String docente;
  final String tipo;
  final String dia;
  final String horaInicio;
  final String horaFin;
  final String aula;

  _SesionCurso({
    required this.docente,
    required this.tipo,
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
    required this.aula,
  });
}

class _CursoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.menu_book, size: 18, color: Colors.black87),
        SizedBox(width: 6),
        Text(
          'Curso',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}