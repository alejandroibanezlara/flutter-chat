import 'package:chat/pages/shared/colores.dart';   // aquí tienes tu const Color rojoBurdeos
import 'package:flutter/material.dart';

// Página para escribir hasta 5 tareas y enviarlas
class ThirdQuestionPage extends StatefulWidget {
  const ThirdQuestionPage({Key? key}) : super(key: key);

  @override
  State<ThirdQuestionPage> createState() => _ThirdQuestionPageState();
}

class _ThirdQuestionPageState extends State<ThirdQuestionPage> {
  final List<TextEditingController> _controllers =
      List.generate(5, (_) => TextEditingController());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  // ────── decoración reutilizable para los TextField ──────────────
  InputDecoration _taskDecoration(int i) => InputDecoration(
        hintText: 'Tarea #${i + 1}',
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.grey[900],
        // borde cuando NO está enfocado
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        // borde cuando SÍ está enfocado  → rojo burdeos
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: rojoBurdeos, width: 2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    const currentStep = 2;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 40,
              height: 1,
              color:
                  (index <= currentStep) ? Colors.white : Colors.grey[800],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Anota hasta 5 tareas para tu día de mañana',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 16),

            // ────── 5 campos de texto con borde dinámico ─────────────
            for (int i = 0; i < 5; i++)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: TextField(
                  controller: _controllers[i],
                  style: const TextStyle(color: Colors.white),
                  decoration: _taskDecoration(i),
                ),
              ),

            const SizedBox(height: 24),

            // ────── botón Siguiente ─────────────────────────────────
            ElevatedButton(
              onPressed: () {
                final tasks = _controllers
                    .map((c) => c.text.trim())
                    .where((t) => t.isNotEmpty)
                    .toList();

                Navigator.pushNamed(
                  context,
                  'cuestionario_final_4',
                  arguments: tasks,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: rojoBurdeos,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Siguiente', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
