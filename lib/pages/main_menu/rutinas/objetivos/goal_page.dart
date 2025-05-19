import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Pantalla de creación de primer objetivo
class FirstGoalScreen extends StatelessWidget {
  const FirstGoalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Color de fondo claro para la pantalla
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Crear Primer Objetivo'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Center(
                child: ClipOval(
                  child: Image.asset(
                    'assets/1.png',
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Create Your First Goal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Let's figure out what drives you and why you are here.\n\n"
                "For your first goal, think about how you felt when you "
                "downloaded this app. Keep that feeling in mind when "
                "creating your goal.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA000), // Color anaranjado
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Acción al pulsar "Start": aquí podrías navegar a otra pantalla o iniciar el proceso
                    Navigator.pushNamed(context, 'namegoal');
                  },
                  child: const Text(
                    'Siguiente',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}


// Pantalla de creación de primer objetivo
class NameGoalScreen extends StatelessWidget {
  const NameGoalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Color de fondo claro para la pantalla
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Good Names for Goals'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Center(
                child: ClipOval(
                  child: Image.asset(
                    'assets/2.png',
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Create Your First Goal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Let's figure out what drives you and why you are here.\n\n"
                "For your first goal, think about how you felt when you "
                "downloaded this app. Keep that feeling in mind when "
                "creating your goal.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA000), // Color anaranjado
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Acción al pulsar "Start": aquí podrías navegar a otra pantalla o iniciar el proceso
                  },
                  child: const Text(
                    'Siguiente',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}