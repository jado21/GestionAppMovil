import 'clase.dart';

class Dia {
  final String dia;
  final List<Clase> clases;

  Dia({
    required this.dia,
    required this.clases,
  });

  factory Dia.fromJson(Map<String, dynamic> json) {
    return Dia(
      dia: json['dia'],
      clases: (json['clases'] as List)
          .map((e) => Clase.fromJson(e))
          .toList(),
    );
  }
}
