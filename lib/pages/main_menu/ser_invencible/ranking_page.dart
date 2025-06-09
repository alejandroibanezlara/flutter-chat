import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/dailytask/dailytaks_service.dart';
import 'package:chat/services/routine/routine_service.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:chat/services/personalData/metaData_User_service.dart';

import 'package:chat/models/daily_task_user.dart';
import 'package:chat/models/routine.dart';
import 'package:chat/models/personal_data.dart';
import 'package:chat/models/metaData_User.dart';

import 'package:chat/pages/shared/colores.dart';

class DailySummaryView extends StatefulWidget {
  const DailySummaryView({Key? key}) : super(key: key);

  @override
  _DailySummaryViewState createState() => _DailySummaryViewState();
}

class _DailySummaryViewState extends State<DailySummaryView>
    with AutomaticKeepAliveClientMixin<DailySummaryView> {
  late Future<List<dynamic>> _summaryFuture;
  late DateTime _targetDate;

  @override
  void initState() {
    super.initState();
    // fijamos "ayer"
    _targetDate = DateTime.now().subtract(const Duration(days: 1));
    final dateKey = _targetDate.toIso8601String().split('T').first;

    // recogemos servicios y UID
    final uid        = Provider.of<AuthService>(context, listen: false).usuario!.uid;
    final dailySvc   = Provider.of<DailyTaskService>(context, listen: false);
    final routineSvc = Provider.of<RoutineService>(context, listen: false);
    final personalSv = Provider.of<PersonalDataService>(context, listen: false);
    final metaSvc    = Provider.of<MetaDataUserService>(context, listen: false);

    // creamos el Future una sola vez
    _summaryFuture = Future.wait([
      dailySvc.getTasksForDate(dateKey),
      routineSvc.getRoutinesByStatus('in-progress'),
      personalSv.getPersonalDataByUserId(uid),
      metaSvc.getStats(uid),
    ]);
  }

  @override
  bool get wantKeepAlive => true;

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    super.build(context); // para el mixin
    return FutureBuilder<List<dynamic>>(
      future: _summaryFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Error cargando resumen de ayer:\n${snap.error}'));
        }

        // resultado desestructurado
        final DailyTask?   daily    = snap.data![0] as DailyTask?;
        final List<Routine> routines = snap.data![1] as List<Routine>;
        final PersonalData pd       = snap.data![2] as PersonalData;
        final MetaDataUser md       = snap.data![3] as MetaDataUser;

        // 1) Racha
        final currentStreak = pd.rachaActual + 1;
        final maxStreak     = pd.rachaMaxima;

        // 2) Rayos últimos 7 días (3 antes de "ayer", "ayer" y 3 después)
        final completedDays = (pd.diaCompletado ?? [])
            .map((d) => DateTime(d.fecha.year, d.fecha.month, d.fecha.day))
            .toSet();
        final flags = <bool>[];
        for (int i = 3; i > 0; i--) {
          final dt = _targetDate.subtract(Duration(days: i));
          flags.add(completedDays.contains(DateTime(dt.year, dt.month, dt.day)));
        }
        flags.add(true); // "ayer"
        flags.addAll(List<bool>.filled(3, false));

        // 3) Tareas de ayer
        final doneTasks   = daily?.tasks.where((t) => t.completedAt != null).toList()  ?? [];
        final undoneTasks = daily?.tasks.where((t) => t.completedAt == null).toList() ?? [];

        // 4) Rutinas de ayer
        final doneRoutines = routines.where((r) =>
          r.diasCompletados.any((d) =>
            _isSameDay(d.fecha, _targetDate) &&
            d.status == StatusDiaCompletado.completado
          )
        ).toList();

        // 5) Reto diario de ayer y perfect day
        final didDaily  = md.retosDiariosCompletados.any((d) => _isSameDay(d, _targetDate));
        final isPerfect = md.perfectDay.any((d) => _isSameDay(d, _targetDate));

        // 6) Valoraciones de ayer
        Rating? sleep, init, fin;
        try { sleep = pd.calidadSueno .firstWhere((r) => _isSameDay(r.fecha, _targetDate)); } catch (_) {}
        try { init  = pd.actitudInicial.firstWhere((r) => _isSameDay(r.fecha, _targetDate)); } catch (_) {}
        try { fin   = pd.actitudFinal .firstWhere((r) => _isSameDay(r.fecha, _targetDate)); } catch (_) {}

        // 2) Rayos últimos 7 días (3 antes de "ayer", "ayer" y 3 después)
        // ➜ Generamos también la lista de fechas:
        final List<DateTime> rayDates = List.generate(7, (i) {
          return _targetDate.subtract(Duration(days: 3 - i));
        });

        // UI final
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Fecha
              Text(
                'Resumen de ${DateFormat.yMMMMd().format(_targetDate)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: grisClaro,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Racha
              Text(
                'Racha de $currentStreak días  (Máx: $maxStreak)',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Rayos
              // 3) Construcción de la fila de rayos + fechas
              Row(
                children: List.generate(flags.length, (index) {
                  final bool done = flags[index];
                  final DateTime date = rayDates[index];
                  return Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: grisCarbon,
                          child: Icon(
                            Icons.bolt,
                            color: done ? rojoBurdeos : Colors.grey,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          // Formato ejemplo: "15 may"
                          DateFormat('dd/MM').format(date),
                          style: const TextStyle(
                            color: grisClaro,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // --- TAREAS ---
              const Text(
                'Tareas',
                style: TextStyle(
                  color: grisClaro,
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                )
              ),
              const SizedBox(height: 8),
              _buildStatusRow('Completadas', doneTasks.isNotEmpty, rojoBurdeos),
              for (var t in doneTasks)
                Text('• ${t.title}', style: const TextStyle(color: grisClaro)),
              if (undoneTasks.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildStatusRow('Pendientes', true, Colors.grey),
                for (var t in undoneTasks)
                  Text('• ${t.title}', style: const TextStyle(color: grisClaro)),
              ],
              const Divider(color: grisClaro, height: 32),

              // --- RUTINAS ---
              const Text(
                'Rutinas',
                style: TextStyle(
                  color: grisClaro,
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                )
              ),
              const SizedBox(height: 8),
              _buildStatusRow('Completadas', doneRoutines.isNotEmpty, rojoBurdeos),
              for (var r in doneRoutines)
                Text('• ${r.title}', style: const TextStyle(color: grisClaro)),
              const Divider(color: grisClaro, height: 32),

              // --- RETOS ---
              const Text(
                'Reto Diario',
                style: TextStyle(
                  color: grisClaro,
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                )
              ),
              const SizedBox(height: 8),
              _buildStatusRow('Completado', didDaily, dorado),
              const Divider(color: grisClaro, height: 32),

              // --- VALORACIONES ---
              const Text(
                'Valoraciones',
                style: TextStyle(
                  color: grisClaro,
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                )
              ),
              const SizedBox(height: 8),
              if (sleep != null)
                Text(
                  'Sueño: ${sleep.nota}/5',
                  style: TextStyle(
                    color: (sleep.nota <= 3) ? grisClaro : rojoBurdeos,
                  ),
                ),
              if (init != null)
                Text(
                  'Actitud inicial: ${init.nota}/5',
                  style: TextStyle(
                    color: (init.nota <= 3) ? grisClaro : rojoBurdeos,
                  ),
                ),
              if (fin != null)
                Text(
                  'Actitud final: ${fin.nota}/5',
                  style: TextStyle(
                    color: (fin.nota <= 3) ? grisClaro : rojoBurdeos,
                  ),
                ),


              const Divider(color: grisClaro, height: 32),

              // --- PERFECT DAY ---
              if (isPerfect)
                Row(
                  children: const [
                    ImageIcon(
                      color: dorado,
                      AssetImage('assets/icons/little_phoenix.png'),
                      size: 28, // Ajusta al mismo tamaño que tenías antes
                    ),
                    SizedBox(width: 8),
                    Text('¡Día Perfecto!',
                        style: TextStyle(color: dorado, fontWeight: FontWeight.bold)),
                  ],
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
        Icon(done ? Icons.check_circle : Icons.cancel,
             color: done ? accent : Colors.grey, size: 20),
        const SizedBox(width: 8),
        Text(label,
             style: TextStyle(color: done ? accent : grisClaro)),
      ],
    ),
  );
}