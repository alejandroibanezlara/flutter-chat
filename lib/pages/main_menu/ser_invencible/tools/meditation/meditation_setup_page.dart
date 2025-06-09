import 'package:chat/pages/shared/colores.dart';
import 'package:flutter/material.dart';
import 'meditation_page.dart';

class MeditationSetupPage extends StatefulWidget {
  const MeditationSetupPage({Key? key}) : super(key: key);

  @override
  State<MeditationSetupPage> createState() => _MeditationSetupPageState();
}

class _MeditationSetupPageState extends State<MeditationSetupPage> {
  double _selectedMinutes = 10;

  void _startMeditation() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MeditationWidget(
          meditationDuration: Duration(minutes: _selectedMinutes.round()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Elige duración'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿Cuánto tiempo quieres meditar?',
              style: TextStyle(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text(
              '${_selectedMinutes.round()} minutos',
              style: TextStyle(color: Colors.white, fontSize: 48),
            ),
            const SizedBox(height: 16),
            Slider(
              min: 1,
              max: 60,
              divisions: 59,
              value: _selectedMinutes,
              onChanged: (value) {
                setState(() {
                  _selectedMinutes = value;
                });
              },
              activeColor: Colors.white,
              inactiveColor: Colors.white24,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _startMeditation,
              style: ElevatedButton.styleFrom(
                backgroundColor: rojoBurdeos,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Empezar meditación', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}