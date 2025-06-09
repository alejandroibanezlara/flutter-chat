import 'package:flutter/material.dart';

class MeditationFeedbackPage extends StatelessWidget {
  final Duration duration;

  const MeditationFeedbackPage({Key? key, required this.duration}) : super(key: key);

  void _submitFeedback(BuildContext context, String value) {


    // Navegar a home
    Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
  }

  void _skipFeedback(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 40),
            Column(
              children: [
                const Icon(Icons.brightness_5, color: Colors.white, size: 48),
                const SizedBox(height: 16),
                const Text(
                  '¡Buen trabajo!',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer, color: Colors.white, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        duration.toString().substring(2, 7),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '¿Has disfrutado de esta meditación?',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _reactionButton(context, 'Sí', Icons.circle_outlined),
                    const SizedBox(width: 12),
                    _reactionButton(context, 'Un poco', Icons.adjust_outlined),
                    const SizedBox(width: 12),
                    _reactionButton(context, 'No', Icons.circle, isNegative: true),
                  ],
                ),
              ],
            ),
            TextButton(
              onPressed: () => _skipFeedback(context),
              child: const Text(
                'Saltar & Finalizar',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _reactionButton(BuildContext context, String label, IconData icon, {bool isNegative = false}) {
    return GestureDetector(
      onTap: () => _submitFeedback(context, label),
      child: Container(
        width: 80,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: isNegative ? Colors.white30 : Colors.white),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: Colors.white, fontSize: 14))
          ],
        ),
      ),
    );
  }
}
