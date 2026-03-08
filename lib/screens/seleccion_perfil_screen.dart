import 'package:flutter/material.dart';
import '../models/escuela.dart';
import '../service/api_service.dart';
import 'seleccion_ciclo_screen.dart';

class SeleccionPerfilScreen extends StatefulWidget {
  const SeleccionPerfilScreen({super.key});

  @override
  State<SeleccionPerfilScreen> createState() => _SeleccionPerfilScreenState();
}

class _SeleccionPerfilScreenState extends State<SeleccionPerfilScreen>
    with TickerProviderStateMixin {
  String? _selectedFacultad = 'fisi';
  String? _selectedEscuelaKey;

  late AnimationController _titleController;
  late Animation<double> _titleFade;

  late AnimationController _facultadController;
  late Animation<double> _facultadFade;
  late Animation<Offset> _facultadSlide;

  late AnimationController _escuelaController;
  late Animation<double> _escuelaFade;
  late Animation<Offset> _escuelaSlide;

  // Escuelas cargadas desde la API
  List<Escuela> _escuelas = [];
  bool _cargandoEscuelas = false;
  String? _errorEscuelas;

  // Lista de facultades (por ahora solo FISI)
  static const List<Map<String, String>> facultades = [
    {
      'key': 'fisi',
      'label': 'Facultad de Ingeniería de Sistemas e Informática',
    },
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

    _facultadController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _facultadFade = CurvedAnimation(
      parent: _facultadController,
      curve: Curves.easeOut,
    );
    _facultadSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _facultadController,
      curve: Curves.easeOutCubic,
    ));

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
      _facultadController.forward();
    });

    // Cargar escuelas automáticamente (FISI pre-seleccionada)
    _cargarEscuelas();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _facultadController.dispose();
    _escuelaController.dispose();
    super.dispose();
  }

  void _selectFacultad(String? facultadKey) {
    if (facultadKey == null) return;

    setState(() {
      _selectedFacultad = facultadKey;
      _selectedEscuelaKey = null;
      _escuelas = [];
      _errorEscuelas = null;
    });

    _cargarEscuelas();
  }

  Future<void> _cargarEscuelas() async {
    setState(() {
      _cargandoEscuelas = true;
      _errorEscuelas = null;
    });

    try {
      final response = await ApiService.obtenerEscuelas();
      if (!mounted) return;

      setState(() {
        _escuelas = response.escuelas;
        _cargandoEscuelas = false;
      });

      _escuelaController.reset();
      _escuelaController.forward();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargandoEscuelas = false;
        _errorEscuelas = 'Error al cargar las escuelas';
      });
    }
  }

  void _selectEscuela(Escuela escuela) {
    setState(() {
      _selectedEscuelaKey = escuela.id.toString();
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _navegarConTransicion(
        context,
        SeleccionCicloScreen(
          escuela: escuela.nombre,
          escuelaId: escuela.id.toString(),
        ),
      );
      // Resetear después de volver
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _selectedEscuelaKey = null;
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

  IconData _getEscuelaIcon(String nombre) {
    final lower = nombre.toLowerCase();
    if (lower.contains('sistemas')) {
      return Icons.settings_suggest_rounded;
    } else if (lower.contains('software')) {
      return Icons.code_rounded;
    } else if (lower.contains('computación') || lower.contains('computacion')) {
      return Icons.memory_rounded;
    }
    return Icons.school_rounded;
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
                color: Colors.white.withValues(alpha: 0.04),
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
                color: Colors.white.withValues(alpha: 0.03),
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
                              color: Colors.white.withValues(alpha: 0.1),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
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
                            'FACULTAD',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 6,
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
                            'Selecciona tu facultad y escuela',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
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
                              color: Colors.white.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Dropdown de facultad
                    SlideTransition(
                      position: _facultadSlide,
                      child: FadeTransition(
                        opacity: _facultadFade,
                        child: _buildFacultadDropdown(),
                      ),
                    ),

                    // Escuelas (aparecen al seleccionar facultad)
                    if (_selectedFacultad != null) ...[
                      const SizedBox(height: 28),
                      if (_cargandoEscuelas)
                        _buildLoadingIndicator()
                      else if (_errorEscuelas != null)
                        _buildErrorWidget()
                      else if (_escuelas.isNotEmpty)
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

  Widget _buildFacultadDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Row(
            children: [
              Icon(
                Icons.account_balance_rounded,
                color: Colors.white.withValues(alpha: 0.8),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Facultad',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Dropdown container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withValues(alpha: 0.12),
              border: Border.all(
                color: _selectedFacultad != null
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.2),
                width: _selectedFacultad != null ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedFacultad,
                hint: Text(
                  'Selecciona una facultad',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 24,
                ),
                dropdownColor: const Color(0xFF8B0000),
                borderRadius: BorderRadius.circular(16),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                items: facultades.map((facultad) {
                  return DropdownMenuItem<String>(
                    value: facultad['key'],
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_balance_rounded,
                          color: Colors.white.withValues(alpha: 0.7),
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            facultad['label']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: _selectFacultad,
              ),
            ),
          ),
          // Indicador de facultad seleccionada
          if (_selectedFacultad != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.greenAccent.withValues(alpha: 0.8),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    facultades.firstWhere(
                      (f) => f['key'] == _selectedFacultad,
                    )['label']!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Cargando escuelas...',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.red.withValues(alpha: 0.15),
          border: Border.all(
            color: Colors.redAccent.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.white.withValues(alpha: 0.8),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              _errorEscuelas!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _cargarEscuelas,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Text(
                'Reintentar',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
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
                color: Colors.white.withValues(alpha: 0.3),
              ),
              const SizedBox(width: 12),
              Text(
                'Selecciona tu Escuela',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 30,
                height: 1,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Botones de escuela
          ...List.generate(_escuelas.length, (index) {
            final escuela = _escuelas[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < _escuelas.length - 1 ? 12 : 0,
              ),
              child: _buildEscuelaButton(
                escuela: escuela,
                icon: _getEscuelaIcon(escuela.nombre),
                delay: index * 100,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEscuelaButton({
    required Escuela escuela,
    required IconData icon,
    required int delay,
  }) {
    final bool isSelected = _selectedEscuelaKey == escuela.id.toString();

    return GestureDetector(
      onTap: () => _selectEscuela(escuela),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? Colors.white.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.08),
          border: Border.all(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.18),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
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
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.08),
              ),
              child: Icon(
                icon,
                color: Colors.white.withValues(alpha: isSelected ? 1.0 : 0.7),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            // Texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    escuela.nombre,
                    style: TextStyle(
                      color: Colors.white.withValues(
                        alpha: isSelected ? 1.0 : 0.85,
                      ),
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Código: ${escuela.codigo}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // Indicador
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.3),
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