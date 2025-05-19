import 'package:chat/models/daily_task_user.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:chat/services/dailytask/dailytaks_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// Página para seleccionar la tarea más difícil entre las recibidas
class FourthQuestionPage extends StatefulWidget {
  const FourthQuestionPage({Key? key}) : super(key: key);

  @override
  State<FourthQuestionPage> createState() => _FourthQuestionPageState();
}

class _FourthQuestionPageState extends State<FourthQuestionPage> {
  late List<String> tasks;
  int? _selectedIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    tasks = (args is List<String>) ? args : <String>[];
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = 3;
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
          children: List.generate(5, (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 40,
            height: 1,
            color: index <= currentStep ? Colors.white : Colors.grey[800],
          )),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '¿Cuál de las tareas anteriores crees que te costará más mañana?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final selected = index == _selectedIndex;
                  return ListTile(
                    title: Text(tasks[index], style: const TextStyle(color: Colors.white)),
                    trailing: selected
                        ? FaIcon(FontAwesomeIcons.frog, color: Color(0xFFDC143C))
                        : const SizedBox(width: 24),
                    onTap: () => setState(() => _selectedIndex = index),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _selectedIndex != null
                  ? () {
                      // Construir lista de Task y pasarla al siguiente paso
                      final now = DateTime.now();
                      List<Task> taskObjects = tasks.asMap().entries.map((entry) {
                        return Task(
                          title: entry.value,
                          status: 'pending',
                          createdAt: now,
                          completedAt: null,
                          frog: entry.key == _selectedIndex ? true : false,
                        );
                      }).toList();
                      Navigator.pushNamed(
                        context,
                        'cuestionario_final_5',
                        arguments: taskObjects,
                      );
                    }
                  : null,
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