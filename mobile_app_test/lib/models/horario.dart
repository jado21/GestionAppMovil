import 'dia.dart';

class Horario {
  final List<Dia> dias;

  Horario({required this.dias});

  factory Horario.fromJson(Map<String, dynamic> json) {
    return Horario(
      dias: (json['dias'] as List)
          .map((e) => Dia.fromJson(e))
          .toList(),
    );
  }
}
