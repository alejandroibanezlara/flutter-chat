// retos_carrusel.dart
import 'package:chat/pages/main_menu/inicio/reto_card_page.dart';
import 'package:chat/services/challenges/challenge_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/models/challenge.dart';

class RetosCarrusel extends StatefulWidget {
  final String timeperiod;
  const RetosCarrusel({Key? key, required this.timeperiod}) : super(key: key);

  @override
  _RetosCarruselState createState() => _RetosCarruselState();
}

class _RetosCarruselState extends State<RetosCarrusel> {
  late final PageController _pageController;
  late Future<List<Challenge>> _futureRetos;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9)
      ..addListener(() {
        final idx = _pageController.page!.round();
        if (idx != _currentPage) {
          setState(() => _currentPage = idx);
        }
      });

    // Cargamos los retos filtrados por timePeriod
    final svc = Provider.of<ChallengeService>(context, listen: false);
    _futureRetos = svc.getByTimePeriod(widget.timeperiod);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Helper sencillo para mapear cadenas a IconData
  IconData _iconFromString(String? name) {
    switch (name) {
      case 'check_circle': return Icons.check_circle;
      case 'star':         return Icons.star;
      case 'flag':         return Icons.flag;
      default:             return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.9;

    return SizedBox(
      height: 260,
      child: FutureBuilder<List<Challenge>>(
        future: _futureRetos,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final retos = snap.data!;
          if (retos.isEmpty) {
            return const Center(child: Text('No hay retos para este período'));
          }

          return PageView.builder(
            controller: _pageController,
            itemCount: retos.length,
            itemBuilder: (context, i) {
              final reto = retos[i];
              final isActive = i == _currentPage;
              final height = isActive ? 260.0 : 240.0;

              // Ejemplo: si tienes áreasSerInvencible y quieres iconos extra,
              // aquí mapeamos a Icons.check_circle como placeholder.
              final extraIcons = reto.areasSerInvencible
                  ?.map((a) => _iconFromString(a.icono))
                  .toList() ?? [];

              return Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: height,
                  width: cardWidth,
                  child: RetoCard(
                    compact: true,
                    titulo: reto.title,
                    descripcion: reto.shortText,
                    iconData: _iconFromString(reto.icon),
                    iconos: extraIcons,
                    reto: reto,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}