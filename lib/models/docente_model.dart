class Docente {
  final int id;
  final String nombre;
  final String apellido;
  final String email;

  Docente({required this.id, required this.nombre, required this.apellido, required this.email});

  String get nombreCompleto => "$nombre $apellido";

  factory Docente.fromJson(Map<String, dynamic> json) => Docente(
    id: json['id'],
    nombre: json['nombre'],
    apellido: json['apellido'],
    email: json['email'],
  );
}