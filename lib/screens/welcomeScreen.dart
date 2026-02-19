import 'package:mobile_app_test/screens/formularioScreen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _navegarAlHome();
  }

  _navegarAlHome() async {
    // 1. Esperamos 3 segundos mientras se ve el fondo
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return; // Verificación de seguridad por si el usuario cierra la app antes

    // 2. Navegamos al formulario
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FormularioScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Eliminamos el backgroundColor plano para que se vea la imagen
      body: Stack(
        children: [
          // --- CAPA 1: IMAGEN DE FONDO ---
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                // Revisa que el archivo se llame fondo.jpg en la carpeta assets
                image: AssetImage('assets/fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // --- CAPA 2: FILTRO OSCURO (Overlay) ---
          // Esto hace que el logo y el texto de FISI resalten
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // --- CAPA 3: CONTENIDO PRINCIPAL ---
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icono o Logo
                const Icon(
                  Icons.group_work,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
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
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                // Indicador de carga
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}