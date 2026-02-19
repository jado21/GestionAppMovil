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
    // Definimos los colores con transparencia para el efecto Glass
    final Color rojoTransparente = const Color(0xFFC92834).withOpacity(0.5);
    final Color blancoTransparente = Colors.white.withOpacity(0.3);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // --- CAPA 1: FONDO DE PANTALLA ---
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo_formulario.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
          ),

          // --- CAPA 2: FILTRO OSCURO GENERAL ---
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // --- CAPA 3: CONTENIDO ---
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hola, cachimbo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Ingresa los datos :',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Input 1: Ciclo (Rojo Transparente)
                  _buildCustomTextField(
                    controller: cicloController,
                    label: 'Ciclo',
                    fillColor: rojoTransparente,
                  ),
                  const SizedBox(height: 20),

                  // Input 2: Grupo (Rojo Transparente)
                  _buildCustomTextField(
                    controller: grupoController,
                    label: 'Grupo',
                    fillColor: rojoTransparente,
                  ),
                  const SizedBox(height: 50),

                  // Botón ENVIAR (Blanco Transparente)
                  cargando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : SizedBox(
                          width: 180,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blancoTransparente,
                              foregroundColor: Colors.white,
                              elevation: 0, // Sin sombra para que parezca cristal
                              side: const BorderSide(color: Colors.white38), // Borde sutil
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: _enviarDatos,
                            child: const Text(
                              'ENVIAR',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _enviarDatos() async {
    if (cicloController.text.isEmpty || grupoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    setState(() => cargando = true);

    try {
      final data = await ApiService.enviarCicloGrupo(
        cicloController.text.trim(),
        grupoController.text.trim(),
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultadoScreen(
            horarioResponse: data,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required Color fillColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        // Sombra muy suave
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white12), // Borde sutil
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white70), // Resalta al tocar
          ),
        ),
      ),
    );
  }
}