import 'dart:async';
import 'package:chat/models/daily_task_user.dart';            // ← tu modelo
import 'package:chat/pages/shared/colores.dart';               // ← rojoBurdeos
import 'package:chat/services/dailytask/dailytaks_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Pantalla final: muestra la racha, anima iconos y guarda las tareas
class FifthQuestionPage extends StatefulWidget {
  const FifthQuestionPage({Key? key}) : super(key: key);

  @override
  State<FifthQuestionPage> createState() => _FifthQuestionPageState();
}

class _FifthQuestionPageState extends State<FifthQuestionPage>
    with TickerProviderStateMixin {
  // ───────────────────────── datos mock (ajusta a tu backend) ─────────────────
  final List<bool> pastDaysCompleted = [true, false, true]; // 3 días atrás
  final bool currentDayCompleted     = true;                // hoy
  final int futureDays               = 3;                   // preview

  // tareas recibidas
  late List<Task> _taskObjects;

  // ───────────────────────── estado de botón ─────────────────────────────────
  bool _isSaving = false;

  // ───────────────────────── animación rayos ─────────────────────────────────
  late final AnimationController _streakCtrl;
  List<Animation<double>> _scales = const []; // ← valor seguro por defecto

  // ───────────────────────── animación nº de racha ───────────────────────────
  late final AnimationController _numCtrl;
  Animation<double> _numScale = const AlwaysStoppedAnimation(0);

  // ───────────────────────── animación subtítulo ─────────────────────────────
  late final AnimationController? _subtitleCtrl;

  // ───────────────────────── getters útiles ──────────────────────────────────
  int get streakLength => 1000; // de momento fija; calcula según tu lógica
  String get dayLabel   => (streakLength == 1) ? 'día' : 'días';

  // ───────────────────────── ciclo de vida ───────────────────────────────────
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    _taskObjects = (args is List<Task>) ? args : <Task>[];
  }

  @override
  void initState() {
    super.initState();

    // ─── controller de rayos ──────────────────────────────────────
    final totalItems = pastDaysCompleted.length + 1 + futureDays;
    _streakCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scales = List.generate(totalItems, (i) {
      final begin = i / totalItems;
      final end   = (i + 0.8) / totalItems; // ligera superposición
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _streakCtrl,
          curve: Interval(begin, end, curve: Curves.elasticOut),
        ),
      );
    });

    // ─── número grande de racha ──────────────────────────────────
    _numCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

_numScale = TweenSequence<double>([
  // 0 → 1.4   (60 % del tiempo, con salida rápida y rebote ligero)
  TweenSequenceItem(
    weight: 60,
    tween: Tween(begin: 0.0, end: 5.0)
        .chain(CurveTween(curve: Curves.easeOutBack)),
  ),
  // 1.4 → 1.0 (40 %, vuelve suavemente al tamaño normal)
  TweenSequenceItem(
    weight: 40,
    tween: Tween(begin: 5.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeIn)),
  ),
]).animate(_numCtrl);

    // ─── subtítulo fade‑in ───────────────────────────────────────
    _subtitleCtrl = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 600),
    );

    // ─── lanza secuencia (nº → subtítulo → rayos) ────────────────
    Timer(const Duration(milliseconds: 300), () async {
      await _numCtrl.forward();
      await _subtitleCtrl?.forward();
      _streakCtrl.forward();
    });
  }

  @override
  void dispose() {
    _streakCtrl.dispose();
    _numCtrl.dispose();
    _subtitleCtrl?.dispose();
    super.dispose();
  }

  // ───────────────────────── lógica de guardado ──────────────────────────────
    Future<void> _onSaveAndFinish() async {
    setState(() => _isSaving = true);
    final service = Provider.of<DailyTaskService>(context, listen: false);
    final DailyTask? saved = await service.saveImportantTasks(_taskObjects);
    setState(() => _isSaving = false);
    if (saved != null) {
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar tareas')),
      );
    }
  }

  // ───────────────────────── helper: rayo individual ─────────────────────────
  Widget _buildBolt(int absIndex, {required bool filled}) {
  final Animation<double> scale = (absIndex < _scales.length)
      ? _scales[absIndex]
      : const AlwaysStoppedAnimation<double>(0); // ← tipado explícito

    return Expanded(
      child: ScaleTransition(
        scale: scale,
        child: CircleAvatar(
          backgroundColor: Colors.grey[800],
          child: Icon(Icons.bolt,
              color: filled ? rojoBurdeos : Colors.grey, size: 28),
        ),
      ),
    );
  }

  // ───────────────────────── build ───────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    const currentStep = 4;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(currentStep),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── encabezado motivador (nº grande + texto) ───────────
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Racha de ',
                          style: TextStyle(
                              color: Colors.white54,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                      ScaleTransition(
                        scale: _numScale,
                        child: Text('$streakLength',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      ),
                      Text(' $dayLabel',
                          style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 4),
FadeTransition(
  opacity: _subtitleCtrl ?? const AlwaysStoppedAnimation(0.0),
  child: const Text(
    '¡Sigue así!',
    style: TextStyle(
      color: Colors.white70,
      fontSize: 16,
      fontStyle: FontStyle.italic,
    ),
  ),
),
                ],
              ),

              const SizedBox(height: 24),

              // ── fila de rayos animados ─────────────────────────────
              Row(
                children: [
                  // días pasados
                  for (int i = 0; i < pastDaysCompleted.length; i++)
                    _buildBolt(i, filled: pastDaysCompleted[i]),

                  // día actual
                  _buildBolt(
                    pastDaysCompleted.length,
                    filled: currentDayCompleted,
                  ),

                  // días futuros
                  for (int i = 0; i < futureDays; i++)
                    _buildBolt(pastDaysCompleted.length + 1 + i,
                        filled: false),
                ],
              ),

              const SizedBox(height: 48),

              // ── botón guardar ──────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _onSaveAndFinish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rojoBurdeos,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Guardar y terminar por hoy'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────── AppBar reutilizado ──────────────────────────────
  AppBar _buildAppBar(int currentStep) => AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 40,
              height: 1,
              color: (i <= currentStep) ? Colors.white : Colors.grey[800],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ],
      );
}
