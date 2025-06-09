import 'package:chat/pages/shared/colores.dart';
import 'package:flutter/material.dart';

/// ToolsPage
/// ---------
/// Muestra herramientas desbloqueadas en una lista horizontal con icono, título y navegación por rutas.
class ToolsPage extends StatelessWidget {
  const ToolsPage({Key? key}) : super(key: key);

  // Datos de las herramientas: título, icono y ruta de navegación
  static const List<Map<String, Object>> _tools = [
    {
      'title': 'Focus',
      'icon': Icons.timer,
      'route': 'focus',
    },
    {
      'title': 'Meditación',
      'icon': Icons.self_improvement,
      'route': 'meditation',
    },
    {
      'title': 'Respiración',
      'icon': Icons.air,
      'route': 'breathing',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado con título y botón de búsqueda
        Row(
          children: [
            const Text(
              'Herramientas desbloqueadas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                // Lógica de búsqueda
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        const Divider(color: Colors.grey),
        // Lista horizontal de herramientas con navegación por nombre de ruta
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: _tools.length,
            itemBuilder: (context, index) {
              final tool = _tools[index];
              final routeName = tool['route'] as String;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(routeName);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: blancoSuave,
                        child: Icon(
                          tool['icon'] as IconData,
                          size: 30,
                          color: rojoBurdeos,
                        ),
                      ),
                      // const SizedBox(height: 8),
                      // Text(
                      //   tool['title'] as String,
                      //   style: const TextStyle(fontSize: 14),
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
