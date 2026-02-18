import 'package:flutter/material.dart';
import '../service/api_service.dart';
import 'scheduleScreen.dart'; // Asegúrate de que este import sea correcto para ResultadoScreen

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
    // Definimos los colores basados en la imagen
    const Color fondoRojoOscuro = Color(0xFFA80010); // Rojo oscuro del fondo
    const Color inputRojoClaro = Color(0xFFC92834);  // Rojo más claro de los inputs

    return Scaffold(
      backgroundColor: fondoRojoOscuro, // Cambiamos el fondo de toda la pantalla
      // Quitamos el AppBar para que se vea como en la foto (full screen)
      body: Center(
        child: SingleChildScrollView( // Permite scrollear si el teclado tapa los campos
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Texto 1: Hola, cachimbo
              const Text(
                'Hola, cachimbo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),

              // Texto 2: Ingresa los datos :
              const Text(
                'Ingresa los datos :',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // Input 1: Ciclo
              _buildCustomTextField(
                controller: cicloController,
                label: 'Ciclo',
                fillColor: inputRojoClaro,
              ),
              const SizedBox(height: 20),

              // Input 2: Grupo
              _buildCustomTextField(
                controller: grupoController,
                label: 'Grupo',
                fillColor: inputRojoClaro,
              ),
              const SizedBox(height: 50),

              // Botón ENVIAR
              cargando
                  ? const CircularProgressIndicator(color: Colors.white)
                  : SizedBox(
                      width: 150, // Ancho del botón
                      height: 50, // Alto del botón
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Fondo blanco
                          foregroundColor: Colors.grey[700], // Texto gris
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'ENVIAR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          setState(() => cargando = true);

                          try {
                            final data = await ApiService.enviarCicloGrupo(
                              cicloController.text,
                              grupoController.text,
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
                            print('ERROR REAL: $e');
                            if (!mounted) return;
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          } finally {
                            if (mounted) {
                              setState(() => cargando = false);
                            }
                          }
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Método auxiliar para no repetir código en los inputs
  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required Color fillColor,
  }) {
    return Container(
      decoration: BoxDecoration(
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
        style: const TextStyle(color: Colors.white), // Texto que escribe el usuario en blanco
        decoration: InputDecoration(
          hintText: label, // Usamos hintText para que quede centrado si no se escribe
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Bordes muy redondeados
            borderSide: BorderSide.none, // Sin borde visible
          ),
        ),
      ),
    );
  }
}