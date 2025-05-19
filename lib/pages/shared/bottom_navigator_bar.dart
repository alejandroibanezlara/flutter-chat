import 'package:flutter/material.dart';

class BottomNavigatorBarCustom extends StatefulWidget {
  
  const BottomNavigatorBarCustom({super.key});

  @override
  State<BottomNavigatorBarCustom> createState() => _BottomNavigatorBarCustomState();
}

class _BottomNavigatorBarCustomState extends State<BottomNavigatorBarCustom> {
  int _selectedIndex = 0;

    void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    // Ajusta estos valores relativos según tus necesidades.
    final iconSize = screenWidth * 0.06;
    final fontSize = screenWidth * 0.04;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: const Color(0xFFDC143C),
      unselectedItemColor: Colors.grey,
      iconSize: iconSize,
      selectedLabelStyle: TextStyle(fontSize: fontSize),
      unselectedLabelStyle: TextStyle(fontSize: fontSize),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.repeat),
          label: 'Rutinas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: 'Progreso',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Ser invencible',
        ),
      ],
    );
  }
}