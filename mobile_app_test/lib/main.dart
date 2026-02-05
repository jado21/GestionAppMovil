import 'package:flutter/material.dart';
import 'package:mobile_app_test/screens/formularioScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FormularioScreen(),
    );
  }
}
