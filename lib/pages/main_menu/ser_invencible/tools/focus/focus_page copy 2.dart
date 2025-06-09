import 'dart:async';
import 'package:chat/pages/shared/colores.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

/// FocusModulePage
/// ----------------
/// Pantalla inicial para elegir modo de temporizador: Cuenta Atrás o Tabata.
class FocusModulePage extends StatelessWidget {
  const FocusModulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Selecciona Modo',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: blancoSuave,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rojoBurdeos,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CountdownConfigPage()),
                    );
                  },
                  child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.timer, size: 24, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Cuenta Atrás', style: TextStyle(fontSize: 20, color: Colors.white)),
                  ],
                ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rojoBurdeos,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TabataConfigPage()),
                    );
                  },
                  child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.repeat, size: 24, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Tabata', style: TextStyle(fontSize: 20, color: Colors.white)),
                  ],
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// CountdownConfigPage
/// --------------------
/// Configuración de Cuenta Atrás con selector tipo reloj digital.
class CountdownConfigPage extends StatefulWidget {
  const CountdownConfigPage({Key? key}) : super(key: key);
  @override
  _CountdownConfigPageState createState() => _CountdownConfigPageState();
}

class _CountdownConfigPageState extends State<CountdownConfigPage> {
  Duration _selectedDuration = const Duration(minutes: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar Cuenta Atrás'), backgroundColor: Colors.black),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.ms,
              minuteInterval: 1,
              secondInterval: 1,
              initialTimerDuration: _selectedDuration,
              onTimerDurationChanged: (value) => setState(() => _selectedDuration = value),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: rojoBurdeos,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => CountdownTimerDisplayPage(duration: _selectedDuration),
                ),
              );
            },
            child: const Text('Iniciar', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

/// TabataConfigPage
/// -----------------
/// Configuración de Tabata con selectores tipo reloj digital y rondas.
class TabataConfigPage extends StatefulWidget {
  const TabataConfigPage({Key? key}) : super(key: key);
  @override
  _TabataConfigPageState createState() => _TabataConfigPageState();
}

class _TabataConfigPageState extends State<TabataConfigPage> {
  final FixedExtentScrollController _roundsController = FixedExtentScrollController(initialItem: 7);
  Duration _workDuration = const Duration(seconds: 20);
  Duration _restDuration = const Duration(seconds: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar Tabata'), backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Text('Rondas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 100,
            child: CupertinoPicker(
              scrollController: _roundsController,
              itemExtent: 32,
              onSelectedItemChanged: (_) {},
              children: List.generate(20, (i) => Center(child: Text('${i + 1}'))),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Trabajo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 150,
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.ms,
              initialTimerDuration: _workDuration,
              onTimerDurationChanged: (value) => setState(() => _workDuration = value),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Descanso', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 150,
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.ms,
              initialTimerDuration: _restDuration,
              onTimerDurationChanged: (value) => setState(() => _restDuration = value),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: rojoBurdeos,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => TabataTimerDisplayPage(
                    rounds: _roundsController.selectedItem + 1,
                    workTime: _workDuration,
                    restTime: _restDuration,
                  ),
                ),
              );
            },
            child: const Text('Iniciar', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ]),
      ),
    );
  }
}

/// CountdownTimerDisplayPage
/// --------------------------
/// Pantalla de cuenta regresiva con sonido y vibración al finalizar.
class CountdownTimerDisplayPage extends StatefulWidget {
  final Duration duration;
  const CountdownTimerDisplayPage({Key? key, required this.duration}) : super(key: key);
  @override
  _CountdownTimerDisplayPageState createState() => _CountdownTimerDisplayPageState();
}

class _CountdownTimerDisplayPageState extends State<CountdownTimerDisplayPage> {
  late Duration _remaining;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remaining.inSeconds <= 1) {
        timer.cancel();
        setState(() => _remaining = Duration.zero);
        await _audioPlayer.play(AssetSource('alarm.mp3'));
        if (await Vibration.hasVibrator() ?? false) Vibration.vibrate(duration: 1000);
      } else {
        setState(() => _remaining -= const Duration(seconds: 1));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final min = _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(title: const Text('Cuenta Atrás'), backgroundColor: Colors.black),
      body: Center(
        child: _remaining == Duration.zero
            ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('¡Focus realizado!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, 'home', (_) => false), 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rojoBurdeos,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Volver al Inicio', style: TextStyle(color: blancoSuave),)),
              ])
            : Text('$min:$sec', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

/// TabataTimerDisplayPage
/// ----------------------
/// Pantalla de Tabata con fases de trabajo y descanso, sonido y vibración.
class TabataTimerDisplayPage extends StatefulWidget {
  final int rounds;
  final Duration workTime;
  final Duration restTime;
  const TabataTimerDisplayPage({Key? key, required this.rounds, required this.workTime, required this.restTime}) : super(key: key);
  @override
  _TabataTimerDisplayPageState createState() => _TabataTimerDisplayPageState();
}

class _TabataTimerDisplayPageState extends State<TabataTimerDisplayPage> {
  late int _currentRound;
  late bool _isWork;
  late Duration _remaining;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _alarmOn = false;

  @override
  void initState() {
    super.initState();
    _currentRound = 1;
    _isWork = true;
    _remaining = widget.workTime;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remaining.inSeconds <= 1) {
        timer.cancel();
        setState(() => _remaining = Duration.zero);
        if (_isWork) {
          if (widget.restTime > Duration.zero) {
            setState(() { _isWork = false; _remaining = widget.restTime; _alarmOn = true; });
            _audioPlayer.setReleaseMode(ReleaseMode.loop);
            await _audioPlayer.play(AssetSource('alarm.mp3'));
            _startTimer();
          } else {
            _nextRound();
          }
        } else {
          if (_alarmOn) { await _audioPlayer.stop(); setState(() => _alarmOn = false); }
          _nextRound();
        }
      } else {
        setState(() => _remaining -= const Duration(seconds: 1));
      }
    });
  }

  void _nextRound() async {
    if (_alarmOn) { await _audioPlayer.stop(); setState(() => _alarmOn = false); }
    if (_currentRound < widget.rounds) {
      setState(() { _currentRound++; _isWork = true; _remaining = widget.workTime; });
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phase = _isWork ? 'Trabajo' : 'Descanso';
    final min = _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(title: const Text('Tabata'), backgroundColor: Colors.black),
      body: Center(
        child: (_remaining == Duration.zero && _currentRound >= widget.rounds)
            ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('¡Tabata terminado!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, 'home', (_) => false), 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rojoBurdeos,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Volver al Inicio', style: TextStyle(color: blancoSuave),)),
              ])
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Ronda: $_currentRound/${widget.rounds}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(phase, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                Text('$min:$sec', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                if (!_isWork && _alarmOn)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () async { await _audioPlayer.stop(); setState(() => _alarmOn = false); }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: grisClaro,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Apagar Alarma', style: TextStyle(color: Colors.black),)),
                  ),
              ]),
      ),
    );
  }
}
