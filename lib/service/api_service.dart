import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/horario_response.dart';

class ApiService {

  static Future<HorarioResponse> enviarCicloGrupo(
      String ciclo, String grupo, String escuela) async {

    final uri = Uri.parse(
      'https://gestion-horarios-backend.onrender.com/horarios/api/horarios/'
    ).replace(
      queryParameters: {
        'escuela': escuela,
        'ciclo': ciclo,
        'grupo': grupo,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return HorarioResponse.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception('Error en el request');
    }
  }
}