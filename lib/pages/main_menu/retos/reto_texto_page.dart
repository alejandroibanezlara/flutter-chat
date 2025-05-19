import 'package:chat/pages/shared/colores.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RetoTextoPage extends StatefulWidget {
  const RetoTextoPage({Key? key}) : super(key: key);

  @override
  _RetoTextoPageState createState() => _RetoTextoPageState();
}

class _RetoTextoPageState extends State<RetoTextoPage> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Método auxiliar para construir cada icono descriptivo
  Widget buildIcono(String label, IconData icono) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: grisCarbon.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icono,
              size: 24,
              color: grisCarbon,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: negroAbsoluto,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = 1;
    return Scaffold(
      backgroundColor: negroAbsoluto,
      // AppBar con flecha atrás, indicador de pasos y botón "X"
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: blancoSuave),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 40,
              height: 1,
              color: (index <= currentStep)
                  ? Colors.white
                  : Colors.grey[800],
            );
          }),
        ),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // Tarjeta principal con estilo similar a RetoCard
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: grisClaro,
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
                  // Fila 1: Icono representativo y título del reto
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: grisCarbon.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.penFancy,
                            size: 50,
                            color: grisCarbon,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Challenge of the Day",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: negroAbsoluto,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Fila de iconos descriptivos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildIcono("Track", FontAwesomeIcons.chartLine),
                      buildIcono("Focus", FontAwesomeIcons.search),
                      buildIcono("Energy", FontAwesomeIcons.bolt),
                      buildIcono("Wellbeing", FontAwesomeIcons.heart),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Descripción del reto
                  Text(
                    "Escribe un texto que describa cómo te sientes hoy y los logros que has alcanzado. Comparte tu experiencia para inspirar a otros.",
                    style: TextStyle(
                      fontSize: 16,
                      color: negroAbsoluto,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Campo de texto para introducir la respuesta
                  TextField(
                    controller: _textController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Introduce tu respuesta aquí...",
                      filled: true,
                      fillColor: blancoSuave,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Botones de acción: Aceptar y Rechazar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}