import 'package:flutter/material.dart';
import 'package:chat/pages/shared/colores.dart';

class RetosActualesPage extends StatelessWidget {
  const RetosActualesPage({Key? key}) : super(key: key);

  /// Widget auxiliar para construir cada mini tarjeta.
  /// Se utilizan bordes redondeados, sin sombras y con tipografía en negrita.
  Widget buildMiniCard({
    required String title,
    required String frequency,
    required Color backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: blancoSuave,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            frequency,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: blancoSuave,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: blancoSuave, // Fondo de la tarjeta: Blanco suave
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
          // Título general
          const Text(
            "Retos en curso",
            style: TextStyle(
              color: negroAbsoluto,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // Primera fila: Reto Mensual y Reto Semanal
          Row(
            children: [
              Expanded(
                child: buildMiniCard(
                  title: "Reto Mensual",
                  frequency: "1 mes",
                  backgroundColor: dorado,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: buildMiniCard(
                  title: "Reto Semanal",
                  frequency: "1 semana",
                  backgroundColor: grisCarbon,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Segunda fila: 3 mini tarjetas para retos diarios
          Row(
            children: [
              Expanded(
                child: buildMiniCard(
                  title: "Reto Diario 1",
                  frequency: "día",
                  backgroundColor: rojoBurdeos,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: buildMiniCard(
                  title: "Reto Diario 2",
                  frequency: "día",
                  backgroundColor: grisClaro,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: buildMiniCard(
                  title: "Reto Diario 3",
                  frequency: "día",
                  backgroundColor: grisClaro,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}