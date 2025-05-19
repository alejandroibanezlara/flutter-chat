import 'package:flutter/material.dart';
import 'package:chat/pages/main_menu/rutinas/objetivos/objetivo_page.dart';
import 'package:chat/pages/shared/colores.dart';


class ObjectivesListPage extends StatefulWidget {
  const ObjectivesListPage({Key? key}) : super(key: key);

  @override
  _ObjectivesListPageState createState() => _ObjectivesListPageState();
}

class _ObjectivesListPageState extends State<ObjectivesListPage> {
  final Map<String, List<ObjectiveCardWidget>> _objectivesByPeriod = {
    'Objetivos a 1 Año': [],
    'Objetivos a 3 Años': [],
    'Objetivos a 5 Años': [],
  };

  @override
  void initState() {
    super.initState();

    // Añadimos el objetivo que mencionabas
    _objectivesByPeriod['Objetivos a 1 Año']!.add(
      ObjectiveCardWidget(
        objectiveName: 'Objetivo1',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        reason: 'Porque quiero vivir mi vida',
        milestones: [
          Milestone(description: 'hola1', date: DateTime.now()),
          Milestone(description: 'hola2', date: DateTime.now()),
          Milestone(description: 'hola3', date: DateTime.now()),
          Milestone(description: 'hola4', date: DateTime.now()),
          Milestone(description: 'hola5', date: DateTime.now()),
          Milestone(description: 'hola6', date: DateTime.now()),
        ],
      ),
    );
  }

  void _navigateToAddObjective() {
    Navigator.pushNamed(context, 'firstgoal');
  }

  Widget _buildSection(String title, Color color) {
    final objectives = _objectivesByPeriod[title]!;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera con título y botón de añadir
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: _navigateToAddObjective,
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white),

          // Contenido dinámico: mensaje o tarjetas
          if (objectives.isEmpty)
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                'No hay objetivos. Presiona el botón + para agregar. Recuerda, 2 objetivos máximo por temporada.',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            )
          else
            ...objectives,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSection('Objetivos a 1 Año', grisClaro),
            _buildSection('Objetivos a 3 Años', grisClaro),
            _buildSection('Objetivos a 5 Años', grisClaro),

            
            // _buildSection('Objetivos Cumplidos', grisClaro),
          ],
        ),
      ),
    );
  }
}