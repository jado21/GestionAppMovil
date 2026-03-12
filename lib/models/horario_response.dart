import 'clase.dart';

class HorarioResponse {
  final Map<String, List<Clase>> horarios;

  HorarioResponse({required this.horarios});

  factory HorarioResponse.fromJson(Map<String, dynamic> json) {
    Map<String, List<Clase>> resultado = {};

    json.forEach((dia, listaClases) {
      resultado[dia] = (listaClases as List)
          .map((item) => Clase.fromJson(item))
          .toList();
    });

    return HorarioResponse(horarios: resultado);
  }
}
