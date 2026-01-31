import 'package:flutter/material.dart';
import '../models/horario_view_model.dart';
import '../services/api_service.dart';
import '../services/report_service.dart';
import '../theme/app_styles.dart';

class HorariosScreen extends StatefulWidget {
  const HorariosScreen({super.key});

  @override
  State<HorariosScreen> createState() => _HorariosScreenState();
}

class _HorariosScreenState extends State<HorariosScreen> {
  final ApiService _apiService = ApiService();
  final ReportService _reportService = ReportService();

  // los colores se actualizan en un cambio de tema gracias a estos getters
  ThemeData get theme => Theme.of(context);
  ColorScheme get colors => theme.colorScheme;
  Color get appBarBg => theme.appBarTheme.backgroundColor ?? colors.primary;
  Color get appBarFg => theme.appBarTheme.foregroundColor ?? colors.onPrimary;

  List<HorarioDetallado> _horariosAMostrar = [];
  bool _isLoading = true;

  // Filtros actuales
  String _periodoActual = "25-0";
  int _grupoActual = 1;

  @override
  void initState() {
    super.initState();
    _aplicarFiltros();
  }

  Future<void> _aplicarFiltros() async {
    setState(() => _isLoading = true);
    final filtrados = await _apiService.obtenerHorariosPorFiltro(_periodoActual, _grupoActual);
    
    // Ordenar por día de la semana y luego por hora
    final diasOrden = {'Lunes': 1, 'Martes': 2, 'Miércoles': 3, 'Jueves': 4, 'Viernes': 5, 'Sábado': 6};
    // ordena los horarios por día de la semana
    filtrados.sort((a, b) {
      // si no tienen dia, se asume domingo (7)
      int diaComp = (diasOrden[a.horario.dia] ?? 7).compareTo(diasOrden[b.horario.dia] ?? 7);
      if (diaComp != 0) return diaComp;
      // si están en el mismo dia, se comparan por hora de inicio
      return a.horario.horaInicio.compareTo(b.horario.horaInicio);
    });

    setState(() {
      _horariosAMostrar = filtrados;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Horario FISI", style: TextStyle(color: appBarFg)),
        backgroundColor: appBarBg,
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf, color: appBarFg),
            onPressed: () => _reportService.generarPDF(_horariosAMostrar),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: appBarFg),
            onPressed: () => Navigator.pushNamed(context, '/gestion').then((_) => _aplicarFiltros()),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFiltrosBar(),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _horariosAMostrar.isEmpty 
                ? const Center(child: Text("No hay cursos para este grupo y periodo"))
                : ListView.builder(
                    padding: AppSpacing.listPadding,
                    itemCount: _horariosAMostrar.length,
                    itemBuilder: (context, index) => _cardHorario(_horariosAMostrar[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltrosBar() {
    return Container(
      color: appBarBg,
      padding: AppSpacing.filterPadding,
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              dropdownColor: colors.secondary,
              value: _periodoActual,
              style: TextStyle(color: appBarFg),
              items: ["24-I", "24-II", "25-0"].map((p) => DropdownMenuItem(value: p, child: Text("Periodo $p"))).toList(),
              onChanged: (val) {
                _periodoActual = val!;
                _aplicarFiltros();
              },
            ),
          ),
          const SizedBox(width: AppSpacing.gapMd),
          Expanded(
            child: DropdownButton<int>(
              dropdownColor: colors.secondary,
              value: _grupoActual,
              style: TextStyle(color: appBarFg),
              items: [1, 2, 3, 4, 5, 7].map((g) => DropdownMenuItem(value: g, child: Text("Grupo $g"))).toList(),
              onChanged: (val) {
                _grupoActual = val!;
                _aplicarFiltros();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardHorario(HorarioDetallado hd) {
    return Card(
      elevation: 2,
      margin: AppSpacing.cardMarginBottom,
      shape: RoundedRectangleBorder(borderRadius: AppRadii.card),
      child: ListTile(
        leading: Container(
          width: 60,
          decoration: BoxDecoration(color: colors.primary, borderRadius: AppRadii.badge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                hd.horario.dia.substring(0, 3),
                style: TextStyle(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                hd.horario.horaInicio,
                style: TextStyle(
                    // color: colors.onPrimary.withValues(alpha: 0.9),
                    color: colors.onPrimary,
                    // fontSize: 10
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // este cambio en el style de title solo es un testeo
        // title: Text(hd.nombreCurso, style: AppTextStyles.horarioTitle),
        title: Text(hd.nombreCurso, style: theme.textTheme.headlineMedium),
        subtitle: Text("${hd.nombreDocente}\nAula: ${hd.horario.aulaId} | ${hd.horario.tipo}"),
        isThreeLine: true,
      ),
    );
  }
}
