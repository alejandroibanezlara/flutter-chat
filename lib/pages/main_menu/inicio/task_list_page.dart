import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:chat/models/daily_task_user.dart';
import 'package:chat/services/dailytask/dailytaks_service.dart';

class TaskListWidget extends StatefulWidget {
  const TaskListWidget({Key? key}) : super(key: key);

  @override
  _TaskListWidgetState createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  List<Task> _tasks = [];
  DailyTask? _currentDailyTask;
  final TextEditingController _editController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final today = DateTime.now();
      final fecha = today.toIso8601String().split('T').first;
      final dailyTask = await Provider.of<DailyTaskService>(context, listen: false)
          .getTasksForDate(fecha);
      
      if (dailyTask != null) {
        setState(() {
          _currentDailyTask = dailyTask;
          _tasks = List<Task>.from(dailyTask.tasks);
        });
      }
    } catch (e) {
      // Silenciar el error, mantener la UI como está
    }
  }

  // task_list_widget.dart
  Future<void> _toggleTask(int index) async {
    if (_currentDailyTask == null) return;

    // 1. Actualización LOCAL del estado (inmediata)
    setState(() {
      final task = _tasks[index];
      if (task.completedAt == null) {
        task.completedAt = DateTime.now();
        task.status = 'done';
      } else {
        task.completedAt = null;
        task.status = 'pending';
      }
    });

    // 2. Actualización REMOTA (backend)
    await _updateTasks();

    // 3. Notificar al TimeProgressBar
    Provider.of<TaskProvider>(context, listen: false).markNeedsRefresh();
  }


  Future<void> _updateTasks() async {
    if (_currentDailyTask == null) return;

    final updatedDailyTask = DailyTask(
      id: _currentDailyTask!.id,
      usuario: _currentDailyTask!.usuario,
      fecha: _currentDailyTask!.fecha,
      tasks: List<Task>.from(_tasks),
    );

    await Provider.of<DailyTaskService>(context, listen: false)
        .updateTask(updatedDailyTask);
  }



  void _showEditDialog(int index) {
    final task = _tasks[index];
    _editController.text = task.title;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar tarea'),
        content: TextField(
          controller: _editController,
          decoration: const InputDecoration(
            labelText: 'Título de la tarea',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_editController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                setState(() {
                  _tasks[index].title = _editController.text.trim();
                });
                await _updateTasks();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tasks.isEmpty) {
      return const Center(
        child: Text('No hay tareas para hoy', style: TextStyle(color: Colors.white54)),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0,1)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_tasks.length, (index) {
          final task = _tasks[index];
          final completed = task.completedAt != null;
          return Row(
            children: [
              IconButton(
                iconSize: 30,
                onPressed: () => _toggleTask(index),
                icon: completed
                    ? const Icon(Icons.check_circle, color: Color(0xFFDC143C))
                    : (task.frog == true && task.status == 'pending'
                        ? Image.asset(
                              'assets/icons/little_phoenix.png',
                              width: 24,
                              height: 24,
                            )
                        : const Icon(Icons.radio_button_unchecked, color: Colors.grey)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 18,
                    decoration: completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
              if (!completed)
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showEditDialog(index),
                ),
            ],
          );
        }),
      ),
    );
  }
}