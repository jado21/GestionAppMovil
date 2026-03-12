class Clase {
  final String curso;
  final String docente;
  final String aula;
  final String tipo;
  final String horaInicio;
  final String horaFin;

  Clase({
    required this.curso,
    required this.docente,
    required this.aula,
    required this.tipo,
    required this.horaInicio,
    required this.horaFin,
  });

  factory Clase.fromJson(Map<String, dynamic> json) {
    return Clase(
      curso: json['curso'] ?? '',
      docente: json['docente'] ?? '',
      aula: json['aula']?.toString() ?? '',
      tipo: json['tipo'] ?? '',
      horaInicio: json['hora_inicio'] ?? '',
      horaFin: json['hora_fin'] ?? '',
    );
  }
}
