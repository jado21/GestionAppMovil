import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/escuela_response.dart';
import '../models/horario_response.dart';
import 'preference_service.dart';

class ApiService {
  static final Map<String, HorarioResponse> _horariosCache = {};

  static String _buildHorarioCacheKey(
    String ciclo,
    String grupo,
    String escuela,
  ) {
    return '$escuela|$ciclo|$grupo';
  }

  static Future<HorarioResponse> enviarCicloGrupo(
      String ciclo, String grupo, String escuela) async {
    final cacheKey = _buildHorarioCacheKey(ciclo, grupo, escuela);
    final cachedResponse = _horariosCache[cacheKey];

    if (cachedResponse != null) {
      return cachedResponse;
    }

    final persistedResponse = await PreferencesService.obtenerHorario(cacheKey);
    if (persistedResponse != null) {
      final horarioResponse = HorarioResponse.fromJson(persistedResponse);
      _horariosCache[cacheKey] = horarioResponse;
      return horarioResponse;
    }

    final uri = Uri.parse(
      'https://gestion-horarios-backend.onrender.com/horarios/api/horarios/'
    ).replace(
      queryParameters: {
        'escuela': escuela,
        'ciclo': ciclo,
        'grupo': grupo,
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Token 251b33a5af4a22f3889800890351ac79bfcb417f',
        'Content-Type': 'application/json', 
      },
      );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final horarioResponse = HorarioResponse.fromJson(decodedResponse);

      _horariosCache[cacheKey] = horarioResponse;
      await PreferencesService.guardarHorario(cacheKey, decodedResponse);

      return horarioResponse;
    } else {
      throw Exception('Error en el request');
    }
  }

  static Future<EscuelaResponse> obtenerEscuelas() async{
    final uri = Uri.parse('https://gestion-horarios-backend.onrender.com/escuelas/api/escuelas/fisi/');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json', 
      },
      );

      if (response.statusCode == 200) {
      final String decodedBody = utf8.decode(response.bodyBytes); // Permite obtener datos y evitar problemas con las tildes
      
      return EscuelaResponse.fromJson(jsonDecode(decodedBody));
    } else {
      throw Exception('Error en el request');
    }
      
  }
}
