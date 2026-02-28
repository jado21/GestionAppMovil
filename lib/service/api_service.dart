import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/horario_response.dart';

class ApiService {
  
  static Future<HorarioResponse> enviarCicloGrupo(
      String ciclo, String grupo, String escuela) async {

    final response = await http.post(
      Uri.parse('https://testserver-vq3x.onrender.com/api/obtener-horario/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'escuela': escuela,
        'ciclo': int.tryParse(ciclo) ?? 1,
        'grupo': int.tryParse(grupo) ?? 1,
      }),
    );

    if (response.statusCode == 200) {
      return HorarioResponse.fromJson(
      jsonDecode(response.body)
      );
    } else {
      throw Exception('Error en el request');
    }
  }
}
