class Facultad {
  final int id;
  final String nombre;
  final String siglas;
  final String codigo;

  Facultad({required this.id, required this.nombre, required this.siglas, required this.codigo});

  factory Facultad.fromJson(Map<String, dynamic> json) => Facultad(
    id: json['id'],
    nombre: json['nombre'],
    siglas: json['siglas'],
    codigo: json['codigo'],
  );
}