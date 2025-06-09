import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:chat/pages/main_menu/ser_invencible/tools/meditation/post_meditation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MeditationWidget extends StatefulWidget {
  final Duration meditationDuration;

  const MeditationWidget({Key? key, required this.meditationDuration}) : super(key: key);

  @override
  _MeditationWidgetState createState() => _MeditationWidgetState();
}

class _MeditationWidgetState extends State<MeditationWidget> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late DateTime _startTime;
  late Duration _remainingTime;
  bool _isCompleted = false;
  bool _showTimer = false;
  double _timerOpacity = 0.0;
  

  final List<_MovingCircle> _circles = [];
  final int _circleCount = 15;
  Size? _screenSize;

  late AudioPlayer _audioPlayer; // Para la música

  @override
  void initState() {
    
    super.initState();
    _startTime = DateTime.now();
    _remainingTime = widget.meditationDuration;

    _ticker = createTicker(_onTick)..start();

    for (int i = 0; i < _circleCount; i++) {
      _circles.add(_MovingCircle.random());
    }

    _initMusic();
  }

  Future<void> _initMusic() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setSource(AssetSource('sounds/relaxing_music.mp3'));
    _audioPlayer.setReleaseMode(ReleaseMode.loop); // Repetir la música en bucle
    _audioPlayer.resume(); // Empezar a reproducir
  }

  void _onTick(Duration elapsed) {
    final elapsedTime = DateTime.now().difference(_startTime);

    setState(() {
      _remainingTime = widget.meditationDuration - elapsedTime;

      if (_screenSize != null) {
        for (var circle in _circles) {
          circle.updatePosition(_screenSize!);
        }
      }

      if (_remainingTime.isNegative && !_isCompleted) {
        _ticker.stop();
        _isCompleted = true;
        _registerSession();
      }
    });
  }

  void _registerSession() {
    // print("Meditación completada en ${DateTime.now()} durante ${widget.meditationDuration.inMinutes} minutos");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
      builder: (_) => MeditationFeedbackPage(duration: widget.meditationDuration),
    ),
);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _audioPlayer.dispose(); // Parar música
    super.dispose();
  }

  void _toggleTimerDisplay() {
    
    setState(() {
      
      _showTimer = true;
      _timerOpacity = 1.0; // Aparecer suavemente
    });

    Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _timerOpacity = 0.0; // Desvanecer
        });

        // Esperamos la animación y ocultamos el widget
        Future.delayed(Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _showTimer = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleTimerDisplay,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            ..._circles.map((c) => Positioned(
              left: c.x,
              top: c.y,
              child: Transform.rotate(
                angle: c.rotation,
                child: Container(
                  width: c.currentSize,
                  height: c.currentSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
            )),
            Center(
              child: _isCompleted
                  ? Text(
                      "¡Meditación completada!",
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    )
                  : AnimatedOpacity(
                      opacity: _timerOpacity,
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                      child: _showTimer
                          ? Text(
                              "${_remainingTime.inMinutes}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')}",
                              style: TextStyle(color: Colors.white, fontSize: 32),
                            )
                          : SizedBox.shrink(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovingCircle {
  double x;
  double y;
  double size;
  double dx;
  double dy;
  double rotation;
  double rotationSpeed;
  double pulsePhase;

  static final _random = Random();

  _MovingCircle({
    required this.x,
    required this.y,
    required this.size,
    required this.dx,
    required this.dy,
    required this.rotation,
    required this.rotationSpeed,
    required this.pulsePhase,
  });

  factory _MovingCircle.random() {
    return _MovingCircle(
      x: _random.nextDouble() * 400,
      y: _random.nextDouble() * 800,
      size: 20 + _random.nextDouble() * 30,
      dx: (_random.nextDouble() - 0.5) * 1.5,
      dy: (_random.nextDouble() - 0.5) * 1.5,
      rotation: _random.nextDouble() * 2 * pi,
      rotationSpeed: (_random.nextDouble() - 0.5) * 0.01,
      pulsePhase: _random.nextDouble() * 2 * pi,
    );
  }

  void updatePosition(Size screenSize) {
    x += dx;
    y += dy;
    rotation += rotationSpeed;
    pulsePhase += 0.05; // Velocidad de pulsación

    // Rebote elástico en bordes
    if (x <= 0 || x + size >= screenSize.width) {
      dx = -dx * 0.95; // Rebote con amortiguación
      x = x.clamp(0, screenSize.width - size);
    }
    if (y <= 0 || y + size >= screenSize.height) {
      dy = -dy * 0.95;
      y = y.clamp(0, screenSize.height - size);
    }
  }

  double get currentSize {
    return size * (0.95 + 0.05 * sin(pulsePhase)); // Pulsación suave entre 95% y 105% del tamaño
  }
}