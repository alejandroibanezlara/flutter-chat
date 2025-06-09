import 'package:chat/models/daily_task_user.dart';
import 'package:chat/models/personal_data.dart';
import 'package:chat/models/routine.dart';
import 'package:chat/services/dailytask/dailytaks_service.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:chat/services/routine/routine_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/personalData/metaData_User_service.dart';
import 'package:chat/models/metaData_User.dart';
import 'package:chat/pages/shared/colores.dart'; // define grisClaro aquí

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  DateTime displayedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  void goToPreviousMonth() {
    setState(() {
      displayedMonth = DateTime(displayedMonth.year, displayedMonth.month - 1);
    });
  }

  void goToNextMonth() {
    setState(() {
      displayedMonth = DateTime(displayedMonth.year, displayedMonth.month + 1);
    });
  }

  int getDaysInMonth(DateTime m) {
    final next = m.month < 12
        ? DateTime(m.year, m.month + 1, 1)
        : DateTime(m.year + 1, 1, 1);
    return next.subtract(const Duration(days: 1)).day;
  }

  int getStartingBlanks(DateTime m) => DateTime(m.year, m.month, 1).weekday - 1;

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;



  // dentro de tu widget:
void _showDayDetails(DateTime cellDate) async {
  final uid = Provider.of<AuthService>(context, listen: false).usuario!.uid;
  final dailySvc = Provider.of<DailyTaskService>(context, listen: false);
  final routineSvc = Provider.of<RoutineService>(context, listen: false);
  final personalSvc = Provider.of<PersonalDataService>(context, listen: false);
  final metaSvc = Provider.of<MetaDataUserService>(context, listen: false);

  final results = await Future.wait([
    dailySvc.getTasksForDate(cellDate.toIso8601String().split('T').first),
    routineSvc.getRoutinesByStatus('in-progress'),
    personalSvc.getPersonalDataByUserId(uid),
    metaSvc.getStats(uid),
  ]);

  final DailyTask?   daily        = results[0] as DailyTask?;
  final List<Routine> routines    = results[1] as List<Routine>;
  final PersonalData  pd          = results[2] as PersonalData;
  final MetaDataUser  meta        = results[3] as MetaDataUser;

  final doneTasks     = daily?.tasks.where((t) => t.completedAt != null).toList()  ?? [];
  final undoneTasks   = daily?.tasks.where((t) => t.completedAt == null).toList() ?? [];
  final doneRoutines  = routines.where((r) =>
    r.diasCompletados.any((d) => isSameDay(d.fecha, cellDate) && d.status == StatusDiaCompletado.completado)
  ).toList();
  final bool didDaily = meta.retosDiariosCompletados.any((d) => isSameDay(d, cellDate));
  final bool isPerfectDay = meta.perfectDay.any((d) => isSameDay(d, cellDate));

    // 3) Encontramos valoraciones de esa fecha:
    Rating? sleep;
    try {
      sleep = pd.calidadSueno.firstWhere((r) => isSameDay(r.fecha, cellDate));
    } catch (_) {
      sleep = null;
    }

    Rating? init;
    try {
      init = pd.actitudInicial.firstWhere((r) => isSameDay(r.fecha, cellDate));
    } catch (_) {
      init = null;
    }

    Rating? fin;
    try {
      fin = pd.actitudFinal.firstWhere((r) => isSameDay(r.fecha, cellDate));
    } catch (_) {
      fin = null;
    }

  showDialog(context: context, builder: (_) {
    return AlertDialog(
      backgroundColor: Colors.black87,
      title: Text(DateFormat.yMMMd().format(cellDate),
          style: const TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // —– Racha y puntos —–
            // Text('Racha tareas: ${meta.rachaTareas}',
            //     style: const TextStyle(color: Colors.white)),
            // Text('Puntos conseguidos: ${meta.averageDailyPoints}',
            //     style: const TextStyle(color: Colors.white)),
            // const Divider(color: Colors.white54),

            // —– TAREAS —–
            _buildStatusRow('Tareas completadas', doneTasks.isNotEmpty, rojoBurdeos),
            for (var t in doneTasks)
              Text('• ${t.title}', style: const TextStyle(color: Colors.white70)),
            if (undoneTasks.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Tareas pendientes:',
                  style: TextStyle(color: Colors.grey.shade300)),
              for (var t in undoneTasks)
                Text('• ${t.title}', style: const TextStyle(color: Colors.white38)),
            ],
            const Divider(color: Colors.white54),

            // —– RUTINAS —–
            _buildStatusRow('Rutinas completadas', doneRoutines.isNotEmpty, rojoBurdeos),
            for (var r in doneRoutines)
              Text('• ${r.title}', style: const TextStyle(color: Colors.white70)),
            const Divider(color: Colors.white54),

            // —– RETOS —–
            _buildStatusRow('Reto diario completado', didDaily, dorado),
            const Divider(color: Colors.white54),

            // —– VALORACIONES —–
            // … aquí seguirían sueños, actitudes, etc. …
              if (sleep != null)
                Text('Calidad de sueño: ${sleep.nota}/5', style: TextStyle(color: (sleep.nota <= 3) ? grisClaro : rojoBurdeos,),),
              if (init  != null)
                Text('Actitud inicial: ${init.nota}/5', style: TextStyle(color: (init.nota <= 3) ? grisClaro : rojoBurdeos,),),
              if (fin   != null)
                Text('Actitud final: ${fin.nota}/5', style: TextStyle(color: (fin.nota <= 3) ? grisClaro : rojoBurdeos,),),


            // —– PERFECT DAY —–
            if (isPerfectDay) ...[
              const SizedBox(height: 12),
              Row(
                children: const [
                  Icon(Icons.star, color: dorado, size: 24),
                  SizedBox(width: 8),
                  Text('¡Día Perfecto!',
                      style: TextStyle(color: dorado, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
      ],
    );
  });
}

  @override
  Widget build(BuildContext context) {
    final authSvc = Provider.of<AuthService>(context, listen: false);
    final metaSvc = Provider.of<MetaDataUserService>(context, listen: false);
    final uid     = authSvc.usuario!.uid;

    return FutureBuilder<MetaDataUser>(
      future: metaSvc.getStats(uid), // traemos todo el historial
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Error cargando historial:\n${snap.error}'));
        }
        final meta = snap.data!;
        final today = DateTime.now();
        final blanks = getStartingBlanks(displayedMonth);
        final totalDays = getDaysInMonth(displayedMonth);

        // Pre‐convertimos las listas de fechas
        final perfects = meta.perfectDay;
        final diarios  = meta.retosDiariosCompletados;
        final semans  = meta.retosSemanalesCompletados;
        final mensus  = meta.retosMensualesCompletados;

        final List<Widget> dayCells = [];

        // celdas en blanco antes del día 1
        for (var i = 0; i < blanks; i++) {
          dayCells.add(const SizedBox());
        }

        for (var d = 1; d <= totalDays; d++) {
          final cell = DateTime(displayedMonth.year, displayedMonth.month, d);

          final isPerfect = perfects.any((dt) => isSameDay(dt, cell));
          final didDaily  = diarios .any((dt) => isSameDay(dt, cell));
          final didWeek   = semans .any((dt) => isSameDay(dt, cell));
          final didMonth  = mensus .any((dt) => isSameDay(dt, cell));


          Color bg;
          if (isPerfect) {
            bg = dorado;
          } else if (didDaily || didWeek || didMonth) {
            bg = rojoBurdeos;
          } else if (cell.isBefore(DateTime(today.year, today.month, today.day))) {
            bg = grisClaro;
          } else {
            bg = Colors.transparent;
          }


          final borderColor = (bg == Colors.transparent)
            // fondo transparente (que muestra el negro de detrás): mantenemos gris
            ? Colors.grey.shade400
            // cualquier otro fondo (dorado, rojo, grisClaro): borde negro
            : Colors.black;

          dayCells.add(
            GestureDetector(
               onTap: () => _showDayDetails(cell), 
            // onTap: () {
            //   final dateLabel = DateFormat.yMMMd().format(cell);
            //   final didTasks    = meta.diaTareasCompleto    .any((d) => isSameDay(d, cell));
            //   final didRoutines = meta.diasRutinasCompletadas.any((d) => isSameDay(d, cell));
            //   final didDaily    = meta.retosDiariosCompletados.any((d) => isSameDay(d, cell));
            //   final didWeekly   = meta.retosSemanalesCompletados.any((d) => isSameDay(d, cell));
            //   final didMonthly  = meta.retosMensualesCompletados.any((d) => isSameDay(d, cell));
            //   final isPerfect   = meta.perfectDay           .any((d) => isSameDay(d, cell));
            //   showDialog(
            //     context: context,
            //     builder: (_) => AlertDialog(
            //       backgroundColor: Colors.black87,
            //       title: Text('Progreso $dateLabel', style: const TextStyle(color: Colors.white)),
            //       content: Column(
            //         mainAxisSize: MainAxisSize.min,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           _buildStatusRow('Tareas completas',  didTasks,   rojoBurdeos),
            //           _buildStatusRow('Rutinas completas', didRoutines,rojoBurdeos),
            //           _buildStatusRow('Retos diarios',     didDaily,   rojoBurdeos),
            //           if (didWeekly)
            //             _buildStatusRow('Retos semanales', didWeekly,   dorado),
            //           if (didMonthly)
            //             _buildStatusRow('Retos mensuales', didMonthly,  dorado),
            //           if (isPerfect)
            //             Padding(
            //               padding: const EdgeInsets.only(top: 8.0),
            //               child: Row(
            //                 children: const [
            //                   Icon(Icons.star, color: dorado, size: 24),
            //                   SizedBox(width: 8),
            //                   Text('¡Día Perfecto!', style: TextStyle(color: dorado, fontWeight: FontWeight.bold)),
            //                 ],
            //               ),
            //             ),
            //         ],
            //       ),
            //       actions: [
            //         TextButton(
            //           onPressed: () => Navigator.pop(context),
            //           child: const Text('Cerrar'),
            //         ),
            //       ],
            //     ),
            //   );
            // },
              child: Container(
                decoration: BoxDecoration(
                  color: bg,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: Text(
                  d.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: bg == Colors.transparent ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Navegación de mes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: goToPreviousMonth, icon: const Icon(Icons.arrow_left)),
                  Text(
                    DateFormat.yMMMM().format(displayedMonth),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(onPressed: goToNextMonth, icon: const Icon(Icons.arrow_right)),
                ],
              ),
              const SizedBox(height: 8),
              // Cabecera días de la semana
              Row(children: const [
                Expanded(child: Center(child: Text('Lun'))),
                Expanded(child: Center(child: Text('Mar'))),
                Expanded(child: Center(child: Text('Mié'))),
                Expanded(child: Center(child: Text('Jue'))),
                Expanded(child: Center(child: Text('Vie'))),
                Expanded(child: Center(child: Text('Sáb'))),
                Expanded(child: Center(child: Text('Dom'))),
              ]),
              const SizedBox(height: 8),
              // Grid de días
              GridView.count(
                crossAxisCount: 7,
                childAspectRatio: 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: dayCells,
              ),
            ],
          ),
        );
      },
    );
  }
}


Widget _buildStatusRow(String label, bool done, Color accent) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Icon(done ? Icons.check_circle : Icons.cancel, color: done ? accent : Colors.grey, size: 20),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: done ? accent : Colors.white70)),
      ],
    ),
  );
}