class Escuela {
  final int id;
  final String nombre;
  final String codigo;
  final int facultadId; // Relación con facultades_facultad

  Escuela({required this.id, required this.nombre, required this.codigo, required this.facultadId});

  factory Escuela.fromJson(Map<String, dynamic> json) => Escuela(
    id: json['id'],
    nombre: json['nombre'],
    codigo: json['codigo'],
    facultadId: json['facultad_id'],
  );
}