// lib/screens/commitment_page.dart

import 'dart:async';
import 'package:chat/models/ser_invencible_areas.dart';
import 'package:chat/pages/main_menu/rutinas/objetivos/objective_detail_page.dart';
import 'package:chat/pages/main_menu/rutinas/objetivos/objetivo_page.dart';
import 'package:chat/pages/shared/appbar/scroll_appbar.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:chat/services/objectives/objectives_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommitmentPage extends StatefulWidget {
  const CommitmentPage({Key? key}) : super(key: key);

  @override
  State<CommitmentPage> createState() => _CommitmentPageState();
}

class _CommitmentPageState extends State<CommitmentPage> {
  Timer? _pressTimer;
  bool _isPressed = false;
  double _pressProgress = 0.0;

  ObjectivesService get _service =>
      Provider.of<ObjectivesService>(context, listen: false);

  String get _nombre =>
      Provider.of<ObjectivesService>(context, listen: false).nombre ?? '';
  int get _tipo =>
      Provider.of<ObjectivesService>(context, listen: false).tipo ?? 1;
  String get _beneficios =>
      Provider.of<ObjectivesService>(context, listen: false).beneficio ?? '';

  List<AreaSerInvencible> get _selectedAreas =>
      Provider.of<ObjectivesService>(context, listen: false).selectedAreas ?? [];

  DateTime get _fechaInicio => DateTime.now();
  DateTime get _fechaFin {
    final now = DateTime.now();
    return DateTime(now.year + _tipo, now.month, now.day);
  }



  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String get _summaryPhrase {
    return 'Objetivo: $_nombre\n'
        'Desde: ${_formatDate(_fechaInicio)}\n'
        'Hasta: ${_formatDate(_fechaFin)}\n'
        'Beneficios: $_beneficios';
  }

  void _startPressTimer() {
    setState(() {
      _isPressed = true;
      _pressProgress = 0;
    });
    const total = Duration(seconds: 3);
    const step = Duration(milliseconds: 50);
    int elapsed = 0;
    _pressTimer = Timer.periodic(step, (t) {
      elapsed += step.inMilliseconds;
      setState(() {
        _pressProgress = elapsed / total.inMilliseconds;
      });
      if (elapsed >= total.inMilliseconds) {
        t.cancel();
        _onSigned();
      }
    });
  }

  void _cancelPressTimer() {
    _pressTimer?.cancel();
    setState(() {
      _isPressed = false;
      _pressProgress = 0;
    });
  }

  void _onSigned() async {
    try {
      
      _service.setFechaInicio(_fechaInicio);
      _service.setFechaFin(_fechaFin);
      // 1. Crear o obtener objetivo base (solo título y tipo)
      final objective = await _service.createObjective();
      // 2. Preparar datos adicionales
      final updates = {
        'beneficio': _beneficios,
        'areas': _selectedAreas.map((a) => a.titulo).toList(),
        'completado': false,
        'fechaCreacion': _fechaInicio.toIso8601String(),
        'fechaObjetivo': _fechaFin.toIso8601String(),
        'tipo': _tipo,
        'titulo': _nombre,
      };
      // 3. Actualizar objetivo con nuevos campos
      // await _service.createOrGetObjective();
      // 4. Navegar a detalle

      _service.clear();
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ObjectiveDetailPage(objective: objective)),
      );
    } catch (e) {
      // Manejar error (mostrar diálogo o snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar compromiso: $e')),
      );
      setState(() { _isPressed = false; _pressProgress = 0; });
    }
  }

  @override
  void dispose() {
    _pressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,                  // fondo negro
      appBar: const ScrollAppBar(currentStep: 2, totalSteps: 4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Resumen en cajita burdeos
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: rojoBurdeos,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _summaryPhrase,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),

              // Instrucción en blanco70
              Text(
                'Mantén pulsado para firmar tu compromiso',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),

              // Huella con progreso
              Center(
                child: GestureDetector(
                  onTapDown: (_) => _startPressTimer(),
                  onTapUp: (_) => _cancelPressTimer(),
                  onTapCancel: _cancelPressTimer,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: _isPressed ? _pressProgress : 0,
                          strokeWidth: 4,
                          backgroundColor: Colors.grey[800],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(rojoBurdeos),
                        ),
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: _isPressed
                              ? rojoBurdeos.withOpacity(0.2)
                              : Colors.grey[900],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.fingerprint,
                          size: 40,
                          color: _isPressed ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Porcentaje en burdeos
              if (_isPressed)
                Text(
                  '${(_pressProgress * 100).toStringAsFixed(0)}%',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: rojoBurdeos,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}