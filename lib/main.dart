import 'package:app_unmsm/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/horarios_screen.dart';
import 'screens/gestion_datos_screen.dart';
import 'theme/app_theme.dart';

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
      
      // Configuración del tema institucional FISI extraído a AppTheme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,  // ahora el tema dependera del dispositivo

      // Definimos la ruta inicial (La Splash Screen)
      initialRoute: '/',
      
      // Definimos el mapa de rutas de la aplicación
      routes: {
        '/': (context) => const MainLayout(child: SplashScreen()),
        '/horarios': (context) => const MainLayout(child: HorariosScreen()),
        '/gestion': (context) => const MainLayout(child: GestionDatosScreen()),
      },
    );
  }
}