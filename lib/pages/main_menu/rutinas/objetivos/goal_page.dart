// lib/screens/name_goal_screen.dart

import 'package:chat/pages/main_menu/rutinas/objetivos/reason_page.dart';
import 'package:chat/pages/shared/appbar/scroll_appbar.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:chat/services/objectives/objectives_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NameGoalScreen extends StatefulWidget {
  final int tipo;
  const NameGoalScreen({Key? key, required this.tipo})
      : assert(tipo == 1 || tipo == 3 || tipo == 5, 'tipo debe ser 1, 3 o 5'),
        super(key: key);

  @override
  State<NameGoalScreen> createState() => _NameGoalScreenState();
}

class _NameGoalScreenState extends State<NameGoalScreen> {
  final _controller = TextEditingController();
  bool _canProceed = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _canProceed) {
        setState(() => _canProceed = hasText);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Guardamos en el servicio y navegamos a Benefits
  void _onNext() async {
    if (!_canProceed) return;
    final nombre = _controller.text.trim();
    final objectivesService =
        Provider.of<ObjectivesService>(context, listen: false);

    // 1️⃣ Guardar estado local en el servicio
    objectivesService.setNombre(nombre);
    objectivesService.setTipo(widget.tipo);

    // 3️⃣ Navegar a la pantalla de beneficios
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const BenefitGoalScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: ScrollAppBar(currentStep: 0, totalSteps: 3,),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                'Give your goal a name',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Be specific: "Read to the kids 3 times a week" is better than '
                '"Spend more time with my family."',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Name',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Oh, and don\'t worry, you can always change the name later.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white54,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _canProceed ? _onNext : null,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      }
                      return rojoBurdeos;
                    }),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}