import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatos de fecha

class TutorialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tutorial Invencible'),
          bottom: TabBar(
            tabs: [Text('Diarios'), Text('Semanales'), Text('Mensuales')],
          ),
        ),
        body: TabBarView(
          children: [
            DailyChallengesPage(),
            WeeklyChallengesPage(),
            MonthlyChallengesPage(),
          ],
        ),
      ),
    );
  }
}

// Reutilizamos las tres páginas definidas anteriormente:
class DailyChallengesPage extends StatelessWidget {
  final List<String> skills = [
    'Empatía y Solidaridad', 'Carisma', 'Disciplina',
    'Organización', 'Adaptabilidad', 'Imagen Pulida',
    'Visión Estratégica', 'Educación Financiera',
    'Actitud de Superación', 'Comunicación Asertiva',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: skills.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(skills[index]),
            subtitle: Text('Completa una tarea pequeña relacionada'),
            trailing: Checkbox(value: false, onChanged: (_) {}),
          ),
        );
      },
    );
  }
}

class WeeklyChallengesPage extends StatefulWidget {
  @override
  _WeeklyChallengesPageState createState() => _WeeklyChallengesPageState();
}

class _WeeklyChallengesPageState extends State<WeeklyChallengesPage> {
  late Map<String, bool> completed;

  @override
  void initState() {
    super.initState();
    completed = { for (var s in DailyChallengesPage().skills) s: false };
  }

  @override
  Widget build(BuildContext context) {
    final weekNumber = int.parse(DateFormat('w').format(DateTime.now()));
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Text('Semana del año: \$weekNumber', style: TextStyle(fontSize: 18)),
        ),
        Expanded(
          child: ListView(
            children: completed.keys.map((skill) {
              return CheckboxListTile(
                title: Text(skill),
                value: completed[skill],
                onChanged: (val) => setState(() => completed[skill] = val!),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class MonthlyChallengesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final monthLabel = DateFormat('MMMM yyyy').format(DateTime.now());
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mes: \$monthLabel', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Text('Define un proyecto ambicioso que mejore múltiples habilidades.'),
          Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Navegar a la gráfica de progreso mensual
              },
              child: Text('Ver Progreso Mensual'),
            ),
          ),
        ],
      ),
    );
  }
}