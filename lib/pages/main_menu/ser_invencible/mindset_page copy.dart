import 'package:flutter/material.dart';

/// TenMantrasWidget
/// ----------------
/// Un widget impactante en Flutter para mostrar los 10 mantras de una persona.
/// - Animaciones de aparición con AnimationController.
/// - Diseño moderno con gradiente, sombras y tipografía destacada.
/// - Permite pasar tu propia lista de mantras o usar valores por defecto.
class MindsetPage extends StatefulWidget {
  /// Lista de mantras personalizada. Debe contener 10 elementos.
  final List<String>? mantras;

  const MindsetPage({Key? key, this.mantras}) : super(key: key);

  @override
  _MindsetPageState createState() => _MindsetPageState();
}

class _MindsetPageState extends State<MindsetPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<Offset>> _slideAnimations;
  late final List<Animation<double>> _fadeAnimations;
  late final List<String> _items;

  @override
  void initState() {
    super.initState();
    // Definir mantras por defecto si no se pasan
    _items = widget.mantras?.length == 10
        ? widget.mantras!
        : const [
            "Soy capaz de lograr todo lo que me proponga.",
            "Cada día es una nueva oportunidad para crecer.",
            "La persistencia vence a la resistencia.",
            "Me adapto y supero los desafíos.",
            "Mi mente está enfocada y clara.",
            "Atraigo energía positiva a mi vida.",
            "Aprendo de cada experiencia.",
            "Mi crecimiento es constante e imparable.",
            "Confío en mis habilidades y decisiones.",
            "Hoy es mi mejor día para triunfar."
          ];

    // Controlador de animaciones
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Crear animaciones escalonadas para cada mantra
    _slideAnimations = List.generate(_items.length, (index) {
      final start = index * 0.1;
      // Asegurar que 'end' no exceda 1.0 para evitar AssertionError
      final rawEnd = start + 0.5;
      final end = rawEnd > 1.0 ? 1.0 : rawEnd;
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _fadeAnimations = List.generate(_items.length, (index) {
      final start = index * 0.1;
      // Asegurar que 'end' no exceda 1.0
      final rawEnd = start + 0.5;
      final end = rawEnd > 1.0 ? 1.0 : rawEnd;
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeIn),
        ),
      );
    });

    // Iniciar animaciones
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mindset',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // Lógica para añadir usuario.
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),

            // Divider para separar el título del contenido
        const Divider(color: Colors.grey),

        Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFDC143C), Color.fromARGB(255, 237, 148, 148)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  ...List.generate(_items.length, (index) {
                    return SlideTransition(
                      position: _slideAnimations[index],
                      child: FadeTransition(
                        opacity: _fadeAnimations[index],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.bolt,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _items[index],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
