import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/escuela.dart';
import '../service/api_service.dart';
import 'horario_screen.dart';

class SeleccionHorarioScreen extends StatefulWidget {
  const SeleccionHorarioScreen({super.key});

  @override
  State<SeleccionHorarioScreen> createState() => _SeleccionHorarioScreenState();
}

class _SeleccionHorarioScreenState extends State<SeleccionHorarioScreen>
    with TickerProviderStateMixin {

  // Ciclos I-X
  static const List<String> ciclosRomano = [
    'I', 'II', 'III', 'IV', 'V',
    'VI', 'VII', 'VIII', 'IX', 'X',
  ];

  // Grupos por ciclo para FISI (UNMSM)
  static const Map<int, int> gruposPorCiclo = {
    1: 6,   // Ciclo I   → 6 grupos
    2: 6,   // Ciclo II  → 6 grupos
    3: 5,   // Ciclo III → 5 grupos
    4: 5,   // Ciclo IV  → 5 grupos
    5: 4,   // Ciclo V   → 4 grupos
    6: 4,   // Ciclo VI  → 4 grupos
    7: 3,   // Ciclo VII → 3 grupos
    8: 3,   // Ciclo VIII → 3 grupos
    9: 2,   // Ciclo IX  → 2 grupos
    10: 2,  // Ciclo X   → 2 grupos
  };

  // Periodo actual (hardcoded por ahora)
  static const String periodo = '2026-I';

  // Animaciones
  late AnimationController _headerController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  late AnimationController _formController;
  late Animation<double> _formFade;

  // Estado de los dropdowns
  List<Escuela> _escuelas = [];
  bool _cargandoEscuelas = false;
  String? _errorEscuelas;

  Escuela? _selectedEscuela;
  int? _selectedCicloIndex;
  int? _selectedGrupo;
  bool _cargandoHorario = false;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
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

    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _formFade = CurvedAnimation(
      parent: _formController,
      curve: Curves.easeOut,
    );

    _headerController.forward().then((_) {
      _formController.forward();
    });

    _cargarEscuelas();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _formController.dispose();
    super.dispose();
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
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargandoEscuelas = false;
        _errorEscuelas = 'Error al cargar las escuelas';
      });
    }
  }

  void _onEscuelaChanged(Escuela? escuela) {
    setState(() {
      _selectedEscuela = escuela;
      // Resetear ciclo y grupo al cambiar escuela
      _selectedCicloIndex = null;
      _selectedGrupo = null;
    });
  }

  void _onCicloChanged(int? cicloIndex) {
    setState(() {
      _selectedCicloIndex = cicloIndex;
      // Resetear grupo al cambiar ciclo
      _selectedGrupo = null;
    });
  }

  void _onGrupoChanged(int? grupo) {
    setState(() {
      _selectedGrupo = grupo;
    });
  }

  int get _cantidadGrupos {
    if (_selectedCicloIndex == null) return 0;
    return gruposPorCiclo[_selectedCicloIndex! + 1] ?? 4;
  }

  bool get _formularioCompleto =>
      _selectedEscuela != null &&
      _selectedCicloIndex != null &&
      _selectedGrupo != null;

  Future<void> _consultarHorario() async {
    if (!_formularioCompleto) return;

    setState(() => _cargandoHorario = true);

    try {
      final ciclo = (_selectedCicloIndex! + 1).toString();
      final grupo = _selectedGrupo!.toString();

      // Ciclo I: cursos iguales para las 3 escuelas, se usa Ing. Sistemas (57)
      final escuelaIdParaApi = ciclo == '1' ? '57' : _selectedEscuela!.id.toString();

      final data = await ApiService.enviarCicloGrupo(
        ciclo,
        grupo,
        escuelaIdParaApi,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) {
            return ResultadoScreen(
              horarioResponse: data,
              periodo: periodo,
              escuela: _selectedEscuela!.nombre,
              ciclo: ciclosRomano[_selectedCicloIndex!],
              grupo: grupo,
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
        setState(() => _cargandoHorario = false);
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
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app_rounded, color: Colors.white, size: 28),
            onPressed: () => SystemNavigator.pop(),
            tooltip: 'Salir',
          ),
          const SizedBox(width: 8),
        ],
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

          // Overlay oscuro
          Container(color: Colors.black.withValues(alpha: 0.6)),

          // Contenido
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
                    const SizedBox(height: 30),

                    // Header animado
                    SlideTransition(
                      position: _headerSlide,
                      child: FadeTransition(
                        opacity: _headerFade,
                        child: _buildHeader(),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Formulario animado
                    FadeTransition(
                      opacity: _formFade,
                      child: _buildFormulario(),
                    ),

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

  Widget _buildHeader() {
    return Column(
      children: [
        // Ícono decorativo
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFC92834).withValues(alpha: 0.3),
            border: Border.all(
              color: const Color(0xFFC92834).withValues(alpha: 0.6),
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.calendar_month_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
        const SizedBox(height: 16),
        // Nombre de la facultad
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Facultad de Ingeniería de\nSistemas e Informática',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        // Periodo
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFC92834).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFC92834).withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: const Text(
            'Horario $periodo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFFC92834),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildFormulario() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Dropdown: Escuela
          _buildDropdownCard(
            icon: Icons.school_rounded,
            label: 'Escuela',
            child: _buildEscuelaDropdown(),
          ),

          const SizedBox(height: 18),

          // Dropdown: Ciclo
          AnimatedOpacity(
            opacity: _selectedEscuela != null ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 300),
            child: _buildDropdownCard(
              icon: Icons.engineering_rounded,
              label: 'Ciclo',
              child: _buildCicloDropdown(),
            ),
          ),

          const SizedBox(height: 18),

          // Dropdown: Grupo
          AnimatedOpacity(
            opacity: _selectedCicloIndex != null ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 300),
            child: _buildDropdownCard(
              icon: Icons.groups_rounded,
              label: 'Grupo',
              child: _buildGrupoDropdown(),
            ),
          ),

          const SizedBox(height: 32),

          // Botón Consultar
          _buildConsultarButton(),
        ],
      ),
    );
  }

  Widget _buildDropdownCard({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFFC92834).withValues(alpha: 0.45),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label con ícono
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Dropdown
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEscuelaDropdown() {
    if (_cargandoEscuelas) {
      return _buildMiniLoader('Cargando escuelas...');
    }

    if (_errorEscuelas != null) {
      return _buildErrorRow();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withValues(alpha: 0.12),
        border: Border.all(
          color: _selectedEscuela != null
              ? Colors.white.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.2),
          width: _selectedEscuela != null ? 1.5 : 1.0,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Escuela>(
          isExpanded: true,
          value: _selectedEscuela,
          hint: Text(
            'Selecciona una escuela',
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
          borderRadius: BorderRadius.circular(14),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          items: _escuelas.map((escuela) {
            return DropdownMenuItem<Escuela>(
              value: escuela,
              child: Text(
                escuela.nombre,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: _onEscuelaChanged,
        ),
      ),
    );
  }

  Widget _buildCicloDropdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withValues(alpha: 0.12),
        border: Border.all(
          color: _selectedCicloIndex != null
              ? Colors.white.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.2),
          width: _selectedCicloIndex != null ? 1.5 : 1.0,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: _selectedCicloIndex,
          hint: Text(
            'Selecciona un ciclo',
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
          borderRadius: BorderRadius.circular(14),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          items: _selectedEscuela != null
              ? List.generate(ciclosRomano.length, (index) {
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(
                      'Ciclo ${ciclosRomano[index]}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                })
              : null,
          onChanged: _selectedEscuela != null ? _onCicloChanged : null,
        ),
      ),
    );
  }

  Widget _buildGrupoDropdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withValues(alpha: 0.12),
        border: Border.all(
          color: _selectedGrupo != null
              ? Colors.white.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.2),
          width: _selectedGrupo != null ? 1.5 : 1.0,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: _selectedGrupo,
          hint: Text(
            'Selecciona un grupo',
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
          borderRadius: BorderRadius.circular(14),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          items: _selectedCicloIndex != null
              ? List.generate(_cantidadGrupos, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text(
                      'Grupo ${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                })
              : null,
          onChanged: _selectedCicloIndex != null ? _onGrupoChanged : null,
        ),
      ),
    );
  }

  Widget _buildConsultarButton() {
    return AnimatedOpacity(
      opacity: _formularioCompleto ? 1.0 : 0.4,
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: GestureDetector(
          onTap: _formularioCompleto && !_cargandoHorario
              ? _consultarHorario
              : null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: _formularioCompleto
                      ? const Color(0xFFC92834).withValues(alpha: 0.85)
                      : const Color(0xFFC92834).withValues(alpha: 0.4),
                  border: Border.all(
                    color: _formularioCompleto
                        ? Colors.white.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                  boxShadow: _formularioCompleto
                      ? [
                          BoxShadow(
                            color: const Color(0xFFC92834).withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: _cargandoHorario
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Cargando horario...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Consultar Horario',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
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

  Widget _buildMiniLoader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Colors.white.withValues(alpha: 0.7),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorEscuelas!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _cargarEscuelas,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white.withValues(alpha: 0.15),
              ),
              child: const Text(
                'Reintentar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
