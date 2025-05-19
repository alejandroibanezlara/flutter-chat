import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RadarChartExample extends StatefulWidget {
  const RadarChartExample({Key? key}) : super(key: key);

  @override
  _RadarChartExampleState createState() => _RadarChartExampleState();
}

class _RadarChartExampleState extends State<RadarChartExample> {
  // Lista de áreas
  final List<String> areas = [
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

  // Lista de íconos para cada área.
  final List<IconData> areaIcons = [
    Icons.group, // Empatía y Solidaridad
    Icons.face, // Carisma
    Icons.check, // Disciplina
    Icons.assignment, // Organización
    Icons.autorenew, // Adaptabilidad
    Icons.image, // Imagen pulida
    Icons.visibility, // Visión estratégica
    Icons.money, // Educación financiera
    Icons.trending_up, // Actitud de superación
    Icons.chat, // Comunicación asertiva
  ];

  // Valores iniciales (escala de 0 a 10)
  final List<double> areaValues = List.filled(10, 5.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // RadarChart con altura fija para mostrarlo adecuadamente.
          SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: RadarChart(
                RadarChartData(
                  dataSets: [
                    // Dataset dummy: fuerza el máximo a 10 en cada eje.
                    RadarDataSet(
                      dataEntries:
                          List.generate(areas.length, (index) => RadarEntry(value: 10)),
                      borderColor: Colors.transparent,
                      fillColor: Colors.transparent,
                      borderWidth: 0,
                      entryRadius: 0,
                    ),
                    // Otro dataset dummy para forzar la escala.
                    RadarDataSet(
                      dataEntries:
                          List.generate(areas.length, (index) => RadarEntry(value: 0)),
                      borderColor: Colors.transparent,
                      fillColor: Colors.transparent,
                      borderWidth: 0,
                      entryRadius: 0,
                    ),
                    // Dataset real con los valores actuales.
                    RadarDataSet(
                      dataEntries:
                          areaValues.map((value) => RadarEntry(value: value)).toList(),
                      borderColor: Color(0xFFDC143C),
                      fillColor: Color(0xFFDC143C).withValues(alpha: 0.3),
                      borderWidth: 1,
                      entryRadius: 2,
                    ),
                  ],
                  // Para los títulos se usan los íconos.
                  getTitle: (index, angle) {
                    final icon = areaIcons[index];
                    return RadarChartTitle(
                      text: String.fromCharCode(icon.codePoint),
                      angle: 0,
                    );
                  },
                  tickCount: 5,
                  tickBorderData: const BorderSide(color: Colors.grey),
                  ticksTextStyle: const TextStyle(color: Colors.transparent),
                  radarTouchData: RadarTouchData(
                    touchCallback: (FlTouchEvent event, response) {
                      // Lógica de toque si es necesario.
                    },
                  ),
                  radarBackgroundColor: Colors.transparent,
                  titlePositionPercentageOffset: 0.2,
                  titleTextStyle: const TextStyle(
                    fontSize: 24,
                    fontFamily: 'MaterialIcons',
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          // Lista de sliders para cada área.
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            itemCount: areas.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    // Ícono y nombre del área, con ancho fijo.
                    SizedBox(
                      width: 180,
                      child: Row(
                        children: [
                          Icon(areaIcons[index], size: 20),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              areas[index],
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Slider para ajustar el valor.
                    Expanded(
                      child: Slider(
                        min: 0,
                        max: 10,
                        divisions: 10,
                        value: areaValues[index],
                        label: '${areaValues[index].round()}',
                        onChanged: (double newValue) {
                          setState(() {
                            areaValues[index] = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}


