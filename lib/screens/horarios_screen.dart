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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Horario FISI", style: AppTextStyles.onPrimary),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: AppColors.textOnPrimary),
            onPressed: () => _reportService.generarPDF(_horariosAMostrar),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.textOnPrimary),
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
      color: AppColors.primary,
      padding: AppSpacing.filterPadding,
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              dropdownColor: AppColors.primaryDark,
              value: _periodoActual,
              style: AppTextStyles.onPrimary,
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
              dropdownColor: AppColors.primaryDark,
              value: _grupoActual,
              style: AppTextStyles.onPrimary,
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
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadii.badge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(hd.horario.dia.substring(0, 3), style: AppTextStyles.chipDay),
              Text(hd.horario.horaInicio, style: AppTextStyles.chipTime),
            ],
          ),
        ),
        title: Text(hd.nombreCurso, style: AppTextStyles.horarioTitle),
        subtitle: Text("${hd.nombreDocente}\nAula: ${hd.horario.aulaId} | ${hd.horario.tipo}"),
        isThreeLine: true,
      ),
    );
  }
}
