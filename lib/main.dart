import 'package:flutter/material.dart';
// Importamos las pantallas verificando que los nombres de los archivos sean correctos
import 'screens/splash_screen.dart';
import 'screens/horarios_screen.dart';
import 'screens/gestion_datos_screen.dart'; 

void main() {
  // Asegura que los bindings de Flutter estén listos antes de cargar datos o PDF
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión Académica UNMSM',
      debugShowCheckedModeBanner: false,
      
      // Configuración del tema institucional FISI
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF002244),
          primary: const Color(0xFF002244),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF002244),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
      ),

      // Definimos la ruta inicial (La Splash Screen)
      initialRoute: '/',
      
      // Definimos el mapa de rutas de la aplicación
      routes: {
        '/': (context) => const SplashScreen(),
        '/horarios': (context) => const HorariosScreen(),
        '/gestion': (context) => const GestionDatosScreen(),
      },
    );
  }
}