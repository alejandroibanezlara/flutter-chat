// file: first_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/services/dailytask/dailytaks_service.dart';
import 'package:chat/models/daily_task_user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Añade este import
import 'package:chat/pages/shared/colores.dart';

class FirstQuestionPage extends StatelessWidget {
  const FirstQuestionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dailyTaskService = Provider.of<DailyTaskService>(context);
    final currentStep = 0;
    // final Color(0xFFDC143C) = Color(0xFFDC143C); // Color para tareas completadas
    
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
      body: FutureBuilder<DailyTask?>(
        future: dailyTaskService.getTasksForDate(
          DateTime.now().toIso8601String().split('T').first),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error al cargar tareas', style: TextStyle(color: Colors.red)),
            );
          }

          final tasks = snapshot.data?.tasks ?? [];
          final completedTasks = tasks.where((t) => t.completedAt != null).toList();
          final pendingTasks = tasks.where((t) => t.completedAt == null).toList();

          // Datos de ejemplo para rutinas y retos
          final completedRoutines = ['Rutina mañanera', 'Rutina nocturna'];
          final completedChallenges = ['Reto de productividad', 'Reto de ejercicio'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tareas pendientes',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (pendingTasks.isEmpty)
                  const Text('No hay tareas pendientes', style: TextStyle(color: Colors.white54))
                else
                  for (var task in pendingTasks)
                    ListTile(
                      tileColor: Colors.grey[900],
                      textColor: Colors.white,
                      title: Text(task.title),
                      leading: const Icon(Icons.close, color: Colors.white), // Cruz blanca
                    ),
                const SizedBox(height: 16),

                const Text(
                  'Tareas completadas',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (completedTasks.isEmpty)
                  const Text('No hay tareas completadas', style: TextStyle(color: Colors.white54))
                else
                  for (var task in completedTasks)
                    ListTile(
                      tileColor: Colors.grey[900],
                      textColor: task.frog == true ? Color(0xFFDC143C) : Colors.white,
                      title: Text(task.title),
                      subtitle: Text('Completada: ${TimeOfDay.fromDateTime(task.completedAt!).format(context)}'),
                      leading: task.frog == true
                          ? const FaIcon(FontAwesomeIcons.frog, color: Color(0xFFDC143C)) // Rana para tareas frog
                          : const Icon(Icons.check, color: Color(0xFFDC143C)), // Check rojo burdeos
                    ),
                const SizedBox(height: 16),

                const Text(
                  'Rutinas completadas',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                for (var r in completedRoutines)
                  ListTile(
                    tileColor: Colors.grey[900],
                    textColor: Colors.white,
                    title: Text(r),
                    leading: const Icon(Icons.check, color: Color(0xFFDC143C)), // Check rojo burdeos
                  ),
                const SizedBox(height: 16),

                const Text(
                  'Retos superados hoy',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                for (var c in completedChallenges)
                  ListTile(
                    tileColor: Colors.grey[900],
                    textColor: Colors.white,
                    title: Text(c),
                    leading: const Icon(Icons.check, color: Color(0xFFDC143C)), // Check rojo burdeos
                  ),
                const SizedBox(height: 32),

                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, 'cuestionario_final_2'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: rojoBurdeos,          // color de fondo
                      foregroundColor: Colors.white,         // color de texto e iconos
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(         // radio de 8 px
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle(fontSize: 16),         // ya hereda color blanco
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}