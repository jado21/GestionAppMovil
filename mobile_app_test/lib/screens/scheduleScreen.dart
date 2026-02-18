import 'package:flutter/material.dart';
import '../models/horario_response.dart';

class ResultadoScreen extends StatefulWidget {
  final HorarioResponse horarioResponse;

  const ResultadoScreen({super.key, required this.horarioResponse});

  @override
  State<ResultadoScreen> createState() => _ResultadoScreenState();
}

class _ResultadoScreenState extends State<ResultadoScreen> {
  // CONFIGURACIÓN DE DIMENSIONES
  final double widthColumnaHora = 50.0; // Ancho de la columna de horas (izq)
  final double widthColumnaDia = 110.0; // Ancho de cada día
  final double heightHora = 80.0;       // Altura de cada bloque de 1 hora
  final double heightHeader = 50.0;     // Altura de los nombres de los días

  // Colores (Tu marca)
  final Color rojoOscuro = const Color(0xFFA80010);
  final Color rojoClaro = const Color(0xFFC92834);

  // Días a mostrar en orden
  final List<String> diasSemana = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'];

  @override
  Widget build(BuildContext context) {
    // Calculamos el tamaño total del lienzo
    // Ancho = Columna Horas + (6 días * Ancho día)
    final double anchoTotal = widthColumnaHora + (diasSemana.length * widthColumnaDia);
    
    String group = widget.horarioResponse.grupo;

    // Rango de horas (5am a 11pm)
    const int horaInicio = 5;
    const int horaFin = 23;
    const int totalHoras = horaFin - horaInicio;
    // Alto = Cabecera + (Horas * Alto hora)
    final double altoTotal = heightHeader + (totalHoras * heightHora);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Horario Semanal - Grupo : $group', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: rojoOscuro,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      // 1. SCROLL HORIZONTAL
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          // 2. SCROLL VERTICAL
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: anchoTotal,
            height: altoTotal,
            child: Stack(
              children: [
                // CAPA 1: GRILLA DE FONDO (Líneas y horas)
                _dibujarGrillaFondo(totalHoras, horaInicio, anchoTotal),

                // CAPA 2: CABECERAS (Nombres de los días)
                _dibujarCabecerasDias(),

                // CAPA 3: LOS BLOQUES DE CLASES
                ..._generarBloquesDeClases(horaInicio),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- MÉTODOS DE DIBUJO ---

  Widget _dibujarGrillaFondo(int totalHoras, int horaInicio, double anchoTotal) {
    return Column(
      children: [
        SizedBox(height: heightHeader), // Espacio para la cabecera
        ...List.generate(totalHoras, (index) {
          final hora = horaInicio + index;
          return Container(
            height: heightHora,
            width: anchoTotal,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!), // Línea horizontal
              ),
            ),
            child: Row(
              children: [
                // Etiqueta de hora (Columna Izquierda Fija visualmente)
                Container(
                  width: widthColumnaHora,
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    border: Border(right: BorderSide(color: Colors.grey[300]!))
                  ),
                  child: Text(
                    '$hora:00',
                    style: TextStyle(
                      fontSize: 12, 
                      color: rojoOscuro, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                // Líneas verticales separadoras de días
                ...List.generate(diasSemana.length, (i) => Container(
                  width: widthColumnaDia,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.grey[100]!), // Línea vertical sutil
                    )
                  ),
                )),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _dibujarCabecerasDias() {
    return Positioned(
      top: 0,
      left: 0,
      child: Row(
        children: [


          // --- CAMBIO AQUÍ ---
          // Reemplazamos el espacio en blanco por un Container rojo
          Container(
            width: widthColumnaHora,
            height: heightHeader,
            color: rojoOscuro, // Usamos el mismo color que el resto de la cabecera
          ),
          // SizedBox(width: widthColumnaHora), // <-- Esto era lo que dejaba el espacio blanco antes
          //
          ...diasSemana.map((dia) => Container(
            width: widthColumnaDia,
            height: heightHeader,
            alignment: Alignment.center,
            color: rojoOscuro, // Fondo rojo para los encabezados
            child: Text(
              dia.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          )),
        ],
      ),
    );
  }

  List<Widget> _generarBloquesDeClases(int horaInicioGrid) {
    List<Widget> bloques = [];

    // Verificamos si hay datos
    if (widget.horarioResponse.horarios.isEmpty) return [];

    final diasData = widget.horarioResponse.horarios.first.dias;

    for (var diaData in diasData) {
      // 1. Identificar en qué columna (índice) va este día
      // Normalizamos texto (quitamos tildes simples o mayúsculas para comparar)
      int indexColumna = diasSemana.indexWhere((d) => 
          d.toLowerCase().contains(diaData.dia.toLowerCase().substring(0, 3)) // Compara 'Lun' con 'Lunes'
      );

      // Si el día no es válido (ej: Domingo) o no se encuentra, lo saltamos
      if (indexColumna == -1) continue;

      // 2. Crear bloques para cada clase de ese día
      for (var clase in diaData.clases) {
        final double inicio = _parseHora(clase.horaInicio);
        final double fin = _parseHora(clase.horaFin);
        
        // CÁLCULOS DE POSICIÓN
        // Left: AnchoHora + (NumeroColumna * AnchoDia)
        final double left = widthColumnaHora + (indexColumna * widthColumnaDia);
        // Top: AltoHeader + ((HoraClase - HoraInicioGrid) * AltoHora)
        final double top = heightHeader + ((inicio - horaInicioGrid) * heightHora);
        // Height: Duración * AltoHora
        final double height = (fin - inicio) * heightHora;

        bloques.add(
          Positioned(
            left: left + 2, // +2 para margen
            top: top,
            width: widthColumnaDia - 4, // -4 para margen derecho e izquierdo
            height: height - 2, // -2 para margen inferior
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: rojoClaro,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 2)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    clase.curso,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    clase.aula,
                    style: const TextStyle(color: Colors.white70, fontSize: 9),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return bloques;
  }

  double _parseHora(String horaString) {
    try {
      final parts = horaString.split(':');
      return int.parse(parts[0]) + (int.parse(parts[1]) / 60.0);
    } catch (e) {
      return 0.0;
    }
  }
}