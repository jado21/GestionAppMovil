import 'horario_model.dart';

class HorarioDetallado {
  final Horario horario;
  final String nombreCurso;
  final String nombreDocente;
  final String codigoAsignatura;

  HorarioDetallado({
    required this.horario,
    required this.nombreCurso,
    required this.nombreDocente,
    required this.codigoAsignatura,
  });
}