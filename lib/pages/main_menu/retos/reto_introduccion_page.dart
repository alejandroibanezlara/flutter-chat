import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chat/pages/shared/colores.dart';

// // Definición de la paleta de colores
// const Color blancoSuave    = Color(0xFFF5F5F5);
// const Color grisClaro      = Color(0xFFB0B0B0);
// const Color grisCarbon     = Color(0xFF2C2C2E);
// const Color negroAbsoluto  = Color(0xFF000000);
// const Color rojoBurdeos    = Color(0xFFA4243B);
// const Color dorado         = Color(0xFFEDA52F);

class RetoIntroduccionPage extends StatelessWidget {
  const RetoIntroduccionPage({Key? key}) : super(key: key);

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
    final currentStep = 0;
    return Scaffold(
      backgroundColor: negroAbsoluto,
      // AppBar con flecha para regresar a la página anterior
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
                            FontAwesomeIcons.running,
                            size: 50,
                            color: grisCarbon,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Título del reto
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
                  // Imagen placeholder debajo de la fila superior

                  const SizedBox(height: 12),
                  // Nueva fila para iconos descriptivos debajo de la imagen
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
                  // Fila 2: Descripción del reto
                  Text(
                    "Boost your energy and get moving with 20 Squats today. Embrace the challenge to build strength and discipline.",
                    style: TextStyle(
                      fontSize: 16,
                      color: negroAbsoluto,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Fila 3: Botones de acción: Aceptar y Rechazar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Acción para aceptar el reto
                          Navigator.pushNamed(context, 'reto_texto');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: negroAbsoluto,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Aceptar el reto',
                          style: TextStyle(
                            fontSize: 16,
                            color: blancoSuave,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'home');
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: negroAbsoluto, width: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Recházalo',
                          style: TextStyle(
                            fontSize: 16,
                            color: negroAbsoluto,
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
