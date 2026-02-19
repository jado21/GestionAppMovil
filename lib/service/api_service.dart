import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/horario_response.dart';

class ApiService {
  
  static Future<HorarioResponse> enviarCicloGrupo(
      String ciclo, String grupo) async {

    final response = await http.post(
      Uri.parse('https://testserver-vq3x.onrender.com/api/obtener-horario/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'grupo': grupo,
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
