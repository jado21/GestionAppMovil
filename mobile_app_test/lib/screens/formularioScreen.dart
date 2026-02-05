import 'package:flutter/material.dart';
import '../service/api_service.dart';
import 'scheduleScreen.dart';

class FormularioScreen extends StatefulWidget {
  const FormularioScreen({super.key});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final cicloController = TextEditingController();
  final grupoController = TextEditingController();

  bool cargando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: cicloController,
              decoration: const InputDecoration(labelText: 'Ciclo'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: grupoController,
              decoration: const InputDecoration(labelText: 'Grupo'),
            ),
            const SizedBox(height: 20),
            cargando
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    child: const Text('Enviar'),
                    onPressed: () async {
                      setState(() => cargando = true);

                      try {
                        final data =
                            await ApiService.enviarCicloGrupo(
                          cicloController.text,
                          grupoController.text,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultadoScreen(
                              horarioResponse: data,
                            ),
                          ),
                        );
                      } catch (e) {
                        print('ERROR REAL: $e');

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      } finally {
                        setState(() => cargando = false);
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
