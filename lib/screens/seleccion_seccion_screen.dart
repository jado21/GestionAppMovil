import 'dart:ui';
import 'package:flutter/material.dart';
import '../service/api_service.dart';
import 'scheduleScreen.dart';

class SeleccionSeccionScreen extends StatefulWidget {
  final bool esCachimbo;
  final String ciclo;
  final String cicloRomano;
  final String escuela;

  const SeleccionSeccionScreen({
    super.key,
    required this.esCachimbo,
    required this.ciclo,
    required this.cicloRomano,
    required this.escuela,
  });

  @override
  State<SeleccionSeccionScreen> createState() => _SeleccionSeccionScreenState();
}

class _SeleccionSeccionScreenState extends State<SeleccionSeccionScreen>
    with TickerProviderStateMixin {

  // Secciones por ciclo para FISI (UNMSM)
  // Ajusta estas cantidades según la data real de tu facultad
  static const Map<int, int> seccionesPorCiclo = {
    1: 6,   // Ciclo I   → 6 secciones
    2: 6,   // Ciclo II  → 6 secciones
    3: 5,   // Ciclo III → 5 secciones
    4: 5,   // Ciclo IV  → 5 secciones
    5: 4,   // Ciclo V   → 4 secciones
    6: 4,   // Ciclo VI  → 4 secciones
    7: 3,   // Ciclo VII → 3 secciones
    8: 3,   // Ciclo VIII → 3 secciones
    9: 2,   // Ciclo IX  → 2 secciones
    10: 2,  // Ciclo X   → 2 secciones
  };

  late AnimationController _headerController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  late AnimationController _buttonsController;

  int? _selectedIndex;
  bool _cargando = false;

  late int _cantidadSecciones;

  @override
  void initState() {
    super.initState();

    final cicloNum = int.tryParse(widget.ciclo) ?? 1;
    _cantidadSecciones = seccionesPorCiclo[cicloNum] ?? 4;

    // Animación del header
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _headerFade = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    ));

    // Animación de los botones
    _buttonsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _headerController.forward().then((_) {
      _buttonsController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _buttonsController.dispose();
    super.dispose();
  }

  void _seleccionarSeccion(int index) async {
    final seccionLabel = (index + 1).toString();

    setState(() {
      _selectedIndex = index;
      _cargando = true;
    });

    try {
      final data = await ApiService.enviarCicloGrupo(
        widget.ciclo,
        seccionLabel,
        widget.escuela,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) {
            return ResultadoScreen(horarioResponse: data);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.15),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: const Color(0xFFC92834),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
          _selectedIndex = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Fondo con imagen
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo_formulario.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay oscuro (estilo formulario)
          Container(color: Colors.black.withOpacity(0.6)),

          // Contenido
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Header animado
                SlideTransition(
                  position: _headerSlide,
                  child: FadeTransition(
                    opacity: _headerFade,
                    child: Column(
                      children: [
                        // Badge del ciclo seleccionado (solo para Regular)
                        if (!widget.esCachimbo)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC92834).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: const Color(0xFFC92834).withOpacity(0.6),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              'Ciclo ${widget.cicloRomano}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        if (!widget.esCachimbo) const SizedBox(height: 20),
                        Icon(
                          widget.esCachimbo
                              ? Icons.auto_stories
                              : Icons.groups_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                        const SizedBox(height: 12),
                        if (widget.esCachimbo) ...[
                          const Text(
                            '¡Bienvenido, Cachimbo!',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        const Text(
                          'Selecciona tu Sección',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$_cantidadSecciones secciones disponibles',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 60,
                          height: 3,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC92834),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Botones de secciones
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16,
                          runSpacing: 16,
                          children: List.generate(
                            _cantidadSecciones,
                            (index) => _SeccionBlurButton(
                              numero: index + 1,
                              isSelected: _selectedIndex == index,
                              isLoading:
                                  _selectedIndex == index && _cargando,
                              delay: index * 100,
                              animationController: _buttonsController,
                              onTap: _cargando
                                  ? null
                                  : () => _seleccionarSeccion(index),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Indicador de carga global
                if (_cargando)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      children: [
                        const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Cargando horario...',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Botón individual de sección con estilo glassmorphism
class _SeccionBlurButton extends StatefulWidget {
  final int numero;
  final bool isSelected;
  final bool isLoading;
  final int delay;
  final AnimationController animationController;
  final VoidCallback? onTap;

  const _SeccionBlurButton({
    required this.numero,
    required this.isSelected,
    required this.isLoading,
    required this.delay,
    required this.animationController,
    this.onTap,
  });

  @override
  State<_SeccionBlurButton> createState() => _SeccionBlurButtonState();
}

class _SeccionBlurButtonState extends State<_SeccionBlurButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnim;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Tamaño responsivo de cada botón
    final double buttonSize = screenWidth > 600 ? 130 : (screenWidth - 80) / 3;

    // Animación de entrada escalonada
    final double delayFraction = (widget.delay / 600.0).clamp(0.0, 0.85);
    final entryAnimation = CurvedAnimation(
      parent: widget.animationController,
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
      child: ScaleTransition(
        scale: _scaleAnim,
        child: GestureDetector(
          onTapDown: widget.onTap != null
              ? (_) {
                  setState(() => _isPressed = true);
                  _scaleController.forward();
                }
              : null,
          onTapUp: widget.onTap != null
              ? (_) {
                  setState(() => _isPressed = false);
                  _scaleController.reverse();
                  widget.onTap!();
                }
              : null,
          onTapCancel: () {
            setState(() => _isPressed = false);
            _scaleController.reverse();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isSelected
                    ? Colors.white
                    : const Color(0xFFFFFFFF).withOpacity(_isPressed ? 0.4 : 0.24),
                width: widget.isSelected ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(widget.isSelected ? 0.35 : 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: widget.isSelected
                        ? const Color(0xFFC92834).withOpacity(0.75)
                        : const Color(0xFFC92834).withOpacity(_isPressed ? 0.65 : 0.6),
                  ),
                  child: widget.isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.group_outlined,
                              color: Colors.white.withOpacity(0.5),
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sección',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${widget.numero}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

