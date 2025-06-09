import 'package:chat/pages/shared/appbar_page.dart';
import 'package:chat/pages/main_menu/inicio_page.dart';
import 'package:chat/pages/main_menu/progress_page.dart';
import 'package:chat/pages/main_menu/rutinas_page.dart';
import 'package:chat/pages/main_menu/ser_invencible_page.dart';
import 'package:chat/pages/shared/cuestionarios/inicio_dia/cuestionario_inicio_dia_page_1.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;

  const HomePage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  
  late int _selectedIndex;
  bool _isLoadingPD = true;           // indica carga de PersonalData
  bool _needsFirstStart = false;       // si falta calidadSueno hoy

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
    _checkFirstStart();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _checkFirstStart() async {
    final userId = Provider.of<AuthService>(context, listen: false).usuario!.uid;
    final pd = await Provider.of<PersonalDataService>(context, listen: false)
                    .getPersonalDataByUserId(userId);
    final today = DateTime.now();
    final hasToday = pd.calidadSueno.any((r) =>
      r.fecha.year  == today.year &&
      r.fecha.month == today.month &&
      r.fecha.day   == today.day
    );
    setState(() {
      _needsFirstStart = !hasToday;
      _isLoadingPD    = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoadingPD) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_needsFirstStart) {
      return const FirstStartDayPage();
    }
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
              icon: ImageIcon(
                AssetImage('assets/icons/little_phoenix.png'),
                size: 24, // Ajusta al mismo tamaño que tenías antes
              ),
              label: 'Ser invencible',
            ),
          ],
        ),
      ),
    );
  }
}