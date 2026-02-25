import 'horario.dart';

class HorarioResponse {
  final String ciclo;
  final String grupo;
  final List<Horario> horarios;

  HorarioResponse({
    required this.ciclo,
    required this.grupo,
    required this.horarios,
  });

  factory HorarioResponse.fromJson(Map<String, dynamic> json) {
    return HorarioResponse(
      ciclo: json['ciclo'],
      grupo: json['grupo'],
      horarios: (json['horarios'] as List)
          .map((e) => Horario.fromJson(e))
          .toList(),
    );
  }
}
