import 'dart:ui';
import 'package:flutter/material.dart';
import 'seleccion_seccion_screen.dart';

class SeleccionCicloScreen extends StatefulWidget {
  final String escuela;
  final String escuelaId;

  const SeleccionCicloScreen({
    super.key,
    required this.escuela,
    required this.escuelaId,
  });

  @override
  State<SeleccionCicloScreen> createState() => _SeleccionCicloScreenState();
}

class _SeleccionCicloScreenState extends State<SeleccionCicloScreen>
    with TickerProviderStateMixin {
  static const List<String> ciclosRomano = [
    'I', 'II', 'III', 'IV', 'V',
    'VI', 'VII', 'VIII', 'IX', 'X',
  ];

  late AnimationController _titleController;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;

  late AnimationController _buttonsController;
  late Animation<double> _buttonsFade;

  int? _selectedIndex;

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
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOutCubic,
    ));

    _buttonsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _buttonsFade = CurvedAnimation(
      parent: _buttonsController,
      curve: Curves.easeOut,
    );

    _titleController.forward().then((_) {
      _buttonsController.forward();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _buttonsController.dispose();
    super.dispose();
  }

  void _seleccionarCiclo(int index) {
    setState(() => _selectedIndex = index);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) {
            return SeleccionSeccionScreen(
              ciclo: (index + 1).toString(),
              cicloRomano: ciclosRomano[index],
              escuela: widget.escuela,
              escuelaId: widget.escuelaId,
            );
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
                  begin: const Offset(1.0, 0),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        ),
      ).then((_) {
        if (mounted) setState(() => _selectedIndex = null);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 5 : 2;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo_formulario.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(color: Colors.black.withValues(alpha: 0.6)),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Título animado
                SlideTransition(
                  position: _titleSlide,
                  child: FadeTransition(
                    opacity: _titleFade,
                    child: Column(
                      children: [
                        const Icon(
                          Icons.engineering,
                          color: Colors.white,
                          size: 50,
                        ),
                        const SizedBox(height: 12),
                        // Mostrar la escuela seleccionada
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            widget.escuela,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Selecciona tu Ciclo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 6),
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

                const SizedBox(height: 30),

                Expanded(
                  child: FadeTransition(
                    opacity: _buttonsFade,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 16,
                          childAspectRatio: 2,
                        ),
                        itemCount: ciclosRomano.length,
                        itemBuilder: (context, index) {
                          return _CicloBlurButton(
                            label: ciclosRomano[index],
                            numero: index + 1,
                            isSelected: _selectedIndex == index,
                            delay: index * 80,
                            animationController: _buttonsController,
                            onTap: () => _seleccionarCiclo(index),
                          );
                        },
                      ),
                    ),
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

class _CicloBlurButton extends StatefulWidget {
  final String label;
  final int numero;
  final bool isSelected;
  final int delay;
  final AnimationController animationController;
  final VoidCallback onTap;

  const _CicloBlurButton({
    required this.label,
    required this.numero,
    required this.isSelected,
    required this.delay,
    required this.animationController,
    required this.onTap,
  });

  @override
  State<_CicloBlurButton> createState() => _CicloBlurButtonState();
}

class _CicloBlurButtonState extends State<_CicloBlurButton>
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
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
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
    final double delayFraction =
        (widget.delay / 800.0).clamp(0.0, 0.9);
    final entryAnimation = CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(delayFraction, 1.0, curve: Curves.easeOutBack),
    );

    return AnimatedBuilder(
      animation: entryAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - entryAnimation.value)),
          child: Opacity(
            opacity: entryAnimation.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: ScaleTransition(
        scale: _scaleAnim,
        child: GestureDetector(
          onTapDown: (_) {
            setState(() => _isPressed = true);
            _scaleController.forward();
          },
          onTapUp: (_) {
            setState(() => _isPressed = false);
            _scaleController.reverse();
            widget.onTap();
          },
          onTapCancel: () {
            setState(() => _isPressed = false);
            _scaleController.reverse();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isSelected
                    ? Colors.white
                    : const Color(0xFFFFFFFF).withValues(alpha: _isPressed ? 0.4 : 0.24),
                width: widget.isSelected ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: widget.isSelected ? 0.35 : 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: widget.isSelected
                        ? const Color(0xFFC92834).withValues(alpha: 0.75)
                        : const Color(0xFFC92834).withValues(alpha: _isPressed ? 0.65 : 0.6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.label.length > 3 ? 17 : 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          shadows: const [
                            Shadow(
                              color: Colors.black45,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Ciclo ${widget.numero}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.7,
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
