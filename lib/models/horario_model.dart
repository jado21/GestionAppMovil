class Horario {
  final int id;
  final String tipo; 
  final String dia;
  final String horaInicio;
  final String horaFin;
  final int aulaId;
  final int grupoId; // ID relacional del JSON
  final String periodo; // NUEVO: "24-I", "24-II", etc.
  final int grupoNumero; // NUEVO: 1, 2, 3, 4, 5...

  Horario({
    required this.id, 
    required this.tipo, 
    required this.dia,
    required this.horaInicio, 
    required this.horaFin,
    required this.aulaId, 
    required this.grupoId,
    required this.periodo,
    required this.grupoNumero,
  });

  factory Horario.fromJson(Map<String, dynamic> json) => Horario(
    id: json['id'] ?? 0,
    tipo: json['tipo'] ?? "T",
    dia: json['dia'] ?? "Lunes",
    horaInicio: json['hora_inicio'] ?? "08:00",
    horaFin: json['hora_fin'] ?? "10:00",
    aulaId: json['aula_id'] ?? 0,
    grupoId: json['grupo_id'] ?? 0,
    periodo: json['periodo'] ?? "25-0",
    grupoNumero: json['grupo_numero'] ?? 1,
  );
}