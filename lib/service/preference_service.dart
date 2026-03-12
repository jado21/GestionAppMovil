import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _horarioPrefix = 'horario_json';

  static String _horarioKey(String key) => '$_horarioPrefix:$key';

  // GUARDAR JSON
  static Future<void> guardarHorario(
    String key,
    Map<String, dynamic> json,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(json);
    await prefs.setString(_horarioKey(key), jsonString);
  }

  // LEER JSON
  static Future<Map<String, dynamic>?> obtenerHorario(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_horarioKey(key));

    if (jsonString == null) return null;

    return jsonDecode(jsonString);
  }

  // BORRAR JSON
  static Future<void> borrarHorario(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_horarioKey(key));
  }

  static Future<void> borrarTodosLosHorarios() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_horarioPrefix));

    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
