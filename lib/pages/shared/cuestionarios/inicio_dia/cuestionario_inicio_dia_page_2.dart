// second_start_day_page.dart
import 'package:chat/models/daily_task_user.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:chat/services/dailytask/dailytaks_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecondStartDayPage extends StatefulWidget {
  const SecondStartDayPage({Key? key}) : super(key: key);

  @override
  State<SecondStartDayPage> createState() => _SecondStartDayPageState();
}

class _SecondStartDayPageState extends State<SecondStartDayPage> {
  // En este ejemplo se usan tareas simuladas.

    List<Task> _tasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTomorrowTasks();
  }

  Future<void> _loadTomorrowTasks() async {
    try {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final today = DateTime.now();
      final fecha = today.toIso8601String().split('T').first;
      final dailyTask = await Provider.of<DailyTaskService>(context, listen: false)
          .getTasksForDate(fecha);

      if (dailyTask != null) {
        setState(() {
          _tasks = List<Task>.from(dailyTask.tasks);
        });
      }
    } catch (_) {
      // Puedes registrar el error si lo deseas
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final currentStep = 1;
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
          children: List.generate(4, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 40,
              height: 1,
              color: (index <= currentStep) ? Colors.white : Colors.grey[800],
            );
          }),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título fijo
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Center(
                      child: Text(
                        'Prioridades',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Mensaje si no hay tareas
                  if (_tasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text(
                          'No hay tareas para hoy :(',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),

                  // Lista de tareas (si existen)
                  ..._tasks.map((task) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          tileColor: Colors.grey[900],
                          textColor: Colors.white,
                          title: Text(task.title),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      )),

                  const SizedBox(height: 40),

                  // Botón Siguiente SIEMPRE visible
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'cuestionario_inicial_3');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: rojoBurdeos,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Siguiente',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}