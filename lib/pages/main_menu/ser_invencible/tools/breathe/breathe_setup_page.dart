import 'package:chat/pages/main_menu/ser_invencible/tools/breathe/breathe_page.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class BreathingWelcomePage extends StatelessWidget {
  const BreathingWelcomePage({Key? key}) : super(key: key);

  void _startExercise(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const BreathingExercisePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ejercicio de Respiración',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                'Este ejercicio durará 2 minutos y te guiará para inhalar, mantener y exhalar con calma. Concéntrate en el movimiento del disco.',
                style: TextStyle(color: Colors.white70, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => _startExercise(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: rojoBurdeos,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Comenzar', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
