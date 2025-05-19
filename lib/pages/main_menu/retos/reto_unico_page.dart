import 'package:chat/pages/shared/colores.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RetoUnicoPage extends StatelessWidget {
  const RetoUnicoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Valor de ejemplo para el indicador de progreso en el AppBar.
    final currentStep = 1;
    return Scaffold(
      backgroundColor: negroAbsoluto,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        // Flecha para regresar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: blancoSuave),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        // Indicador de pasos (se muestran 3 barras; se pinta de blanco hasta el paso actual)
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 40,
              height: 1,
              color: (index <= currentStep) ? Colors.white : Colors.grey[800],
            );
          }),
        ),
        // Botón "X" a la derecha para volver al inicio
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: blancoSuave),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // Se usa una columna para distribuir el título y el botón "HECHO"
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Título de la pantalla
                const Text(
                  'completa este reto',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: blancoSuave,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                // Botón "HECHO" que navega a 'reto_fin'
                ElevatedButton(
                  onPressed: () {
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
                    'HECHO',
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