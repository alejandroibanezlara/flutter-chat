import 'package:flutter/material.dart';

class HallOfFamePage extends StatelessWidget {
  const HallOfFamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFFDC143C), Color.fromARGB(255, 237, 148, 148)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Hall of Fame',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'The Hall of Fame celebrates habits you’ve formed and decided to retire. Poner los OBJETIVOS CONSEGUIDOS Y LAS RUTINAS ESTABLECIDAS',
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(height: 8),
            Text(
              'No Habits',
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}