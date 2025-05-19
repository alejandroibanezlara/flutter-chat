import 'package:chat/pages/shared/colores.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RetoContadorPage extends StatefulWidget {
  const RetoContadorPage({Key? key}) : super(key: key);

  @override
  _RetoContadorPageState createState() => _RetoContadorPageState();
}

class _RetoContadorPageState extends State<RetoContadorPage> {
  int count = 0;

  void incrementCount() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = 1;
    return Scaffold(
      backgroundColor: negroAbsoluto,
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
          children: List.generate(3, (index) {
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
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // Centra verticalmente el contenido
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pregunta principal
                const Text(
                  '¿Cuántas veces has hecho esto hoy?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: blancoSuave,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                // Número central que muestra el contador
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 100,
                    color: rojoBurdeos,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                // Botón circular para incrementar el contador
                ElevatedButton(
                  onPressed: incrementCount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: negroAbsoluto,
                    padding: const EdgeInsets.all(20),
                    shape: const CircleBorder(),
                    side: const BorderSide(color: blancoSuave, width: 2),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: blancoSuave,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 40),
                // Botón para finalizar el reto por hoy
                ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, 'reto_fin');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rojoBurdeos,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Finalizar por hoy',
                    style: TextStyle(
                      fontSize: 18,
                      color: blancoSuave,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
