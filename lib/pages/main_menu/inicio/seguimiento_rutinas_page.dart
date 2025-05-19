import 'package:chat/services/routine/routine_service.dart';
import 'package:flutter/material.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:chat/models/routine.dart';

class SemanaRutinasWidget extends StatefulWidget {
  const SemanaRutinasWidget({Key? key}) : super(key: key);

  @override
  _SemanaRutinasWidgetState createState() => _SemanaRutinasWidgetState();
}

class _SemanaRutinasWidgetState extends State<SemanaRutinasWidget> {
  int _selectedDayIndex = 3;
  final RoutineService _routineService = RoutineService();
  List<Routine> _routines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

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

  List<Map<String, dynamic>> _generateDays() {
    final today = DateTime.now();
    return List.generate(7, (index) {
      final date = today.subtract(Duration(days: 3 - index));
      String label;
      if (_isSameDay(date, today)) {
        label = 'Hoy';
      } else {
        switch (date.weekday) {
          case DateTime.monday:
            label = 'lun'; break;
          case DateTime.tuesday:
            label = 'mar'; break;
          case DateTime.wednesday:
            label = 'mié'; break;
          case DateTime.thursday:
            label = 'jue'; break;
          case DateTime.friday:
            label = 'vie'; break;
          case DateTime.saturday:
            label = 'sáb'; break;
          case DateTime.sunday:
            label = 'dom'; break;
          default:
            label = '';
        }
      }
      return {
        'date': date,
        'label': label,
        'dayNum': date.day.toString().padLeft(2, '0'),
        'isToday': _isSameDay(date, today),
      };
    });
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final days = _generateDays();
    final selectedDate = days[_selectedDayIndex]['date'] as DateTime;

        // Obtiene las rutinas programadas para la fecha seleccionada, según tipo y reglas:
    final routinesForDate = _routines.where((r) {
      if (r.tipo == TiposRutina.semanal) {
        final days = r.reglasRepeticion.diasSemana ?? r.diasSemana ?? [];
        return days.contains(selectedDate.weekday);
      }
      if (r.tipo == TiposRutina.mensual) {
        final days = r.reglasRepeticion.diasMes ?? r.diasMes ?? [];
        return days.contains(selectedDate.day);
      }
      if (r.tipo == TiposRutina.personalizada) {
        // Solo para rutinas personalizadas: completadas o próximas
        return r.diasCompletados.any((d) => _isSameDay(d.fecha, selectedDate)) ||
               (r.proximosDias?.any((d) => _isSameDay(d, selectedDate)) ?? false);
      }
      return false;
    }).toList();

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: blancoSuave,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rutinas',
            style: TextStyle(
              color: negroAbsoluto,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Fila de los 7 días intacta
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final day = days[index];
                  final isSelected = _selectedDayIndex == index;
                  final date = day['date'] as DateTime;
                  final dayRoutines = _routines.where((r) =>
                    r.diasCompletados.any((d) => _isSameDay(d.fecha, date))
                  ).toList();

                  final allCompleted = dayRoutines.isNotEmpty && dayRoutines.every((r) {
                    final d = r.diasCompletados.firstWhere((d) => _isSameDay(d.fecha, date));
                    return d.status == StatusDiaCompletado.completado;
                  });

                  
                  // Solo marcar como amarillo si hay rutinas y todas completadas
                  final containerColor = (dayRoutines.isNotEmpty && allCompleted)
                    ? dorado
                    : (isSelected ? rojoBurdeos : Colors.grey[300]!); allCompleted
                    ? dorado
                    : (isSelected ? rojoBurdeos : Colors.grey[300]!);

                  return GestureDetector(
                    onTap: () => setState(() => _selectedDayIndex = index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day['label'] as String,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? rojoBurdeos : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: containerColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            day['dayNum'] as String,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Rutinas del día',
            style: TextStyle(
              color: negroAbsoluto,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (routinesForDate.isEmpty)
            const Center(
              child: Text(
                'Hoy no hay rutinas, descansa!!',
                style: TextStyle(
                  color: negroAbsoluto,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ) else
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              physics: const NeverScrollableScrollPhysics(),
              children: routinesForDate.map((routine) {
                final dia = routine.diasCompletados.firstWhere(
                  (d) => _isSameDay(d.fecha, selectedDate),
                  orElse: () => DiaCompletado(
                    fecha: selectedDate,
                    status: StatusDiaCompletado.pendiente,
                    horaCompletado: null,
                    comentarios: null,
                  ),
                );
                final completed = dia.status == StatusDiaCompletado.completado;

                return GestureDetector(
                  onTap: () async {
                    final newStatus = completed
                      ? StatusDiaCompletado.pendiente
                      : StatusDiaCompletado.completado;
                    final updatedDias = [
                      ...routine.diasCompletados.where((d) => !_isSameDay(d.fecha, selectedDate)),
                      DiaCompletado(
                        fecha: selectedDate,
                        status: newStatus,
                        horaCompletado: DateTime.now(),
                        comentarios: dia.comentarios,
                      ),
                    ];

                    // Prepara el payload completo usando toJson() para incluir campos requeridos
                    final payload = routine.toJson();
                    payload['diasCompletados'] = updatedDias.map((d) => d.toJson()).toList();
                    await RoutineService.updateRoutine(routine.id, payload);


                    setState(() {
                      final idx = _routines.indexWhere((r) => r.id == routine.id);
                      _routines[idx].diasCompletados
                        ..clear()
                        ..addAll(updatedDias);
                    });
                  },
                  child: Container(
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
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
