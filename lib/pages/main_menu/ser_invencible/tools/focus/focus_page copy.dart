import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class FocusModulePage extends StatefulWidget {
  const FocusModulePage({Key? key}) : super(key: key);
 
  @override
  _FocusModulePageState createState() => _FocusModulePageState();
}

class _FocusModulePageState extends State<FocusModulePage> {
  final _formKey = GlobalKey<FormState>();

  // Variable para seleccionar el tipo de temporizador: 'countdown' o 'tabata'
  String _timerType = 'countdown';

  // Variables para Cuenta Atrás
  int _minutes = 0;
  int _seconds = 0;

  // Variables para Tabata (ahora con minutos y segundos)
  int _rounds = 0;
  int _workMinutes = 0;
  int _workSeconds = 0;
  int _restMinutes = 0;
  int _restSeconds = 0;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Temporizador'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Selección de tipo de temporizador
              RadioListTile<String>(
                title: const Text('Cuenta Atrás'),
                value: 'countdown',
                groupValue: _timerType,
                onChanged: (value) {
                  setState(() {
                    _timerType = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Tabata'),
                value: 'tabata',
                groupValue: _timerType,
                onChanged: (value) {
                  setState(() {
                    _timerType = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Campos para Cuenta Atrás
              if (_timerType == 'countdown') ...[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Minutos'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingresa los minutos';
                    if (int.tryParse(value) == null) return 'Ingresa un número válido';
                    return null;
                  },
                  onSaved: (value) {
                    _minutes = int.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Segundos'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingresa los segundos';
                    if (int.tryParse(value) == null) return 'Ingresa un número válido';
                    return null;
                  },
                  onSaved: (value) {
                    _seconds = int.parse(value!);
                  },
                ),
              ],
              // Campos para Tabata
              if (_timerType == 'tabata') ...[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Número de Rondas'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingresa el número de rondas';
                    if (int.tryParse(value) == null) return 'Ingresa un número válido';
                    return null;
                  },
                  onSaved: (value) {
                    _rounds = int.parse(value!);
                  },
                ),
                const SizedBox(height: 10),
                const Text('Tiempo de Trabajo'),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Minutos de Trabajo'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingresa los minutos de trabajo';
                    if (int.tryParse(value) == null) return 'Ingresa un número válido';
                    return null;
                  },
                  onSaved: (value) {
                    _workMinutes = int.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Segundos de Trabajo'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingresa los segundos de trabajo';
                    if (int.tryParse(value) == null) return 'Ingresa un número válido';
                    return null;
                  },
                  onSaved: (value) {
                    _workSeconds = int.parse(value!);
                  },
                ),
                const SizedBox(height: 10),
                const Text('Tiempo de Descanso'),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Minutos de Descanso'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingresa los minutos de descanso';
                    if (int.tryParse(value) == null) return 'Ingresa un número válido';
                    return null;
                  },
                  onSaved: (value) {
                    _restMinutes = int.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Segundos de Descanso'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingresa los segundos de descanso';
                    if (int.tryParse(value) == null) return 'Ingresa un número válido';
                    return null;
                  },
                  onSaved: (value) {
                    _restSeconds = int.parse(value!);
                  },
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                    if (_timerType == 'countdown'){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CountdownTimerDisplayPage(
                            duration: Duration(minutes: _minutes, seconds: _seconds),
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TabataTimerDisplayPage(
                            rounds: _rounds,
                            workTime: Duration(minutes: _workMinutes, seconds: _workSeconds),
                            restTime: Duration(minutes: _restMinutes, seconds: _restSeconds),
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  _timerType == 'countdown'
                      ? 'Iniciar Cuenta Atrás'
                      : 'Iniciar Tabata',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pantalla que muestra la cuenta regresiva en tiempo real (Cuenta Atrás)
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
        setState(() {
          _remaining = const Duration(seconds: 0);
        });
        // Reproducir sonido y vibrar al finalizar
        await _audioPlayer.play(AssetSource('alarm.mp3'));
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 1000);
        }
      } else {
        setState(() {
          _remaining -= const Duration(seconds: 1);
        });
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
    final String minutes = _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final String seconds = (_remaining.inSeconds.remainder(60)).toString().padLeft(2, '0');
 
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuenta Atrás'),
      ),
      body: Center(
        child: _remaining.inSeconds == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¡Tiempo agotado!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'home',
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text('Volver al Home'),
                  ),
                ],
              )
            : Text(
                '$minutes:$seconds',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}

/// Pantalla que muestra la ejecución del temporizador Tabata
class TabataTimerDisplayPage extends StatefulWidget {
  final int rounds;
  final Duration workTime;
  final Duration restTime;
  const TabataTimerDisplayPage({
    Key? key,
    required this.rounds,
    required this.workTime,
    required this.restTime,
  }) : super(key: key);
 
  @override
  _TabataTimerDisplayPageState createState() => _TabataTimerDisplayPageState();
}
 
class _TabataTimerDisplayPageState extends State<TabataTimerDisplayPage> {
  late int currentRound;
  late bool isWorkPhase; // true: fase de trabajo, false: fase de descanso
  late Duration remaining;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Variable para controlar si la alarma está encendida
  bool _alarmOn = false;

  @override
  void initState() {
    super.initState();
    currentRound = 1;
    isWorkPhase = true;
    remaining = widget.workTime;
    _alarmOn = false;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remaining.inSeconds <= 1) {
        timer.cancel();
        setState(() {
          remaining = const Duration(seconds: 0);
        });
        if (isWorkPhase) {
          // Transición de trabajo a descanso
          if (widget.restTime.inSeconds > 0) {
            setState(() {
              isWorkPhase = false;
              remaining = widget.restTime;
              _alarmOn = true; // Inicia la alarma en descanso
            });
            _audioPlayer.setReleaseMode(ReleaseMode.loop);
            await _audioPlayer.play(AssetSource('alarm.mp3'));
            _startTimer();
          } else {
            _nextRound();
          }
        } else {
          // En descanso: detener la alarma automáticamente al finalizar la cuenta
          if (_alarmOn) {
            await _audioPlayer.stop();
            setState(() {
              _alarmOn = false;
            });
          }
          _nextRound();
        }
      } else {
        setState(() {
          remaining -= const Duration(seconds: 1);
        });
      }
    });
  }

  void _nextRound() async {
    if (currentRound < widget.rounds) {
      if (_alarmOn) {
        await _audioPlayer.stop();
        setState(() {
          _alarmOn = false;
        });
      }
      setState(() {
        currentRound++;
        isWorkPhase = true;
        remaining = widget.workTime;
      });
      _startTimer();
    } else {
      // Se han completado todas las rondas
      setState(() {
        remaining = const Duration(seconds: 0);
      });
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
    String phaseText = isWorkPhase ? "Trabajo" : "Descanso";
    final String minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final String seconds = (remaining.inSeconds.remainder(60)).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabata en Ejecución'),
      ),
      body: Center(
        child: (remaining.inSeconds == 0 && currentRound >= widget.rounds)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¡Tabata terminado!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'home',
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text('Volver al Home'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ronda: $currentRound/${widget.rounds}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    phaseText,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '$minutes:$seconds',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  // Durante la fase de descanso, muestra el botón "Apagar Alarma"
                  if (!isWorkPhase && _alarmOn)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: () async {
                          await _audioPlayer.stop();
                          setState(() {
                            _alarmOn = false;
                          });
                        },
                        child: const Text('Apagar Alarma'),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}