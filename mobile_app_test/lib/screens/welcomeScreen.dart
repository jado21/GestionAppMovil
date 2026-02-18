import 'package:mobile_app_test/screens/formularioScreen.dart';
import 'package:flutter/material.dart';

class Welcomescreen extends StatefulWidget{
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomeScreenState();

}

class _WelcomeScreenState extends State<Welcomescreen>{
  @override
  void initState(){
    super.initState();
    _navegarAlHome();
  }

  _navegarAlHome() async{
    // 1. Esperamos una duración (ejemplo: 3 segundos)
    await Future.delayed(const Duration(seconds: 3), () {});

    // 2. Navegamos a la siguiente pantalla
    // Usamos pushReplacement para que el usuario NO pueda volver atrás al Splash
    if (!mounted) return; // Verificación de seguridad
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const FormularioScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAC0112), // Color de fondo de tu marca
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Aquí iría el logo o animación de tu grupo
            const Icon(
              Icons.group_work, // Un icono de ejemplo
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'Developed by:',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'FISI', // Nombre de tu grupo
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            // Un indicador de carga giratorio (opcional)
            const CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

}

