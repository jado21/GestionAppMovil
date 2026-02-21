import 'package:flutter/material.dart';
import 'package:mobile_app_test/screens/seleccion_perfil_screen.dart'; 

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _iniciarTemporizador();
  }

  _iniciarTemporizador() async {
    // Esperamos 3 segundos mostrando el fondo y el logo
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return; 

    // Navegación a la selección de perfil (Cachimbo/Regular)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SeleccionPerfilScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // --- CAPA 1: FONDO DE PANTALLA ---
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // --- CAPA 2: FILTRO OSCURO ---
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // --- CAPA 3: CONTENIDO (LOGO Y TEXTO) ---
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // REEMPLAZO: Imagen del Logo en lugar del Icon genérico
                Image.asset(
                  'assets/logo.png',
                  height: 180, // Ajusta el tamaño según tu imagen
                  fit: BoxFit.contain,
                  // En caso de que la imagen no cargue, muestra un icono de error
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.broken_image, size: 100, color: Colors.white),
                ),
                
                const SizedBox(height: 30),
                const Text(
                  'Developed by:',
                  style: TextStyle(
                    color: Colors.white70, 
                    fontSize: 18,
                    letterSpacing: 1.2
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'FISI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 60),
                const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}