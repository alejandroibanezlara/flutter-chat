import 'package:chat/pages/shared/colores.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/services/dailytask/dailytaks_service.dart';
import 'package:chat/models/daily_task_user.dart';


class TimeProgressBar extends StatelessWidget {
  const TimeProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return StreamBuilder<DateTime>(
          stream: Stream<DateTime>.periodic(
            const Duration(minutes: 5),
            (_) => DateTime.now(),
          ).asyncMap((_) {
            if (taskProvider.needsRefresh) {
              taskProvider.resetRefresh();
              return DateTime.now();
            }
            return _;
          }),
          builder: (context, snapshot) {
            final now = snapshot.data ?? DateTime.now();
            
            final startTime = DateTime(now.year, now.month, now.day, 6, 0); // 6:00 AM exacto
            final endTime = DateTime(now.year, now.month, now.day, 23, 0); // 23:00 exacto
            final totalMinutes = endTime.difference(startTime).inMinutes; // 1020 minutos (17 horas)
            final currentMinutes = now.isBefore(startTime)
                ? 0
                : now.isAfter(endTime)
                    ? totalMinutes
                    : now.difference(startTime).inMinutes;
            final progress = currentMinutes / totalMinutes;
            final percentage = (progress * 100).clamp(0, 100).toStringAsFixed(0);

            final dailyTaskService = Provider.of<DailyTaskService>(context);
            final today = DateTime(now.year, now.month, now.day);
            final fecha = today.toIso8601String().split('T').first;

            return FutureBuilder<DailyTask?>(
              future: dailyTaskService.getTasksForDate(fecha),
              builder: (context, taskSnapshot) {
                List<Map<String, dynamic>> markers = [];

                // Añadir marcadores para tareas completadas
                if (taskSnapshot.hasData && taskSnapshot.data != null) {
                  final completedTasks = taskSnapshot.data!.tasks
                      .where((task) => task.completedAt != null)
                      .toList();


                  for (final task in completedTasks) {
                    print(task.completedAt);
                    markers.add({
                      'time': TimeOfDay.fromDateTime(task.completedAt!),
                      'color': (task.frog == true) ? rojoBurdeos : blancoSuave,
                      'special': false,
                      'isTask': true,
                    });
                  }
                }

                return Container(
                  padding: const EdgeInsets.all(20.0),
                  constraints: const BoxConstraints(minHeight: 200),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Progreso de tu día',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            '6:00',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '23:00',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 25,
                            child: LinearProgressIndicator(
                              value: progress,
                              borderRadius: BorderRadius.circular(10.0),
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB0B0B0)),
                            )),
SizedBox(
  height: 25,
  child: LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      return Stack(
        children: markers.map((marker) {
          final tod = marker['time'] as TimeOfDay;
          final markerTime = DateTime(
            now.year, 
            now.month, 
            now.day, 
            tod.hour, 
            tod.minute
          );

          // Convertir a UTC y luego a local para consistencia
          final utcTime = markerTime.toUtc();
          final localTime = utcTime.toLocal();

          // Calcular minutos desde las 6:00 AM local
          final startTimeLocal = DateTime(now.year, now.month, now.day, 6).toUtc().toLocal();
          final minutesFromStart = localTime.difference(startTimeLocal).inMinutes;
          
          // Calcular posición proporcional (0.0 a 1.0)
          final position = minutesFromStart.toDouble() / totalMinutes.toDouble();
          final dx = position * width;
          
          return Positioned(
            left: dx.clamp(2.0, width - 2), // Evitar que toque los bordes
            top: marker['isTask'] == true ? -10 : 0,
            child: Container(
              width: 2,
              height: marker['isTask'] == true ? 45 : 35,
              color: marker['color'] as Color,
            ),
          );
        }).where((widget) => widget != SizedBox.shrink()).toList(), // Filtrar widgets vacíos
      );
    },
  ),
),
                          Text(
                            '$percentage%',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (now.hour >= 8 && now.minute >= 1 && now.minute <= 59)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFDC143C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, 'cuestionario_final_1');
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.question_answer, color: Colors.white),
                              SizedBox(width: 8),
                              Text("Cuestionario", style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      if (now.hour >= 8 && now.minute >= 1 && now.minute <= 59)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFDC143C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, 'cuestionario_inicial_1');
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.question_answer, color: Colors.white),
                              SizedBox(width: 8),
                              Text("C. Inicial", style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}