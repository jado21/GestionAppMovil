import 'package:flutter/material.dart';
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
        // CORRECCIÓN: Se usa useMaterial3 en lugar de useMaterialDesign
        useMaterial3: true, 
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA80010)),
      ),
      // Asegúrate que WelcomeScreen empiece con W mayúscula como en el archivo que corregimos
      home: const WelcomeScreen(), 
    );
  }
}