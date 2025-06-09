import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:chat/services/objectives/objectives_service.dart';
import 'package:chat/models/objective.dart';

/// Widget que muestra de forma elegante los datos de un objetivo recuperado desde la base de datos.
class ObjectiveCardWidget extends StatelessWidget {
  /// Identificador del usuario para recuperar datos.
  final String userId;

  const ObjectiveCardWidget({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ObjectivesService>(context, listen: false);
    final dateFormat = DateFormat('dd MMM yyyy');

    return FutureBuilder<ObjetivoPersonal>(
      future: service.getObjectiveByUserId(userId),
      builder: (context, snapshot) {
        // Spinner dentro de un Card con altura fija para evitar tamaño infinito
        if (snapshot.connectionState != ConnectionState.done) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: SizedBox(
              height: 150,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        // Error dentro de un Card con padding
        if (snapshot.hasError || !snapshot.hasData) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'No se pudo cargar el objetivo.',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final obj = snapshot.data!;

        // Tarjeta de datos
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  obj.titulo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Fechas
                Row(
                  children: [
                    const Icon(Icons.play_arrow, size: 18),
                    const SizedBox(width: 4),
                    Text(dateFormat.format(obj.fechaCreacion)),
                    const Spacer(),
                    const Icon(Icons.flag, size: 18),
                    const SizedBox(width: 4),
                    Text(dateFormat.format(obj.fechaObjetivo)),
                  ],
                ),
                const SizedBox(height: 12),
                // Beneficio (en lugar de reason)
                Text(
                  'Beneficio:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  obj.beneficios ?? 'No especificado',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                // Áreas asociadas
                if (obj.areaSerInvencible.isNotEmpty) ...[
                  Text(
                    'Áreas:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: obj.areaSerInvencible.map((area) {
                      return Chip(
                        label: Text(area.titulo),
                        backgroundColor: Colors.blue.shade50,
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
