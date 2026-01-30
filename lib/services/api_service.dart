import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/horario_model.dart';
import '../models/horario_view_model.dart';

class ApiService {
  // Caché estática para que los datos persistan entre pantallas
  static List<HorarioDetallado> _cacheDetallada = [];

  /// Guarda los datos del Excel clasificándolos
  Future<void> guardarMuchosHorarios(List<Horario> nuevosHorariosBase) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final nuevosDetallados = nuevosHorariosBase.map((h) {
      return HorarioDetallado(
        horario: h,
        nombreCurso: "Curso Importado", 
        codigoAsignatura: "FISI-UNMSM",
        nombreDocente: "Por asignar",
      );
    }).toList();

    _cacheDetallada.addAll(nuevosDetallados);
    debugPrint("ApiService: ${nuevosDetallados.length} registros añadidos.");
  }

  /// NUEVO: Obtener horarios filtrados por Periodo y Grupo
  Future<List<HorarioDetallado>> obtenerHorariosPorFiltro(String periodo, int grupo) async {
    // Si la caché está vacía, intentamos cargar el JSON base primero
    if (_cacheDetallada.isEmpty) await cargarHorariosCompletos();

    return _cacheDetallada.where((h) => 
      h.horario.periodo == periodo && 
      h.horario.grupoNumero == grupo
    ).toList();
  }

  Future<List<HorarioDetallado>> cargarHorariosCompletos() async {
    if (_cacheDetallada.isNotEmpty) return _cacheDetallada;

    try {
      final String response = await rootBundle.loadString('assets/data.json');
      final Map<String, dynamic> data = json.decode(response);

      final List asignaturas = data['asignaturas'] ?? [];
      final List docentes = data['docentes'] ?? [];
      final List grupos = data['grupos'] ?? [];

      List<Horario> horariosBase = (data['horarios'] as List)
          .map((item) => Horario.fromJson(item))
          .toList();

      _cacheDetallada = horariosBase.map((h) {
        final grupo = grupos.firstWhere((g) => g['id'] == h.grupoId, orElse: () => {});
        final asignatura = asignaturas.firstWhere((a) => a['id'] == grupo['asignatura_id'], orElse: () => {});
        final docente = docentes.firstWhere((d) => d['id'] == grupo['docente_id'], orElse: () => {});

        return HorarioDetallado(
          horario: h,
          nombreCurso: asignatura['nombre'] ?? "Curso no encontrado",
          codigoAsignatura: asignatura['codigo'] ?? "N/A",
          nombreDocente: docente['nombre'] != null 
              ? "${docente['nombre']} ${docente['apellido']}" 
              : "Docente no asignado",
        );
      }).toList();

      return _cacheDetallada;
    } catch (e) {
      debugPrint("Error al cargar JSON: $e");
      return _cacheDetallada;
    }
  }

  void limpiarDatos() {
    _cacheDetallada.clear();
    debugPrint("ApiService: Memoria vaciada.");
  }
}