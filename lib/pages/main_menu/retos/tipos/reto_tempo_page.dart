import 'dart:async';
import 'package:chat/pages/widgets/finishAndUpdateButton.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/challenge.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/challenges/user_challenge_service.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:chat/models/user_challenge.dart';
import 'package:provider/provider.dart';

class RetoTempoPage extends StatefulWidget {
  final Challenge reto;
  const RetoTempoPage({ Key? key, required this.reto }) : super(key: key);

  @override
  _RetoTempoPageState createState() => _RetoTempoPageState();
}

class _RetoTempoPageState extends State<RetoTempoPage> {
  late final int totalSeconds;
  late int secondsRemaining;
  Timer? _timer;
  bool isRunning = false;
  bool _hasStarted = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _alarmPlaying = false;
  Timer? _alarmTimer;

  late UserChallenge _uc;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final cfg = widget.reto.config;
    totalSeconds = (cfg != null && cfg['tempo'] is int)
        ? (cfg['tempo'] as int) * 60
        : 300;
    secondsRemaining = totalSeconds;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ucService = Provider.of<UserChallengeService>(context, listen: false);
      await ucService.getUserChallenges();
      final found = ucService.items.firstWhere(
        (u) => u.challengeId == widget.reto.id && u.isActive,
        orElse: () => UserChallenge(
          id: '', userId: '', challengeId: widget.reto.id,
          status: 'active', startDate: DateTime.now(), isActive: true,
          currentTotal: 0, streakDays: 0, counter: 0,
          writing: null, checklist: null, progressData: {},
          progressHistory: [], lastUpdated: DateTime.now(),
        ),
      );
      setState(() {
        _uc = found;
        // If there was previous elapsed, you could load it, but start fresh
        _loading = false;
      });
    });
  }

  void startTimer() {
    if (secondsRemaining <= 0) return;
    setState(() {
      isRunning = true;
      _hasStarted = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining == 1) {
        t.cancel();
        setState(() {
          secondsRemaining = 0;
          isRunning = false;
          _alarmPlaying = true;
        });
        _audioPlayer.play(AssetSource('alarm.mp3'));
        _alarmTimer = Timer(const Duration(seconds: 30), _stopAlarm);
      } else {
        setState(() => secondsRemaining--);
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    setState(() => isRunning = false);
  }

  void resetTimer() {
    _timer?.cancel();
    _alarmTimer?.cancel();
    _audioPlayer.stop();
    setState(() {
      isRunning = false;
      _alarmPlaying = false;
      secondsRemaining = totalSeconds;
      _hasStarted = true;
    });
  }

  Future<void> _stopAlarm() async {
    _alarmTimer?.cancel();
    await _audioPlayer.stop();
    setState(() => _alarmPlaying = false);
  }

  String formatTime(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  // Define un preFinish para parar temporizador y alarma


  Future<void> _finishChallenge() async {
    // Detener temporizador y alarma si están activos
    if (isRunning) {
      _timer?.cancel();
      setState(() => isRunning = false);
    }
    if (_alarmPlaying) {
      await _stopAlarm();
    }
    // Calcular tiempo usado
    final usedSeconds = totalSeconds - secondsRemaining;
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final personalDataSvc = Provider.of<PersonalDataService>(context, listen: false);
      final ucService = Provider.of<UserChallengeService>(context, listen: false);

      // Actualizar contadores personales según periodo de reto
      await personalDataSvc.completeChallenge(
        authService.usuario!.uid,
        widget.reto.timePeriod,
      );
      // Registrar tiempo usado en UserChallenge
      await ucService.finishToday(_uc.id, usedSeconds);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error finalizando reto: \$e')),
      );
    }

    Navigator.pushNamed(
      context,
      'reto_fin',
      arguments: {'reto': widget.reto, 'resultado': usedSeconds},
    );
  }

    @override
    void dispose() {
      _timer?.cancel();
      _alarmTimer?.cancel();
      _audioPlayer.dispose();
      super.dispose();
    }

    Future<void> _preFinish() async {
      if (_alarmPlaying) await _stopAlarm();
    }

  @override
  Widget build(BuildContext context) {
    const currentStep = 1;

    return Scaffold(
      backgroundColor: negroAbsoluto,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: blancoSuave),
          onPressed: () {
            // Acción para ir atrás
            Navigator.of(context).pushNamedAndRemoveUntil(
              'home',                           // Nombre de tu ruta Home
              (Route<dynamic> route) => false,  // Elimina todo lo anterior
            );
          },
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 40, height: 1,
              color: (i <= currentStep) ? Colors.white : Colors.grey[800],
            );
          }),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: blancoSuave),
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                                // Nuevo: título del reto encima
                Text(
                  widget.reto.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    color: blancoSuave,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                Text(
                  'Temporizador: ${formatTime(totalSeconds)}',
                  style: const TextStyle(
                    fontSize: 24,
                    color: blancoSuave,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  formatTime(secondsRemaining),
                  style: const TextStyle(
                    fontSize: 100,
                    color: rojoBurdeos,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // → Todos los controles en la misma fila
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Iniciar/Detener si quedan segundos
                    if (secondsRemaining > 0)
                      ElevatedButton(
                        onPressed: isRunning ? stopTimer : startTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isRunning ? grisClaro : rojoBurdeos,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          isRunning ? 'Detener' : 'Iniciar',
                          style: const TextStyle(
                            fontSize: 18,
                            color: blancoSuave,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    // Detener alarma en la misma fila cuando suene
                    if (_alarmPlaying)
                      ElevatedButton.icon(
                        onPressed: _stopAlarm,
                        icon: const Icon(Icons.stop, color: blancoSuave),
                        label: const Text(
                          'Detener alarma',
                          style: TextStyle(color: blancoSuave),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: rojoBurdeos,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),

                    // Reset siempre disponible
                    ElevatedButton(
                      onPressed: resetTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: grisClaro,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 18,
                          color: blancoSuave,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),

                // → “Finalizar por hoy” siempre visible tras un inicio
                if (_hasStarted) ...[
                  const SizedBox(height: 40),
                  FinishChallengeButton(
                    reto: widget.reto,
                    uc: _uc,
                    // Solo habilitado si ya ha empezado al menos una vez
                    enabled: _hasStarted,
                    // Antes de todo: para timer/alarma
                    preFinish: _preFinish,
                    // El resultado es el número de segundos transcurridos
                    resultBuilder: () async => totalSeconds - secondsRemaining,
                    label: 'Finalizar por hoy',
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
