import 'package:chat/pages/main_menu/ser_invencible/tools/breathe/post_breathe_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';


class BreathingExercisePage extends StatefulWidget {
  const BreathingExercisePage({Key? key}) : super(key: key);

  @override
  State<BreathingExercisePage> createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Timer _timer;
  int _phaseIndex = 0;
  String _currentPhase = "Inhala";

  final List<_BreathPhase> _phases = [
    _BreathPhase("Inhala", 4000),
    _BreathPhase("Mantén", 4000),
    _BreathPhase("Exhala", 4000),
    _BreathPhase("Mantén", 4000),
  ];

  final Duration totalDuration = const Duration(minutes: 2);
  late DateTime _startTime;

  bool _showTimer = false;
  double _timerOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(_controller);

    _startPhaseCycle();
  }

  void _startPhaseCycle() {
    _setPhase(0);
    _timer = Timer.periodic(const Duration(milliseconds: 4000), (timer) {
      int nextIndex = (_phaseIndex + 1) % _phases.length;
      _setPhase(nextIndex);

      if (DateTime.now().difference(_startTime) >= totalDuration) {
        _endExercise();
      }
    });
  }

  void _setPhase(int index) {
    setState(() {
      _phaseIndex = index;
      _currentPhase = _phases[index].label;

      switch (_currentPhase) {
        case "Inhala":
          _controller.duration = Duration(milliseconds: _phases[index].durationMs);
          _scaleAnimation = Tween<double>(begin: 0.4, end: 0.9).animate(CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ));
          _controller.forward(from: 0.0);
          break;
        case "Exhala":
          _controller.duration = Duration(milliseconds: _phases[index].durationMs);
          _scaleAnimation = Tween<double>(begin: 0.9, end: 0.4).animate(CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ));
          _controller.forward(from: 0.0);
          break;
        default:
          _controller.stop();
          break;
      }
    });
  }

  void _toggleTimerDisplay() {
    setState(() {
      _showTimer = true;
      _timerOpacity = 1.0;
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _timerOpacity = 0.0;
        });

        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _showTimer = false;
            });
          }
        });
      }
    });
  }

  void _endExercise() {
    _timer.cancel();
    _controller.stop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const BreathingSummaryPage(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = totalDuration - DateTime.now().difference(_startTime);
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleTimerDisplay,
        behavior: HitTestBehavior.translucent,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentPhase,
                        style: const TextStyle(color: Colors.white, fontSize: 28),
                      ),
                      const SizedBox(height: 40),
                      Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          width: screenWidth * 0.8,
                          height: screenWidth * 0.8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              AnimatedOpacity(
                opacity: _timerOpacity,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                child: _showTimer
                    ? Text(
                        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BreathPhase {
  final String label;
  final int durationMs;
  const _BreathPhase(this.label, this.durationMs);
}
