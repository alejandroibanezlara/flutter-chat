// third_start_day_page.dart
import 'package:chat/pages/shared/colores.dart';
import 'package:flutter/material.dart';

class ThirdStartDayPage extends StatefulWidget {
  const ThirdStartDayPage({Key? key}) : super(key: key);

  @override
  State<ThirdStartDayPage> createState() => _ThirdStartDayPageState();
}

class _ThirdStartDayPageState extends State<ThirdStartDayPage> {
  int? selectedMantra;

  final List<String> mantras = [
    'Soy capaz de superar cualquier obstáculo',
    'Cada día es una nueva oportunidad',
    'Confío en mi potencial y en mis habilidades',
    'Hoy elijo la positividad y el crecimiento',
    'Mi mente es fuerte y mi corazón valiente',
  ];

  @override
  Widget build(BuildContext context) {
    final currentStep = 2;

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
          children: [
            ...List.generate(mantras.length, (index) {
return Card(
  // ─── fondo cambia según selección ───
  color: (selectedMantra == index) ? rojoBurdeos : Colors.grey[900],

  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  child: RadioListTile<int>(
    value: index,
    groupValue: selectedMantra,
    // color del punto interior
    activeColor: Colors.white,
    // evita que RadioListTile pinte su propio fondo
    selectedTileColor: Colors.transparent,

    title: Text(
      mantras[index],
      style: const TextStyle(color: Colors.white),
    ),

    onChanged: (value) => setState(() => selectedMantra = value),
  ),
);
            }),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: (selectedMantra != null)
                    ? () {
                        Navigator.pushNamed(context, 'cuestionario_inicial_4');
                      }
                    : null,
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