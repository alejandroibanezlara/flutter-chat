import 'dart:async';
import 'package:chat/pages/widgets/finishAndUpdateButton.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/challenges/user_challenge_service.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/challenge.dart';
import 'package:chat/models/user_challenge.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:provider/provider.dart';

class RetoCronoPage extends StatefulWidget {
  final Challenge reto;

  const RetoCronoPage({
    Key? key,
    required this.reto,
  }) : super(key: key);

  @override
  _RetoCronoPageState createState() => _RetoCronoPageState();
}

class _RetoCronoPageState extends State<RetoCronoPage> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;
  bool _hasStarted = false;

  late UserChallenge _uc;
  bool _loading = true;

  void _start() {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
      _hasStarted = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsedSeconds++);
    });
  }

  void _stop() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _elapsedSeconds = 0;
      _hasStarted = true;
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }



  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _finishChallenge() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final personalDataSvc = Provider.of<PersonalDataService>(context, listen: false);
      final ucService = Provider.of<UserChallengeService>(context, listen: false);

      // 1) Actualizar contadores personales según periodo de reto
      await personalDataSvc.completeChallenge(
        authService.usuario!.uid,
        widget.reto.timePeriod, // 'daily'|'weekly'|'monthly'|'featured'
      );
      // 2) Registrar tiempo en UserChallenge
      await ucService.finishToday(_uc.id, _elapsedSeconds);

      Navigator.pushNamed(
        context,
        'reto_fin',
        arguments: { 'reto': widget.reto, 'resultado': _elapsedSeconds },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error finalizando reto: \$e')),
      );
    }
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
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('home', (r) => false),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 40, height: 1,
            color: (i <= currentStep) ? Colors.white : Colors.grey[800],
          )),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: blancoSuave),
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                        _formatTime(_elapsedSeconds),
                        style: const TextStyle(
                          fontSize: 100,
                          color: rojoBurdeos,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: _isRunning ? _stop : _start,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isRunning ? grisClaro : rojoBurdeos,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              _isRunning ? 'Detener' : 'Iniciar',
                              style: const TextStyle(fontSize: 18, color: blancoSuave, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _reset,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: grisClaro,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text(
                              'Reset',
                              style: TextStyle(fontSize: 18, color: blancoSuave, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      if (_hasStarted) ...[
                        const SizedBox(height: 40),
                        FinishChallengeButton(
                          reto: widget.reto,
                          uc: _uc,
                          // Solo habilitado si ya ha empezado al menos una vez
                          enabled: _hasStarted,
                          // Antes de todo: para timer/alarma
                          // preFinish: _preFinish,
                          // El resultado es el número de segundos transcurridos
                          resultBuilder: () async => _elapsedSeconds,
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
