import 'package:flutter/material.dart';
import '../models/horario_response.dart';

class ResultadoScreen extends StatelessWidget {
  final HorarioResponse horarioResponse;

  const ResultadoScreen({
    super.key,
    required this.horarioResponse,
  });

  @override
  Widget build(BuildContext context) {
    // Tomamos el primer horario (en tu JSON solo hay uno)
    final dias = horarioResponse.horarios.first.dias;

    return Scaffold(
      appBar: AppBar(
        title: Text('Grupo ${horarioResponse.grupo}'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: dias.length,
        itemBuilder: (context, index) {
          final dia = dias[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Nombre del día
                  Text(
                    dia.dia,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),

                  // 🔹 Lista de clases del día
                  ...dia.clases.map((clase) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '⏰ ${clase.horaInicio} - ${clase.horaFin}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('📘 ${clase.curso}'),
                          Text(
                            '👨‍🏫 ${clase.docente} | 🏫 ${clase.aula}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
