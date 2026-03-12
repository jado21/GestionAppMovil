import 'escuela.dart';

class EscuelaResponse {
  final bool success;
  final List<Escuela> escuelas;

  EscuelaResponse({
    required this.success,
    required this.escuelas,
  });

  factory EscuelaResponse.fromJson(Map<String, dynamic> json) {
    return EscuelaResponse(
      success: json['success'] ?? false, 
      
      escuelas: json['escuelas'] != null
          ? List<Escuela>.from(json['escuelas'].map((x) => Escuela.fromJson(x)))
          : [], 
    );
  }
}