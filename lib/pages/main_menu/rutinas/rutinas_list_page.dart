import 'package:chat/pages/main_menu/rutinas/rutineCard.dart';
import 'package:chat/services/routine/routine_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/models/routine.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:chat/pages/main_menu/rutinas/row_dias_widget.dart';

class RutinasListPage extends StatefulWidget {
  const RutinasListPage({Key? key}) : super(key: key);

  @override
  State<RutinasListPage> createState() => _RutinasListPageState();
}

class _RutinasListPageState extends State<RutinasListPage> {
  bool _isCompactView = false;
  int _expandedIndex = -1;
  late Future<List<Routine>> _futureRoutines;

  @override
  void initState() {
    super.initState();
    _futureRoutines = RoutineService().getRoutinesByStatus('in-progress');
  }

  void _incrementRoutine(Routine routine) {
    setState(() {
      final completions = routine.diasCompletados?.length ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Routine>>(
      future: _futureRoutines,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final rutinas = snapshot.data ?? [];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Rutinas',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      Navigator.pushNamed(context, 'newHabit');
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(thickness: 1, color: Colors.white),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rutinas.length,
              itemBuilder: (context, index) {
                final rutina = rutinas[index];
                final isExpanded = (_expandedIndex == index);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _expandedIndex = isExpanded ? -1 : index;
                    });
                  },
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        buildRoutineCard(
                          rutina: rutina,
                          context: context,
                          title: rutina.title,
                          count: rutina.diasCompletados.length ?? 0,
                          icon: rutina.icono != null
                              ? IconData(rutina.icono!, fontFamily: 'MaterialIcons')
                              : Icons.star,
                          onPlusPressed: () => _incrementRoutine(rutina),
                          compact: _isCompactView,
                          areas: rutina.areas,
                          tipo: rutina.tipo,
                          diasSemana: rutina.diasSemana ?? [],
                          diasMes: rutina.diasMes ?? [],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class SquaresSection extends StatefulWidget {
  final Map<String, dynamic> rutina;

  const SquaresSection({required this.rutina, Key? key}) : super(key: key);

  @override
  _SquaresSectionState createState() => _SquaresSectionState();
}

class _SquaresSectionState extends State<SquaresSection> {
  double _scale = 1.0;

  void _animateTap() async {
    setState(() => _scale = 0.95);
    await Future.delayed(Duration(milliseconds: 100));
    setState(() => _scale = 1.0);
  }

  int getIsoWeekNumber(DateTime date) {
    final thursday = date.add(Duration(days: (3 - date.weekday + 7) % 7));
    final firstThursday = DateTime(thursday.year, 1, 4);
    final startOfFirstWeek = firstThursday.subtract(Duration(days: firstThursday.weekday - 1));
    return ((thursday.difference(startOfFirstWeek).inDays) ~/ 7) + 1;
  }

  @override
  Widget build(BuildContext context) {
    final weeklyData = widget.rutina['weeklyData'] as List<List<bool>>;
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final currentWeekNumber = getIsoWeekNumber(now);

    return GestureDetector(
      onTap: _animateTap,
      child: AnimatedScale(
        scale: _scale,
        duration: Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: grisCarbon,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(weeklyData.length, (index) {
                final weekStartDate = startOfYear.add(Duration(days: index * 7));
                final weekNumber = getIsoWeekNumber(weekStartDate);
                final isCurrentWeek = weekNumber == currentWeekNumber;

                return Container(
                  margin: const EdgeInsets.only(right: 12.0),
                  child: Column(
                    children: [
                      Text(
                        'W$weekNumber',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isCurrentWeek ? rojoBurdeos : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...weeklyData[index].map((completed) {
                        return Container(
                          width: 14,
                          height: 14,
                          margin: const EdgeInsets.symmetric(vertical: 2.0),
                          decoration: BoxDecoration(
                            color: completed ? rojoBurdeos : grisClaro,
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}