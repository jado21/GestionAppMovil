import 'package:flutter/material.dart';
import '../models/horario_view_model.dart';
import '../services/api_service.dart';
import '../services/report_service.dart';

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
    filtrados.sort((a, b) {
      int diaComp = (diasOrden[a.horario.dia] ?? 7).compareTo(diasOrden[b.horario.dia] ?? 7);
      if (diaComp != 0) return diaComp;
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Horario FISI", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF002244),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            onPressed: () => _reportService.generarPDF(_horariosAMostrar),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
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
                    padding: const EdgeInsets.all(12),
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
      color: const Color(0xFF002244),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              dropdownColor: const Color(0xFF003366),
              value: _periodoActual,
              style: const TextStyle(color: Colors.white),
              items: ["24-I", "24-II", "25-0"].map((p) => DropdownMenuItem(value: p, child: Text("Periodo $p"))).toList(),
              onChanged: (val) {
                _periodoActual = val!;
                _aplicarFiltros();
              },
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: DropdownButton<int>(
              dropdownColor: const Color(0xFF003366),
              value: _grupoActual,
              style: const TextStyle(color: Colors.white),
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
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 60,
          decoration: BoxDecoration(color: const Color(0xFF002244), borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(hd.horario.dia.substring(0, 3), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(hd.horario.horaInicio, style: const TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
        ),
        title: Text(hd.nombreCurso, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text("${hd.nombreDocente}\nAula: ${hd.horario.aulaId} | ${hd.horario.tipo}"),
        isThreeLine: true,
      ),
    );
  }
}