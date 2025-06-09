// file: first_page.dart
import 'package:chat/models/routine.dart';
import 'package:chat/services/personalData/metaData_User_service.dart';
import 'package:chat/services/routine/routine_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/services/dailytask/dailytaks_service.dart';
import 'package:chat/models/daily_task_user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chat/pages/shared/colores.dart';

class FirstQuestionPage extends StatefulWidget {
  const FirstQuestionPage({Key? key}) : super(key: key);

  @override
  State<FirstQuestionPage> createState() => _FirstQuestionPageState();
}

class _FirstQuestionPageState extends State<FirstQuestionPage> {
  final RoutineService _routineService = RoutineService();
  List<Routine> _routines = [];
  bool _isLoading = true;

  // Lista de nombres de meses en español
  static const List<String> _meses = [
    '', 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
  ];

  Future<void> _loadRoutines() async {
    try {
      final routines = await _routineService.getRoutinesByStatus('in-progress');
      setState(() {
        _routines = routines;
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final dailyTaskService = Provider.of<DailyTaskService>(context);

    // Fecha de hoy sin hora
    final DateTime ahora = DateTime.now();
    final DateTime hoy = DateTime(ahora.year, ahora.month, ahora.day);

    // Filtrar rutinas completadas hoy, mostrando su estado en el resumen
    final List<Routine> rutinasHoy = _routines.where((routine) {
      final dias = routine.diasCompletados ?? [];
      return dias.any((d) => _isSameDay(d.fecha.toLocal(), hoy));
    }).toList();

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
            color: index <= 0 ? Colors.white : Colors.grey[800],
          )),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ],
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : FutureBuilder<DailyTask?>(
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
              final MetaDataUserService _metaDataUserService = MetaDataUserService();
              _metaDataUserService.pendingTasks = pendingTasks.length;
              _metaDataUserService.completedTasks = completedTasks.length;

              // 1) Cuenta las rutinas completadas HOY
              final completedRoutinesCount = _routines.where((routine) {
                final dias = routine.diasCompletados ?? [];
                return dias.any((d) =>
                  _isSameDay(d.fecha.toLocal(), hoy) &&
                  d.status == StatusDiaCompletado.completado
                );
              }).length;

              // 2) El resto (sin registro HOY o con status distinto) va a pendientes
              // final pendingRoutinesCount = _routines.length - completedRoutinesCount;
              final pendingRoutinesCount = rutinasHoy.length - completedRoutinesCount;

              _metaDataUserService.pendingRoutines = completedRoutinesCount;
              _metaDataUserService.completedRoutines = pendingRoutinesCount;


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
                          leading: const Icon(Icons.close, color: Colors.white),
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
                              ? Image.asset(
                                'assets/icons/little_phoenix.png',
                                width: 24,
                                height: 24,
                              )
                              : const Icon(Icons.check, color: Color(0xFFDC143C)),
                        ),
                    const SizedBox(height: 16),

                    Text(
                      'Resumen rutinas - ${hoy.day} ${_meses[hoy.month]} ${hoy.year}',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    if (rutinasHoy.isEmpty)
                      const Center(
                        child: Text(
                          'Hoy no hay rutinas, descansa!!',
                          style: TextStyle(
                            color: negroAbsoluto,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    else
                      GridView.count(
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        physics: const NeverScrollableScrollPhysics(),
                        children: rutinasHoy.map((routine) {
                          final dias = routine.diasCompletados ?? [];
                          final dia = dias.firstWhere(
                            (d) => _isSameDay(d.fecha.toLocal(), hoy),
                            orElse: () => DiaCompletado(
                              fecha: hoy,
                              status: StatusDiaCompletado.pendiente,
                              horaCompletado: null,
                              comentarios: null,
                            ),
                          );
                          final completed = dia.status == StatusDiaCompletado.completado;

                          return Container(
                            decoration: BoxDecoration(
                              color: completed ? rojoBurdeos : grisClaro,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              IconData(
                                routine.icono ?? Icons.check.codePoint,
                                fontFamily: 'MaterialIcons',
                              ),
                              size: 24,
                              color: completed ? Colors.white : Colors.black54,
                            ),
                          );
                        }).toList(),
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
                        leading: const Icon(Icons.check, color: Color(0xFFDC143C)),
                      ),
                    const SizedBox(height: 32),

                    Center(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, 'cuestionario_final_2'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: rojoBurdeos,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
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
              );
            },
          ),
    );
  }
}
