import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/objectives/objectives_service.dart';
import 'package:chat/models/objective.dart';
import 'package:chat/pages/main_menu/rutinas/objetivos/objective_detail_page.dart';
import 'package:chat/pages/main_menu/rutinas/objetivos/goal_page.dart';
import 'package:chat/pages/shared/colores.dart';

/// Página que lista los objetivos agrupados por tipo (1, 3 y 5 años), con secciones y botón +
class ObjectivesListPage extends StatelessWidget {
  const ObjectivesListPage({Key? key}) : super(key: key);

  void _navigateToAddObjective(BuildContext context, int tipo) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => NameGoalScreen(tipo: tipo)),
    );
  }

  Widget _buildSection(BuildContext context, String title, Color color, int tipo, List<ObjetivoPersonal> list) {
    final section = list.where((o) => o.tipo == tipo).toList();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header fila con título y botón +
          Row(
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
              if (section.length < 3)
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: color),
                onPressed: () => _navigateToAddObjective(context, tipo),
              ),
            ],
          ),
          const Divider(color: Colors.white),
          if (section.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No hay objetivos de $title.',
                style: TextStyle(color: Colors.white70),
              ),
            )
          else
            ...section.map((obj) => _buildCard(context, obj)).toList(),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, ObjetivoPersonal obj) {
    final dateFormat = DateFormat('dd MMM yyyy');
    return Card(
      color: grisClaro,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ObjectiveDetailPage(objective: obj),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                obj.titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.play_arrow, size: 16, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(obj.fechaCreacion),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const Spacer(),
                  const Icon(Icons.flag, size: 16, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(obj.fechaObjetivo),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Beneficio: ${obj.beneficios ?? 'No especificado'}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final objectivesService = Provider.of<ObjectivesService>(context);
    final user = authService.usuario;

    if (user == null) {
      return SizedBox(
        height: 200,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    final uid = user.uid;

    return FutureBuilder<List<ObjetivoPersonal>>(
      future: objectivesService.getObjectivesByUser(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 200,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Error al cargar objetivos: ${snapshot.error}',
                style: const TextStyle(color: Colors.red)),
          );
        }
        final list = snapshot.data ?? [];
        return Column(
          children: [
            _buildSection(context, 'Objetivos a 1 Año', blancoSuave, 1, list),
            _buildSection(context, 'Objetivos a 3 Años', blancoSuave, 3, list),
            _buildSection(context, 'Objetivos a 5 Años', blancoSuave, 5, list),
          ],
        );
      },
    );
  }
}