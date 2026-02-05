import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _horarioKey = 'horario_json';

  // GUARDAR JSON
  static Future<void> guardarHorario(Map<String, dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(json);
    await prefs.setString(_horarioKey, jsonString);
  }

  // LEER JSON
  static Future<Map<String, dynamic>?> obtenerHorario() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_horarioKey);

    if (jsonString == null) return null;

    return jsonDecode(jsonString);
  }

  // BORRAR JSON
  static Future<void> borrarHorario() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_horarioKey);
  }
}
