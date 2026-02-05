import 'horario.dart';

class HorarioResponse {
  final String grupo;
  final List<Horario> horarios;

  HorarioResponse({
    required this.grupo,
    required this.horarios,
  });

  factory HorarioResponse.fromJson(Map<String, dynamic> json) {
    return HorarioResponse(
      grupo: json['grupo'],
      horarios: (json['horarios'] as List)
          .map((e) => Horario.fromJson(e))
          .toList(),
    );
  }
}
