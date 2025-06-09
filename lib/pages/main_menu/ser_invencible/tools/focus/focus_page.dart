import 'dart:async';
import 'package:chat/pages/shared/colores.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

/// FocusModulePage
/// Página principal que integra selección de modo, configuración y temporizadores
class FocusModulePage extends StatefulWidget {
  const FocusModulePage({Key? key}) : super(key: key);

  @override
  _FocusModulePageState createState() => _FocusModulePageState();
}

class _FocusModulePageState extends State<FocusModulePage> {
  final FlutterLocalNotificationsPlugin _notifPlugin = FlutterLocalNotificationsPlugin();



  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    // Asegura que el binding está inicializado antes de usar servicios de Flutter

    WidgetsFlutterBinding.ensureInitialized();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettings = InitializationSettings(android: androidSettings);
    await _notifPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) async {
        if (response.actionId == 'stop') {
          await AudioPlayer().stop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Focus Module'), backgroundColor: Colors.black),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Selecciona Modo', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),

              // Cuenta Atrás
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: rojoBurdeos,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CountdownConfigPage(notif: _notifPlugin)),
                ),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.timer, color: Colors.white), SizedBox(width: 8), Text('Cuenta Atrás', style: TextStyle(color: Colors.white),)]),
              ),
              const SizedBox(height: 16),

              // Tabata
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: rojoBurdeos,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TabataConfigPage(notif: _notifPlugin)),
                ),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.repeat, color: Colors.white), SizedBox(width: 8), Text('Tabata', style: TextStyle(color: Colors.white),)]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Página de configuración de Cuenta Atrás
class CountdownConfigPage extends StatefulWidget {
  final FlutterLocalNotificationsPlugin notif;
  const CountdownConfigPage({Key? key, required this.notif}) : super(key: key);
  @override
  _CountdownConfigPageState createState() => _CountdownConfigPageState();
}

class _CountdownConfigPageState extends State<CountdownConfigPage> {
  Duration _duration = const Duration(minutes: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar Cuenta Atrás'), backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.ms,
              initialTimerDuration: _duration,
              minuteInterval: 1,
              secondInterval: 1,
              onTimerDurationChanged: (d) => setState(() => _duration = d),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => CountdownTimerDisplayPage(duration: _duration, notif: widget.notif)),
            ),
            child: const Text('Iniciar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

/// Página de configuración de Tabata
class TabataConfigPage extends StatefulWidget {
  final FlutterLocalNotificationsPlugin notif;
  const TabataConfigPage({Key? key, required this.notif}) : super(key: key);
  @override
  _TabataConfigPageState createState() => _TabataConfigPageState();
}

class _TabataConfigPageState extends State<TabataConfigPage> {
  final _roundCtrl = FixedExtentScrollController(initialItem: 7);
  Duration _work = const Duration(seconds: 20);
  Duration _rest = const Duration(seconds: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar Tabata'), backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const Text('Rondas', style: TextStyle(color: Colors.white)),
          SizedBox(
            height: 100,
            child: CupertinoPicker(
              scrollController: _roundCtrl,
              itemExtent: 32,
              onSelectedItemChanged: (_) => setState(() {}),
              children: List.generate(20, (i) => Center(child: Text('${i + 1}', style: const TextStyle(color: Colors.white)))),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Trabajo', style: TextStyle(color: Colors.white)),
          SizedBox(
            height: 150,
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.ms,
              initialTimerDuration: _work,
              onTimerDurationChanged: (d) => setState(() => _work = d),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Descanso', style: TextStyle(color: Colors.white)),
          SizedBox(
            height: 150,
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.ms,
              initialTimerDuration: _rest,
              onTimerDurationChanged: (d) => setState(() => _rest = d),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64)),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => TabataTimerDisplayPage(
                rounds: _roundCtrl.selectedItem + 1,
                workTime: _work,
                restTime: _rest,
                notif: widget.notif,
              )),
            ),
            child: const Text('Iniciar'),
          ),
        ]),
      ),
    );
  }
}

/// Display de Cuenta Atrás con acción Detener
class CountdownTimerDisplayPage extends StatefulWidget {
  final Duration duration;
  final FlutterLocalNotificationsPlugin notif;
  const CountdownTimerDisplayPage({Key? key, required this.duration, required this.notif}) : super(key: key);
  @override
  _CountdownTimerDisplayPageState createState() => _CountdownTimerDisplayPageState();
}

