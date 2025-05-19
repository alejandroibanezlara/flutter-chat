import 'package:chat/models/routine.dart';
import 'package:chat/pages/main_menu/rutinas/rutinas/crear_actualizar_rutina_page.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:chat/services/routine/routine_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



Widget buildRoutineCard({
  required BuildContext context,
  required Routine rutina,
  required String title,
  int? count,
  required IconData icon,
  required List<Area> areas,
  required VoidCallback onPlusPressed,
  required String tipo,
  required List<int> diasSemana,
  required List<int> diasMes,
  bool compact = false,
}) {
  final int safeCount = count ?? 0;

  IconData _getAreaIcon(String icono) {
    try {
      final intCode = int.tryParse(icono);
      if (intCode != null) {
        return IconData(intCode, fontFamily: 'MaterialIcons');
      }
    } catch (_) {}
    return Icons.star;
  }

  bool _isWeekday(List<int> dias) => dias.toSet().containsAll([1, 2, 3, 4, 5]) && dias.length == 5;
  // bool _isWeekend(List<int> dias) => dias.toSet().containsAll([6, 0]) && dias.length == 2;
  bool _isWeekend(List<int> dias) => dias.toSet().containsAll([6, 7]) && dias.length == 2;

  String _diaAbreviado(int dia) {
    switch (dia) {
      case 1:
        return 'L';
      case 2:
        return 'M';
      case 3:
        return 'X';
      case 4:
        return 'J';
      case 5:
        return 'V';
      case 6:
        return 'S';
      case 7:
        return 'D';
      default:
        return '?';
    }
  }

Widget _buildTipoEtiqueta() {
  switch (tipo) {
    case 'diaria':
      return Tooltip(
        message: 'Se repite todos los días',
        child: const Text('Daily', style: TextStyle(fontSize: 10, color: Colors.blueGrey)),
      );

    case 'semanal':
      if (_isWeekday(diasSemana)) {
        return Tooltip(
          message: 'De lunes a viernes',
          child: const Text('L, M, X, J, V', style: TextStyle(fontSize: 10, color: Colors.teal)),
        );
      } else if (_isWeekend(diasSemana)) {
        return Tooltip(
          message: 'Sábado y domingo',
          child: const Text('S y D', style: TextStyle(fontSize: 10, color: Colors.orange)),
        );
      } else {
        final diasOrdenados = diasSemana.toList()..sort();
        final diasTexto = diasOrdenados.map(_diaAbreviado).join(', ');
        return Tooltip(
          message: 'Días específicos: $diasTexto',
          child: Text(diasTexto, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        );
      }

    case 'mensual':
      final diasOrdenados = diasMes.toList()..sort();
      return Tooltip(
        message: 'Día(s) ${diasOrdenados.join(', ')} de cada mes',
        child: SizedBox(
          height: 20, // Altura fija para mantener consistencia
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(), // Para un scroll más ajustado
            children: diasOrdenados.map((d) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
                alignment: Alignment.center,
                child: Text(
                  d.toString(),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              );
            }).toList(),
          ),
        ),
      );

    case 'personalizada':
    default:
      return Tooltip(
        message: 'Rutina con días personalizados',
        child: const Icon(Icons.tune, size: 14, color: Colors.purple),
      );
  }
}

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
      ],
    ),
    child: ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Table(
        columnWidths: const {
          0: FixedColumnWidth(50),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(40),
        },
        children: [
          TableRow(
            children: [
              Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: grisClaro,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: rojoBurdeos, size: 20),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: compact ? 14 : 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.fill,
                child: Container(
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RepeatSettingsPage(
                            finalPhrase: rutina.declaracionCompleta,
                            routine: rutina,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: grisClaro,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, size: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  '$safeCount',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: areas
                        .map((area) => Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Icon(
                                _getAreaIcon(area.icono),
                                size: 16,
                                color: Colors.grey[700],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Center(child: _buildTipoEtiqueta()),
              ),
            ],
          ),
        ],
      ), // fin title: Table(...)

      // Aquí aparece el bloque desplegable con los próximos días:
      children: [
        FutureBuilder<List<DateTime>>(
          future: RoutineService().getNextDays(rutina.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No hay próximos días'),
              );
            }
            final dias = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: dias.map((dt) {
                  final txt = DateFormat('dd/MM').format(dt);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: grisCarbon,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(txt, style: const TextStyle(fontSize: 12)),
                  );
                }).toList(),
              ),
            );
          },
        )
      ],
    ), // fin Expansi
    
  );
}


// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:chat/models/routine.dart';
// import 'package:chat/services/routine/routine_service.dart';
// import 'package:chat/pages/main_menu/rutinas/rutinas/crear_actualizar_rutina_page.dart';

// class buildRoutineCard extends StatefulWidget {
//   final Routine rutina;
//   final VoidCallback onPlusPressed;

//   const buildRoutineCard({
//     Key? key,
//     required this.rutina,
//     required this.onPlusPressed,
//   }) : super(key: key);

//   @override
//   _buildRoutineCardState createState() => _buildRoutineCardState();
// }

// class _buildRoutineCardState extends State<buildRoutineCard> {
//   bool _expanded = false;
//   List<DateTime>? _nextDays;
//   final _svc = RoutineService();

//   Future<void> _toggleExpanded() async {
//     setState(() => _expanded = !_expanded);
//     if (_expanded && _nextDays == null) {
//       _nextDays = await _svc.getNextDays(widget.rutina.id);
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final r = widget.rutina;
//     final dias = r.proximosDias ?? _nextDays;

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: const [ BoxShadow(color: Colors.black12, blurRadius: 3) ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // — Cabecera —
//           Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: Colors.grey[200],
//                 child: Icon(
//                   r.icono != null
//                     ? IconData(r.icono!, fontFamily: 'MaterialIcons')
//                     : Icons.star,
//                   color: Colors.red,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: InkWell(
//                   onTap: _toggleExpanded,
//                   child: Text(
//                     r.declaracionCompleta,
//                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.add_circle_outline),
//                 onPressed: widget.onPlusPressed,
//               ),
//             ],
//           ),

//           const SizedBox(height: 8),
//           // — Áreas —
//           Wrap(
//             spacing: 4,
//             children: r.areas.map((a) {
//               return Icon(
//                 IconData(int.parse(a.icono), fontFamily: 'MaterialIcons'),
//                 size: 16,
//               );
//             }).toList(),
//           ),

//           const SizedBox(height: 8),
//           // — Próximos días (si está expandido) —
//           if (_expanded && dias != null) ...[
//             const Divider(),
//             Wrap(
//               spacing: 6,
//               runSpacing: 6,
//               children: dias.map((dt) {
//                 final txt = DateFormat('dd/MM').format(dt);
//                 return Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(txt, style: const TextStyle(fontSize: 12)),
//                 );
//               }).toList(),
//             )
//           ],
//         ],
//       ),
//     );
//   }
// }