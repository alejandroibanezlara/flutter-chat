import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> with TickerProviderStateMixin {
  // Mes que se muestra actualmente (inicialmente el mes actual).
  DateTime displayedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  /// Navega al mes anterior.
  void goToPreviousMonth() {
    setState(() {
      displayedMonth = DateTime(displayedMonth.year, displayedMonth.month - 1);
    });
  }

  /// Navega al mes siguiente.
  void goToNextMonth() {
    setState(() {
      displayedMonth = DateTime(displayedMonth.year, displayedMonth.month + 1);
    });
  }

  /// Retorna el número de días del mes indicado.
  int getDaysInMonth(DateTime month) {
    final nextMonth = (month.month < 12)
        ? DateTime(month.year, month.month + 1, 1)
        : DateTime(month.year + 1, 1, 1);
    return nextMonth.subtract(const Duration(days: 1)).day;
  }

  /// Retorna el número de celdas vacías que se deben agregar
  /// para que el día 1 se ubique en lunes.
  /// En este caso, Monday es 1 y Sunday es 7, y queremos iniciar en lunes,
  /// por lo tanto, se restan 1.
  int getStartingBlanks(DateTime month) {
    return DateTime(month.year, month.month, 1).weekday - 1;
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = getDaysInMonth(displayedMonth);
    int startingBlanks = getStartingBlanks(displayedMonth);

    List<Widget> dayWidgets = [];

    // Se crean celdas vacías para alinear el primer día en la columna de lunes.
    for (int i = 0; i < startingBlanks; i++) {
      dayWidgets.add(Container());
    }

    // Se generan las celdas para cada día.
    for (int day = 1; day <= daysInMonth; day++) {
      dayWidgets.add(
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Día $day'),
                  content: const Text(
                    'Reto 1 superado\nReto 2 superado\nReto 3 no superado\nMindset Leidos',
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            child: Text(
              day.toString(),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Encabezado con botones para navegar entre meses.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: goToPreviousMonth,
                icon: const Icon(Icons.arrow_left),
              ),
              Text(
                DateFormat.yMMMM().format(displayedMonth),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: goToNextMonth,
                icon: const Icon(Icons.arrow_right),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Encabezado de los días de la semana (de lunes a domingo).
          Row(
            children: const [
              Expanded(child: Center(child: Text('Lun'))),
              Expanded(child: Center(child: Text('Mar'))),
              Expanded(child: Center(child: Text('Mié'))),
              Expanded(child: Center(child: Text('Jue'))),
              Expanded(child: Center(child: Text('Vie'))),
              Expanded(child: Center(child: Text('Sáb'))),
              Expanded(child: Center(child: Text('Dom'))),
            ],
          ),
          const SizedBox(height: 8),
          // Calendario en grid con 7 columnas.
          GridView.count(
            crossAxisCount: 7,
            childAspectRatio: 1, // Para que cada celda sea cuadrada.
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: dayWidgets,
          ),
        ],
      ),
    );
  }
}