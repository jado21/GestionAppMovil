import 'package:flutter/material.dart';
// Importamos WelcomeScreen para que sea lo primero que se vea al iniciar
import 'package:mobile_app_test/screens/welcomeScreen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi Horario App',
      theme: ThemeData(
        // Se usa useMaterial3 para un diseño más moderno
        useMaterial3: true, 
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA80010)),
      ),
      // CORRECCIÓN: Configuramos WelcomeScreen como la inicial para ver el fondo FISI
      home: const WelcomeScreen(), 
    );
  }
}