class Asignatura {
  final int id;
  final String nombre;
  final String codigo;
  final int ciclo;
  final int creditos;
  final int horasTeoria;
  final int horasPractica;

  Asignatura({
    required this.id, required this.nombre, required this.codigo, 
    required this.ciclo, required this.creditos,
    required this.horasTeoria, required this.horasPractica,
  });

  factory Asignatura.fromJson(Map<String, dynamic> json) => Asignatura(
    id: json['id'],
    nombre: json['nombre'],
    codigo: json['codigo'],
    ciclo: json['ciclo'],
    creditos: json['creditos'],
    horasTeoria: json['horas_teoria'],
    horasPractica: json['horas_practica'],
  );
}