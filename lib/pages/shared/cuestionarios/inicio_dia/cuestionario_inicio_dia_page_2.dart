// second_start_day_page.dart
import 'package:chat/pages/shared/colores.dart';
import 'package:flutter/material.dart';

class SecondStartDayPage extends StatelessWidget {
  const SecondStartDayPage({Key? key}) : super(key: key);

  // En este ejemplo se usan tareas simuladas.
  final List<Map<String, String>> tasks = const [
    {'task': 'Revisar correos', 'time': '08:00'},
    {'task': 'Planificar reuniones', 'time': '10:00'},
    {'task': 'Hacer llamadas', 'time': '14:00'},
    {'task': 'Enviar reportes', 'time': '16:00'},
  ];

  @override
  Widget build(BuildContext context) {
    final currentStep = 1;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        // Flecha a la izquierda (atras minimalista)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            // Acción para ir atrás
            Navigator.pop(context);
          },
        ),
        // 5 barras centrales para indicar el paso actual
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 40,
              height: 1,
              // Cambia 'currentStep' por la variable que controla en qué paso estás (0..4)
              color: (index <= currentStep) ? Colors.white : Colors.grey[800],
            );
          }),
        ),
        // Botón "X" a la derecha para volver al inicio
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              // Acción para volver al inicio
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...tasks.map((task) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                tileColor: Colors.grey[900],
                textColor: Colors.white,
                title: Text(task['task']!),
                subtitle: Text('Hora: ${task['time']}'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            )),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'cuestionario_inicial_3');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: rojoBurdeos,          // color de fondo
                  foregroundColor: Colors.white,         // color de texto e iconos
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(         // radio de 8 px
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Siguiente',
                  style: TextStyle(fontSize: 16),         // ya hereda color blanco
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}