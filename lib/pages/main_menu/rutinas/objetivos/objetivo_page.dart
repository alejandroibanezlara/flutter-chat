import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Modelo de datos para un hito
class Milestone {
  final String description;
  final DateTime date;
  bool completed;

  Milestone({
    required this.description,
    required this.date,
    this.completed = false,
  });
}

/// Widget que representa la estructura de un objetivo.
class ObjectiveCardWidget extends StatefulWidget {
  final String objectiveName;
  final DateTime startDate;
  final DateTime endDate;
  final String reason; // Por qué quieres conseguir el objetivo
  final List<Milestone> milestones;

  const ObjectiveCardWidget({
    Key? key,
    required this.objectiveName,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.milestones,
  }) : super(key: key);

  @override
  State<ObjectiveCardWidget> createState() => _ObjectiveCardWidgetState();
}

class _ObjectiveCardWidgetState extends State<ObjectiveCardWidget> {
  final DateFormat _formatter = DateFormat('yyyy-MM-dd');
  bool _expanded = false; // Controla si el contenedor está expandido o no

  /// Abre un diálogo para añadir un nuevo hito.
  Future<void> _showAddMilestoneDialog() async {
    TextEditingController descriptionController = TextEditingController();
    DateTime? selectedDate;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Añadir nuevo hito'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción del hito',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? 'Fecha: No definida'
                                : 'Fecha: ${_formatter.format(selectedDate!)}',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setStateDialog(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          child: const Text('Elegir'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (descriptionController.text.isNotEmpty && selectedDate != null) {
                  setState(() {
                    widget.milestones.add(
                      Milestone(
                        description: descriptionController.text,
                        date: selectedDate!,
                      ),
                    );
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        initiallyExpanded: _expanded,
        onExpansionChanged: (bool expanded) {
          setState(() {
            _expanded = expanded;
          });
        },
        // Encabezado del contenedor
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre del objetivo
            Text(
              widget.objectiveName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            // Fechas de inicio y fin con íconos
            Row(
              children: [
                const Icon(Icons.play_arrow, size: 16),
                const SizedBox(width: 4),
                Text(_formatter.format(widget.startDate)),
                const SizedBox(width: 16),
                const Icon(Icons.flag, size: 16),
                const SizedBox(width: 4),
                Text(_formatter.format(widget.endDate)),
              ],
            ),
          ],
        ),
        // Subtítulo (motivo) justo debajo de las fechas
        subtitle: Text(
          widget.reason,
          style: const TextStyle(color: Colors.grey),
        ),
        // Contenido que se muestra al expandir
        children: [
          if (widget.milestones.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No hay hitos.'),
            )
          else
            // Lista de hitos
            ...widget.milestones.map((milestone) {
              return ListTile(
                // Icono que se alterna entre un círculo sin check y un check al pulsarlo
                leading: IconButton(
                  icon: Icon(
                    milestone.completed
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                  ),
                  onPressed: () {
                    setState(() {
                      milestone.completed = !milestone.completed;
                    });
                  },
                ),
                title: Text(milestone.description),
                subtitle: Text('Fecha: ${_formatter.format(milestone.date)}'),
              );
            }).toList(),

          
          // Botón para añadir más hitos
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextButton.icon(
              onPressed: _showAddMilestoneDialog,
              icon: const Icon(Icons.add),
              label: const Text('Añadir hito'),
            ),
          ),
        ],
      ),
    );
  }
}