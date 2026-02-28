import 'package:flutter/material.dart';
import 'seleccion_ciclo_screen.dart';
import 'seleccion_seccion_screen.dart';

class SeleccionPerfilScreen extends StatefulWidget {
  const SeleccionPerfilScreen({super.key});

  @override
  State<SeleccionPerfilScreen> createState() => _SeleccionPerfilScreenState();
}

class _SeleccionPerfilScreenState extends State<SeleccionPerfilScreen>
    with TickerProviderStateMixin {
  String? _selectedPerfil; // 'cachimbo' o 'regular'
  String? _selectedEscuela;

  late AnimationController _titleController;
  late Animation<double> _titleFade;

  late AnimationController _cardsController;

  late AnimationController _escuelaController;
  late Animation<double> _escuelaFade;
  late Animation<Offset> _escuelaSlide;

  static const List<Map<String, String>> escuelas = [
    {'key': 'sistemas', 'label': 'Ingeniería de Sistemas', 'icon': 'systems'},
    {'key': 'software', 'label': 'Ingeniería de Software', 'icon': 'software'},
    {'key': 'computacion', 'label': 'Ciencias de la Computación', 'icon': 'computation'},
  ];

  @override
  void initState() {
    super.initState();

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _titleFade = CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOut,
    );

    _cardsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _escuelaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _escuelaFade = CurvedAnimation(
      parent: _escuelaController,
      curve: Curves.easeOut,
    );
    _escuelaSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _escuelaController,
      curve: Curves.easeOutCubic,
    ));

    _titleController.forward().then((_) {
      _cardsController.forward();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _cardsController.dispose();
    _escuelaController.dispose();
    super.dispose();
  }

  void _selectPerfil(String perfil) {
    setState(() {
      _selectedPerfil = perfil;
      _selectedEscuela = null;
    });

    if (perfil == 'cachimbo') {
      // Para cachimbo, escuela = "Ingeniería de Sistemas" por defecto
      // Navegar directo a secciones del Ciclo I
      Future.delayed(const Duration(milliseconds: 350), () {
        if (!mounted) return;
        _navegarConTransicion(
          context,
          const SeleccionSeccionScreen(
            esCachimbo: true,
            ciclo: '1',
            cicloRomano: 'I',
            escuela: 'Ingeniería de Sistemas',
          ),
        );
        // Resetear después de volver
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            setState(() {
              _selectedPerfil = null;
            });
          }
        });
      });
    } else {
      // Para regular, mostrar selección de escuela con animación
      _escuelaController.reset();
      _escuelaController.forward();
    }
  }

  void _selectEscuela(String escuelaKey) {
    final escuelaLabel = escuelas.firstWhere((e) => e['key'] == escuelaKey)['label']!;
    setState(() {
      _selectedEscuela = escuelaKey;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _navegarConTransicion(
        context,
        SeleccionCicloScreen(escuela: escuelaLabel),
      );
      // Resetear después de volver
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _selectedPerfil = null;
            _selectedEscuela = null;
          });
        }
      });
    });
  }

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

  IconData _getEscuelaIcon(String iconKey) {
    switch (iconKey) {
      case 'systems':
        return Icons.settings_suggest_rounded;
      case 'software':
        return Icons.code_rounded;
      case 'computation':
        return Icons.memory_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo gradiente premium
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE81525),
                  Color(0xFFC92834),
                  Color(0xFF8B0000),
                  Color(0xFF5C0011),
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),

          // Patrón decorativo sutil
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -70,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
          ),

          // Contenido principal
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Título animado
                    FadeTransition(
                      opacity: _titleFade,
                      child: Column(
                        children: [
                          // Ícono decorativo superior
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Título
                          const Text(
                            'PERFIL',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 8,
                              shadows: [
                                Shadow(
                                  color: Colors.black38,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '¿Cuál es tu perfil académico?',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 50,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Cards de Cachimbo y Regular
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildProfileCard(
                              imagePath: 'assets/cachimbo.png',
                              label: 'Cachimbo',
                              subtitle: 'Primer ciclo',
                              perfilKey: 'cachimbo',
                              delay: 0,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildProfileCard(
                              imagePath: 'assets/regular.png',
                              label: 'Regular',
                              subtitle: 'Ciclo II - X',
                              perfilKey: 'regular',
                              delay: 150,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Selector de Escuela (aparece al escoger Regular)
                    if (_selectedPerfil == 'regular') ...[
                      const SizedBox(height: 32),
                      SlideTransition(
                        position: _escuelaSlide,
                        child: FadeTransition(
                          opacity: _escuelaFade,
                          child: _buildEscuelaSelector(),
                        ),
                      ),
                    ],

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard({
    required String imagePath,
    required String label,
    required String subtitle,
    required String perfilKey,
    required int delay,
  }) {
    final bool isSelected = _selectedPerfil == perfilKey;
    final double delayFraction = (delay / 500.0).clamp(0.0, 0.8);
    final entryAnimation = CurvedAnimation(
      parent: _cardsController,
      curve: Interval(delayFraction, 1.0, curve: Curves.easeOutBack),
    );

    return AnimatedBuilder(
      animation: entryAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: entryAnimation.value.clamp(0.0, 1.0),
          child: Opacity(
            opacity: entryAnimation.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _selectPerfil(perfilKey),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isSelected
                ? Colors.white.withOpacity(0.22)
                : Colors.white.withOpacity(0.08),
            border: Border.all(
              color: isSelected
                  ? Colors.white.withOpacity(0.7)
                  : Colors.white.withOpacity(0.15),
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: const Color(0xFFE81525).withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Imagen del personaje
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Colors.white.withOpacity(0.15)
                      : Colors.transparent,
                ),
                child: Image.asset(
                  imagePath,
                  height: 110,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white.withOpacity(0.7),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              // Label
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              // Subtitle
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 10),
              // Indicador de selección
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isSelected ? 40 : 0,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEscuelaSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          // Título de la sección
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 1,
                color: Colors.white.withOpacity(0.3),
              ),
              const SizedBox(width: 12),
              Text(
                'Selecciona tu Escuela',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 30,
                height: 1,
                color: Colors.white.withOpacity(0.3),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Botones de escuela
          ...escuelas.asMap().entries.map((entry) {
            final index = entry.key;
            final escuela = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: index < escuelas.length - 1 ? 12 : 0),
              child: _buildEscuelaButton(
                label: escuela['label']!,
                escuelaKey: escuela['key']!,
                icon: _getEscuelaIcon(escuela['icon']!),
                delay: index * 100,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEscuelaButton({
    required String label,
    required String escuelaKey,
    required IconData icon,
    required int delay,
  }) {
    final bool isSelected = _selectedEscuela == escuelaKey;

    return GestureDetector(
      onTap: () => _selectEscuela(escuelaKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? Colors.white.withOpacity(0.25)
              : Colors.white.withOpacity(0.08),
          border: Border.all(
            color: isSelected
                ? Colors.white.withOpacity(0.7)
                : Colors.white.withOpacity(0.18),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Ícono
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : Colors.white.withOpacity(0.08),
              ),
              child: Icon(
                icon,
                color: Colors.white.withOpacity(isSelected ? 1.0 : 0.7),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            // Texto
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(isSelected ? 1.0 : 0.85),
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            // Indicador
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Colors.white
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Color(0xFFC92834),
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}