import 'dart:async';
import 'package:chat/pages/shared/colores.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RetoCronoPage extends StatefulWidget {
  const RetoCronoPage({Key? key}) : super(key: key);

  @override
  _RetoCronoPageState createState() => _RetoCronoPageState();
}

class _RetoCronoPageState extends State<RetoCronoPage> {
  static const int totalSeconds = 300; // 5 minutos = 300 segundos
  int secondsRemaining = totalSeconds;
  Timer? _timer;
  bool isRunning = false;

  void startTimer() {
    if (!isRunning) {
      setState(() {
        isRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (secondsRemaining == 0) {
          timer.cancel();
          setState(() {
            isRunning = false;
          });
        } else {
          setState(() {
            secondsRemaining--;
          });
        }
      });
    }
  }

  void stopTimer() {
    _timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      secondsRemaining = totalSeconds;
    });
  }

  String formatTime(int seconds) {
    final minutesPart = (seconds ~/ 60).toString().padLeft(2, '0');
    final secondsPart = (seconds % 60).toString().padLeft(2, '0');
    return "$minutesPart:$secondsPart";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = 1; // Valor de ejemplo para la barra de progreso en el AppBar.
    return Scaffold(
      backgroundColor: negroAbsoluto,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        // Flecha de retroceso
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: blancoSuave),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        // Indicador de pasos (3 barras en este ejemplo)
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 40,
              height: 1,
              color: (index <= currentStep) ? Colors.white : Colors.grey[800],
            );
          }),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // Distribuye verticalmente los elementos
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Título del temporizador
                const Text(
                  'Temporizador de 5 minutos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: blancoSuave,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                // Visualización del tiempo restante
                Text(
                  formatTime(secondsRemaining),
                  style: const TextStyle(
                    fontSize: 100,
                    color: rojoBurdeos,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                // Botones para controlar el temporizador (Iniciar/Detener/Reset)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Botón Iniciar / Detener según el estado del temporizador
                    ElevatedButton(
                      onPressed: isRunning ? stopTimer : startTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: negroAbsoluto,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
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
                    // Botón Reset para reiniciar el temporizador
                    ElevatedButton(
                      onPressed: resetTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
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
                const SizedBox(height: 40),
                // Botón para finalizar el reto por hoy
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'reto_fin');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rojoBurdeos,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Finalizar por hoy',
                    style: TextStyle(
                      fontSize: 18,
                      color: blancoSuave,
                      fontWeight: FontWeight.bold,
                    ),
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