import 'package:flutter/material.dart';
import '../models/horario_response.dart';
import '../models/dia.dart';

class CursosScreen extends StatelessWidget {
  final HorarioResponse horarioResponse;

  const CursosScreen({super.key, required this.horarioResponse});

  @override
  Widget build(BuildContext context) {
    const Color rojoOscuro = Color(0xFFA80010);
    const Color headerBackground = Color(0xFFF5F5F5);

    final rows = _buildRows(horarioResponse);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Cursos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                      dataRowMinHeight: 40,
                    columns: [
                      DataColumn(
                        label: SizedBox(
                          width: 220,
                          child: _CursoHeader(),
                        ),
                      ),
                      const DataColumn(label: Text('Docente')),
                      const DataColumn(label: Text('Día')),
                      const DataColumn(label: Text('Hora Inicio')),
                      const DataColumn(label: Text('Hora Fin')),
                      const DataColumn(label: Text('Aula')),
                      const DataColumn(label: Text('Grupo')),
                    ],
                      rows: rows,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  List<DataRow> _buildRows(HorarioResponse response) {
    final rows = <DataRow>[];
    final grupo = response.grupo;

    for (final horario in response.horarios) {
      for (final dia in horario.dias) {
        rows.addAll(_rowsForDia(dia, grupo));
      }
    }

    return rows;
  }

  List<DataRow> _rowsForDia(Dia dia, String grupo) {
    return dia.clases.map((clase) {
      return DataRow(cells: [
        DataCell(
          SizedBox(
            width: 220,
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                clase.curso,
                softWrap: true,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        DataCell(Text(_displayValue(clase.docente))),
        DataCell(Text(dia.dia)),
        DataCell(Text(clase.horaInicio)),
        DataCell(Text(clase.horaFin)),
        DataCell(Text(_displayValue(clase.aula))),
        DataCell(Text(grupo)),
      ]);
    }).toList();
  }

  String _displayValue(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'es none' || normalized == 'none' || normalized.isEmpty) {
      return 'Sin asignar';
    }
    return value;
  }
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
