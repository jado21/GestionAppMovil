import 'dart:ffi';

class Escuela{
  final int id;
  final String nombre;
  final String codigo;

  Escuela({
    required this.id,
    required this.nombre,
    required this.codigo
  });

  factory Escuela.fromJson(Map<String, dynamic> json){
    return Escuela(
      id: json['id'], 
      nombre: json['nombre'], 
      codigo: json['codigo']
      );
  }
  
}