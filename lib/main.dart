import 'package:flutter/material.dart';
import 'package:mobile_app_test/screens/welcome_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Horario FISI',
      theme: ThemeData(
        useMaterial3: true, 
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA80010)),
      ),
      home: const WelcomeScreen(), 
    );
  }
}