class _CountdownTimerDisplayPageState extends State<CountdownTimerDisplayPage> {
  late Duration _left;
  Timer? _timer;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _left = widget.duration;
    _updateNotification(
      id: 0,
      title: 'Cuenta Atrás',
      channel: 'focus',
      body: _format(_left),
      withAction: true,
    );
    _tick();
  }

  void _tick() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (_left.inSeconds <= 1) {
        t.cancel();
        await widget.notif.cancel(0);
        setState(() => _left = Duration.zero);
        await _player.play(AssetSource('alarm.mp3'));
        if (await Vibration.hasVibrator() ?? false) Vibration.vibrate(duration: 1000);
      } else {
        setState(() => _left -= const Duration(seconds: 1));
        await _updateNotification(
          id: 0,
          title: 'Cuenta Atrás',
          channel: 'focus',
          body: _format(_left),
          withAction: true,
        );
      }
    });
  }

  Future<void> _updateNotification({
    required int id,
    required String title,
    required String channel,
    required String body,
    required bool withAction,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channel,
      '$title Timer',
      channelDescription: 'Temporizador en lockscreen',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      visibility: NotificationVisibility.public,
      onlyAlertOnce: true,
      actions: withAction ? [AndroidNotificationAction('stop', 'Detener')] : null,
    );
    await widget.notif.show(id, title, body, NotificationDetails(android: androidDetails));
  }

  String _format(Duration d) =>
      '${d.inMinutes.remainder(60).toString().padLeft(2,'0')}:'
      '${d.inSeconds.remainder(60).toString().padLeft(2,'0')}';

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    widget.notif.cancel(0);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_left == Duration.zero) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cuenta Atrás')),        
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('¡Focus realizado!', style: TextStyle(color: Colors.white, fontSize: 32)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, 'home', (_) => false),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: const Text('Volver al Inicio', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Cuenta Atrás')),
      backgroundColor: Colors.black,
      body: Center(
        child: Text(_format(_left), style: const TextStyle(color: Colors.white, fontSize: 48)),
      ),
    );
  }
}

/// Display de Tabata con acción Detener en descanso
class TabataTimerDisplayPage extends StatefulWidget {
  final int rounds;
  final Duration workTime;
  final Duration restTime;
  final FlutterLocalNotificationsPlugin notif;
  const TabataTimerDisplayPage({Key? key, required this.rounds, required this.workTime, required this.restTime, required this.notif}) : super(key: key);
  @override
  _TabataTimerDisplayPageState createState() => _TabataTimerDisplayPageState();
}

class _TabataTimerDisplayPageState extends State<TabataTimerDisplayPage> {
  late int _currentRound;
  late bool _isWork;
  late Duration _remaining;
  Timer? _timer;
  final AudioPlayer _player = AudioPlayer();
  bool _alarmOn = false;

  @override
  void initState() {
    super.initState();
    _currentRound = 1;
    _isWork = true;
    _remaining = widget.workTime;
    _updateNotification(
      id: 1,
      title: 'Tabata - Trabajo',
      channel: 'tabata',
      body: _format(_remaining),
      withAction: false,
    );
    _tick();
  }

  void _tick() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        if (_remaining.inSeconds <= 1) {
          timer.cancel();
          await widget.notif.cancel(1);
          setState(() => _remaining = Duration.zero);
          if (_isWork) {
            if (widget.restTime > Duration.zero) {
              setState(() {
                _isWork = false;
                _remaining = widget.restTime;
                _alarmOn = true;
              });
              _player.setReleaseMode(ReleaseMode.loop);
              await _player.play(AssetSource('alarm.mp3'));
              _updateNotification(
                id: 1,
                title: 'Tabata - Descanso',
                channel: 'tabata',
                body: _format(_remaining),
                withAction: true,
              );
              _tick();
            } else {
              _nextRound();
            }
          } else {
            if (_alarmOn) {
              await _player.stop();
              setState(() => _alarmOn = false);
            }
            _nextRound();
          }
        } else {
          setState(() => _remaining -= const Duration(seconds: 1));
          _updateNotification(
            id: 1,
            title: 'Tabata - ${_isWork ? 'Trabajo' : 'Descanso'}',
            channel: 'tabata',
            body: _format(_remaining),
            withAction: !_isWork,
          );
        }
      },
    );
  }

  Future<void> _updateNotification({
    required int id,
    required String title,
    required String channel,
    required String body,
    required bool withAction,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channel,
      '$title Timer',
      channelDescription: 'Lockscreen notification',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      visibility: NotificationVisibility.public,
      onlyAlertOnce: true,
      actions: withAction ? [AndroidNotificationAction('stop', 'Detener')] : null,
    );
    await widget.notif.show(id, title, body, NotificationDetails(android: androidDetails));
  }

  void _nextRound() {
    if (_alarmOn) {
      _player.stop();
    }
    if (_currentRound < widget.rounds) {
      setState(() {
        _currentRound++;
        _isWork = true;
        _remaining = widget.workTime;
      });
      _updateNotification(
        id: 1,
        title: 'Tabata - Trabajo',
        channel: 'tabata',
        body: _format(_remaining),
        withAction: false,
      );
      _tick();
    }
  }

  String _format(Duration d) =>
      '${d.inMinutes.remainder(60).toString().padLeft(2,'0')}:'
      '${d.inSeconds.remainder(60).toString().padLeft(2,'0')}';

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    widget.notif.cancel(1);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining == Duration.zero && _currentRound >= widget.rounds) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tabata'), backgroundColor: Colors.black),
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('¡Tabata terminado!', style: TextStyle(color: Colors.white, fontSize: 32)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, 'home', (_) => false),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: const Text('Volver al Inicio', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Tabata'), backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ronda: $_currentRound/${widget.rounds}', style: const TextStyle(color: Colors.white, fontSize: 24)),
            const SizedBox(height: 10),
            Text(_isWork ? 'Trabajo' : 'Descanso', style: const TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 20),
            Text(_format(_remaining), style: const TextStyle(color: Colors.white, fontSize: 48)),
          ],
        ),
      ),
    );
  }
}
