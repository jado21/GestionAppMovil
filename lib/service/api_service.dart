import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/escuela_response.dart';
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

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Token edacc73d6ac9a077fa0e93fd0f4c9d942ff7fac9',
        'Content-Type': 'application/json', 
      },
      );

    if (response.statusCode == 200) {
      return HorarioResponse.fromJson(
        jsonDecode(response.body),
      );
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