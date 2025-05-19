import 'package:chat/pages/shared/colores.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RetoChecklistPage extends StatefulWidget {
  const RetoChecklistPage({Key? key}) : super(key: key);

  @override
  _RetoChecklistPageState createState() => _RetoChecklistPageState();
}

class _RetoChecklistPageState extends State<RetoChecklistPage> {
  // Lista para almacenar el estado de cada checkbox (5 puntos)
  List<bool> checklistValues = [false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    // Variable para simular el paso actual en el AppBar (puedes ajustarla)
    final currentStep = 1;
    return Scaffold(
      backgroundColor: negroAbsoluto,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        // Flecha atrás (minimalista)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // Barra central con indicador de paso (3 barras en este ejemplo)
        centerTitle: true,
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
            icon: const Icon(Icons.close, color: Colors.white),
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
            // Se utiliza una Column para disponer el contenido
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pregunta principal
                const Text(
                  'Marca los siguientes puntos si los has cumplido hoy:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: blancoSuave,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                // Lista de CheckList de 5 puntos
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: checklistValues.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        value: checklistValues[index],
                        onChanged: (value) {
                          setState(() {
                            checklistValues[index] = value ?? false;
                          });
                        },
                        title: Text(
                          'Punto ${index + 1}', // Personaliza cada punto según convenga
                          style: const TextStyle(
                            fontSize: 18,
                            color: blancoSuave,
                          ),
                        ),
                        activeColor: rojoBurdeos,
                        checkColor: blancoSuave,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                // Botón para finalizar el reto por hoy
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