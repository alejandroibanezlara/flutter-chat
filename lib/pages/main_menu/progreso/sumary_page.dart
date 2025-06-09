import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:chat/pages/shared/colores.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/personalData/metaData_User_service.dart';
import 'package:chat/models/metaData_User.dart';
import 'dart:math' as math;

class VerticalBarChartExample extends StatelessWidget {
  const VerticalBarChartExample({Key? key}) : super(key: key);

  static const List<String> areas = [
    'Empatía y Solidaridad',
    'Carisma',
    'Disciplina',
    'Organización',
    'Adaptabilidad',
    'Imagen pulida',
    'Visión estratégica',
    'Educación financiera',
    'Actitud de superación',
    'Comunicación asertiva',
  ];

  static const List<IconData> areaIcons = [
    Icons.group,
    Icons.face,
    Icons.check,
    Icons.assignment,
    Icons.autorenew,
    Icons.image,
    Icons.visibility,
    Icons.money,
    Icons.trending_up,
    Icons.chat,
  ];

  static const Color rojoBurdeos = Color(0xFF800020);

  @override
  Widget build(BuildContext context) {
    final authSvc = Provider.of<AuthService>(context, listen: false);
    final metaSvc = Provider.of<MetaDataUserService>(context, listen: false);
    final uid     = authSvc.usuario!.uid;

    return FutureBuilder<MetaDataUser>(
      future: metaSvc.getStatsLight(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text('Error al cargar estadísticas'));
        }

        final meta = snapshot.data!;

        // Construir los arrays dinámicamente
        final List<int> retosCumplidos = [
          meta.retosEmpatiaYSolidaridad,
          meta.retosCarisma,
          meta.retosDisciplina,
          meta.retosOrganizacion,
          meta.retosAdaptabilidad,
          meta.retosImagenPulida,
          meta.retosVisionEstrategica,
          meta.retosEducacionFinanciera,
          meta.retosActitudDeSuperacion,
          meta.retosComunicacionAsertiva,
        ];

        final List<double> areaValues = [
          meta.puntosEmpatiaYSolidaridad.toDouble(),
          meta.puntosCarisma.toDouble(),
          meta.puntosDisciplina.toDouble(),
          meta.puntosOrganizacion.toDouble(),
          meta.puntosAdaptabilidad.toDouble(),
          meta.puntosImagenPulida.toDouble(),
          meta.puntosVisionEstrategica.toDouble(),
          meta.puntosEducacionFinanciera.toDouble(),
          meta.puntosActitudDeSuperacion.toDouble(),
          meta.puntosComunicacionAsertiva.toDouble(),
        ];



        // Determinar top3 para colorear
        final sorted = areaValues
            .asMap()
            .entries
            .toList()
              ..sort((a, b) => b.value.compareTo(a.value));
        final top3 = sorted.take(3).map((e) => e.key).toSet();

        final double sliderMax = areaValues.isEmpty
              ? 1.0
              : areaValues.reduce(math.max);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- GRÁFICO DE BARRAS ---
              SizedBox(
                height: 300,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: areaValues.reduce(math.max) + 2,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 1,
                          getTitlesWidget: (v, meta) {
                            final i = v.toInt();
                            if (i < 0 || i >= areas.length) return const SizedBox();
                            return SideTitleWidget(
                              meta: meta,
                              angle: 0,
                              child: Icon(areaIcons[i], size: 20, color: Colors.white70),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(areas.length, (i) {
                      final color = top3.contains(i) ? rojoBurdeos : Colors.white70;
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: areaValues[i],
                            width: 16,
                            borderRadius: BorderRadius.circular(4),
                            color: color,
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // --- TABLA RESPONSIVE ---
              LayoutBuilder(builder: (context, constraints) {
                return Table(
                  border: TableBorder.symmetric(
                    inside: BorderSide(color: Colors.grey.shade300),
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                  },
                  children: [
                    // Cabecera
                    TableRow(
                      decoration: BoxDecoration(color: grisCarbon),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Área', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Retos', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Puntos', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    // Filas
                    for (int i = 0; i < areas.length; i++)
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Icon(areaIcons[i], size: 16),
                                const SizedBox(width: 4),
                                Flexible(child: Text(areas[i], overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              retosCumplidos[i].toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              areaValues[i].toStringAsFixed(1),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              }),

              const SizedBox(height: 16),

              // --- SLIDERS (read-only) ---
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemCount: areas.length,
              //   itemBuilder: (context, i) {
              //     return Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 8.0),
              //       child: Row(
              //         children: [
              //           SizedBox(
              //             width: 180,
              //             child: Row(
              //               children: [
              //                 Icon(areaIcons[i], size: 20, color: Colors.grey),
              //                 const SizedBox(width: 4),
              //                 Expanded(
              //                   child: Text(
              //                     areas[i],
              //                     style: const TextStyle(fontSize: 14),
              //                     overflow: TextOverflow.ellipsis,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           Expanded(
              //             child: Slider(
              //               min: 0,
              //               max: sliderMax,
              //               divisions: 10,
              //               value: areaValues[i].clamp(0.0, sliderMax),
              //               activeColor: rojoBurdeos,
              //               inactiveColor: rojoBurdeos.withOpacity(0.3),
              //               label: areaValues[i].toStringAsFixed(1),
              //               onChanged: null, // read-only
              //             ),
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }
}
