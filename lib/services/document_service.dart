import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../models/horario_model.dart';

class DocumentService {
  /// Abre el selector de archivos, lee el Excel y detecta Periodo y Grupo
  Future<List<Horario>> importarDesdeExcel() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result == null) return [];

      var bytes = File(result.files.single.path!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      List<Horario> listaExtraida = [];

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table];
        if (sheet == null) continue;

        // Variables para detectar el contexto de la hoja
        String periodoDetectado = "25-0"; // Valor por defecto
        int grupoDetectado = 1;

        for (var row in sheet.rows) {
          if (row.isEmpty) continue;

          // 1. LÓGICA DE DETECCIÓN AUTOMÁTICA
          for (var cell in row) {
            if (cell == null) continue;
            String valor = cell.value.toString().toUpperCase();

            // Detectar Periodo (Ej: "2024-I", "2024-II")
            if (valor.contains("2024-I")) periodoDetectado = "24-I";
            if (valor.contains("2024-II")) periodoDetectado = "24-II";
            if (valor.contains("2025-0")) periodoDetectado = "25-0";

            // Detectar Grupo (Busca "GRUPO X" o "SECCIÓN X")
            if (valor.contains("GRUPO") || valor.contains("SECC")) {
              RegExp regExp = RegExp(r'\d+'); // Busca el número
              var match = regExp.firstMatch(valor);
              if (match != null) {
                grupoDetectado = int.parse(match.group(0)!);
              }
            }
          }

          // 2. EXTRACCIÓN DE CURSOS (Asumiendo que la fila tiene datos de horario)
          // Validamos que sea una fila de datos (Ej: que la celda 0 tenga el código o nombre)
          if (row.length > 5 && _esFilaDeDatos(row)) {
            listaExtraida.add(Horario(
              id: DateTime.now().millisecondsSinceEpoch + listaExtraida.length,
              tipo: row[2]?.value.toString() ?? "T", 
              dia: _formatearDia(row[3]?.value.toString() ?? "Lunes"),
              horaInicio: row[4]?.value.toString() ?? "08:00",
              horaFin: row[5]?.value.toString() ?? "10:00",
              aulaId: int.tryParse(row[6]?.value.toString() ?? "101") ?? 101,
              grupoId: 0, // Relación interna del JSON
              periodo: periodoDetectado,
              grupoNumero: grupoDetectado,
            ));
          }
        }
      }
      return listaExtraida;
    } catch (e) {
      debugPrint("Error leyendo Excel: $e");
      return [];
    }
  }

  /// Verifica si la fila contiene información de un curso y no es encabezado
  bool _esFilaDeDatos(List<Data?> row) {
    String val = row[0]?.value.toString().toLowerCase() ?? "";
    return val != "null" && val != "código" && val != "periodo" && val.isNotEmpty;
  }

  /// Normaliza el nombre del día para que coincida con nuestro filtro
  String _formatearDia(String dia) {
    dia = dia.trim().toLowerCase();
    if (dia.contains("lun")) return "Lunes";
    if (dia.contains("mar")) return "Martes";
    if (dia.contains("mié") || dia.contains("mie")) return "Miércoles";
    if (dia.contains("jue")) return "Jueves";
    if (dia.contains("vie")) return "Viernes";
    if (dia.contains("sáb") || dia.contains("sab")) return "Sábado";
    return "Lunes";
  }
}