import 'package:chat/pages/main_menu/inicio/reto_card_page.dart';
import 'package:flutter/material.dart';

/// Carrusel que ajusta su alto dinámicamente en función del contenido de la tarjeta actual.
/// Cada tarjeta se centra horizontalmente y su ancho se calcula en función del ancho de la pantalla.
class RetosCarrusel extends StatefulWidget {
  const RetosCarrusel({Key? key}) : super(key: key);

  @override
  _RetosCarruselState createState() => _RetosCarruselState();
}

class _RetosCarruselState extends State<RetosCarrusel> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Listener que actualiza el índice de la página activa.
    _pageController.addListener(() {
      final int currentIndex = _pageController.page!.round();
      if (currentIndex != _currentPage) {
        setState(() {
          _currentPage = currentIndex;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cálculo del ancho relativo para cada tarjeta.
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = screenWidth * 0.9;

    return Container(
      // Contenedor padre con altura fija para evitar errores de viewport sin límites.
      height: 260,
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        scrollDirection: Axis.horizontal,
        children: [
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              // La tarjeta seleccionada ocupa 250; las no seleccionadas 200.
              height: _currentPage == 0 ? 260 : 240,
              width: cardWidth,
              child: RetoCard(
                compact: true,
                descripcion: 'El mejor reto del mundo El mejor reto del mundo El mejor reto del mundo',
                iconData: Icons.check_circle,
                titulo: 'Primer reto',
                iconos: [Icons.check_circle, Icons.check_circle],
              ),
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _currentPage == 1 ? 260 : 240,
              width: cardWidth,
              child: RetoCard(
                compact: true,
                descripcion: 'Un reto increíble para superarte',
                iconData: Icons.star,
                titulo: 'Segundo reto',
                iconos: [Icons.star, Icons.star_border],
              ),
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _currentPage == 2 ? 260 : 240,
              width: cardWidth,
              child: RetoCard(
                compact: true,
                descripcion: 'Acepta el desafío y demuestra tu valía',
                iconData: Icons.flag,
                titulo: 'Tercer reto',
                iconos: [Icons.flag, Icons.flag],
              ),
            ),
          ),
        ],
      ),
    );
  }
}