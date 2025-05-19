import 'package:flutter/material.dart';

class RowDiasWidget extends StatelessWidget {
  const RowDiasWidget({super.key});

  String _getAbbreviatedWeekday(DateTime date, DateTime today) {
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Hoy';
    }
    switch (date.weekday) {
      case DateTime.monday:
        return 'lun';
      case DateTime.tuesday:
        return 'mar';
      case DateTime.wednesday:
        return 'mié';
      case DateTime.thursday:
        return 'jue';
      case DateTime.friday:
        return 'vie';
      case DateTime.saturday:
        return 'sáb';
      case DateTime.sunday:
        return 'dom';
      default:
        return '';
    }
  }


  List<Map<String, dynamic>> _generateDays() {
    DateTime today = DateTime.now();
    return List.generate(7, (index) {
      DateTime day = today.subtract(Duration(days: 3 - index));
      return {
        'label': _getAbbreviatedWeekday(day, today),
        'dayNum': day.day.toString().padLeft(2, '0'),
        'isToday': day.year == today.year &&
            day.month == today.month &&
            day.day == today.day,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _days = _generateDays();
    return         Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _days.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final day = _days[index];
                final isToday = day['isToday'] as bool;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day['label'].toString(),
                      style: TextStyle(
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.normal,
                        color: isToday ? const Color(0xFFDC143C) : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: isToday ? const Color(0xFFDC143C) : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        day['dayNum'].toString(),
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
  }
}