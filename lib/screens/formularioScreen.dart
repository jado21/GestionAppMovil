import 'package:flutter/material.dart';
import '../service/api_service.dart';
import 'scheduleScreen.dart'; 

class FormularioScreen extends StatefulWidget {
  final bool esCachimbo; 

  const FormularioScreen({super.key, required this.esCachimbo});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  late TextEditingController cicloController;
  final grupoController = TextEditingController();
  bool cargando = false;

  @override
  void initState() {
    super.initState();
    // Inicialización lógica según el perfil recibido
    cicloController = TextEditingController(text: widget.esCachimbo ? '1' : '');
  }

  @override
  void dispose() {
    cicloController.dispose();
    grupoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color rojoTransparente = const Color(0xFFC92834).withOpacity(0.6);
    final Color blancoTransparente = Colors.white.withOpacity(0.2);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Fondo de pantalla
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo_formulario.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Filtro oscuro para legibilidad
          Container(color: Colors.black.withOpacity(0.6)),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.esCachimbo ? Icons.auto_stories : Icons.engineering,
                    color: Colors.white,
                    size: 70,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.esCachimbo ? '¡Bienvenido, Cachimbo!' : 'Perfil: Regular',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Consulta tu Horario',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Si NO es cachimbo, mostramos el campo Ciclo
                  if (!widget.esCachimbo) ...[
                    _buildGlassTextField(
                      controller: cicloController,
                      label: 'Ciclo Académico',
                      icon: Icons.school,
                      fillColor: rojoTransparente,
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Campo Grupo siempre presente
                  _buildGlassTextField(
                    controller: grupoController,
                    label: 'Número de Grupo',
                    icon: Icons.group,
                    fillColor: rojoTransparente,
                  ),
                  
                  const SizedBox(height: 50),

                  cargando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : SizedBox(
                          width: 220,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blancoTransparente,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              side: const BorderSide(color: Colors.white54, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: _enviarDatos,
                            child: const Text(
                              'VER HORARIO',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _enviarDatos() async {
    // Validación según perfil
    if (grupoController.text.isEmpty || (!widget.esCachimbo && cicloController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa los datos solicitados')),
      );
      return;
    }

    setState(() => cargando = true);

    try {
      final data = await ApiService.enviarCicloGrupo(
        cicloController.text.trim(),
        grupoController.text.trim(),
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultadoScreen(horarioResponse: data),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color fillColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: label,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
      ),
    );
  }
}