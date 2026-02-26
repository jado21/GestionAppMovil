import 'package:flutter/material.dart';
import 'seleccion_ciclo_screen.dart';
import 'seleccion_seccion_screen.dart';

class SeleccionPerfilScreen extends StatelessWidget {
  const SeleccionPerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFD31010), Color(0xFF8B0000)],
              ),
            ),
          ),

          // 2. Contenido Principal
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Título PERFIL
                const Text(
                  'PERFIL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                
                const Spacer(),

                // 3. Fila de Personajes (Cachimbo y Regular)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCharacterItem('assets/cachimbo.png', 'Cachimbo'),
                    _buildCharacterItem('assets/regular.png', 'Regular'),
                  ],
                ),

                const Spacer(),

                // 4. Botones de Acción con Lógica Condicional
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      // CACHIMBO → Directo a secciones del Ciclo I
                      _buildNavButton(
                        context,
                        'SOY CACHIMBO',
                        () => _navegarConTransicion(
                          context,
                          const SeleccionSeccionScreen(
                            esCachimbo: true,
                            ciclo: '1',
                            cicloRomano: 'I',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // REGULAR → Pantalla para escoger ciclo (II al X)
                      _buildNavButton(
                        context,
                        'SOY REGULAR',
                        () => _navegarConTransicion(
                          context,
                          const SeleccionCicloScreen(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para los personajes
  Widget _buildCharacterItem(String imagePath, String label) {
    return Column(
      children: [
        Image.asset(
          imagePath, 
          height: 150,
          errorBuilder: (context, error, stackTrace) {
            // En caso de que no encuentre la imagen, muestra un icono
            return const Icon(Icons.person, size: 100, color: Colors.white);
          },
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Courier', 
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Transición reutilizable con fade + slide
  void _navegarConTransicion(BuildContext context, Widget destino) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) => destino,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  // Widget para los botones de navegación
  Widget _buildNavButton(BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF8B0000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}