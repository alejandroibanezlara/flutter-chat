import 'package:chat/pages/shared/appbar_page.dart';
import 'package:chat/pages/main_menu/inicio_page.dart';
import 'package:chat/pages/main_menu/progress_page.dart';
import 'package:chat/pages/main_menu/rutinas_page.dart';
import 'package:chat/pages/main_menu/ser_invencible_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;

  const HomePage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;

  final List<Widget> _screens = const [
    InicioPage(),
    RutinasPage(),
    ProgressPage(),
    SerInvenciblePage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
          // margin: const EdgeInsets.symmetric(horizontal: 8.0),

        child: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(fontSize: 12, overflow: TextOverflow.visible),
          unselectedLabelStyle: const TextStyle(fontSize: 12, overflow: TextOverflow.visible),
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Color(0xFFDC143C),
          unselectedItemColor: Colors.grey,
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
        ),
      ),
    );
  }
}