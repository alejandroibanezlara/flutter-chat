import 'package:chat/pages/shared/colores.dart';
import 'package:flutter/material.dart';

class BreathingSummaryPage extends StatelessWidget {
  const BreathingSummaryPage({super.key});

  void _goHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.air, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            const Text(
              '¡Ejercicio completado!',
              style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Has completado 2 minutos de respiración consciente.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _goHome(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: rojoBurdeos,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Volver al inicio', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
