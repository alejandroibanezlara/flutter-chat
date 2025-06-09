
// import 'package:chat/pages/main_menu/inicio/learning_today_page.dart';
// import 'package:chat/pages/main_menu/inicio/reto_card_page.dart';
// import 'package:chat/pages/main_menu/inicio/retos_actuales_page.dart';
// import 'package:chat/pages/main_menu/inicio/retos_carrusel.dart';
// import 'package:chat/pages/main_menu/inicio/seguimiento_rutinas_page.dart';
// import 'package:chat/pages/main_menu/inicio/task_list_page.dart';
// import 'package:chat/pages/main_menu/inicio/time_progress_bar_page.dart';
// import 'package:chat/pages/shared/appbar_page.dart';
// import 'package:flutter/material.dart';


// class InicioPage extends StatelessWidget {


//   const InicioPage({super.key});

//   @override
//   Widget _buildContentContainer(String text, Color color) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//       padding: const EdgeInsets.all(20.0),
//       height: 150,
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: Center(
//         child: Text(
//           text,
//           style: const TextStyle(fontSize: 20.0, color: Colors.white),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final PageController controller = PageController(viewportFraction: 0.9);
//     return Scaffold(

//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[

//             TimeProgressBar(),

//             //BOTON FIN JORNADA 2 horas antes y 2 horas despues de Fin Jornada

            
//             RetosActualesPage(),
//             TaskListWidget(),
            
//             SemanaRutinasWidget(),

//             SizedBox(height: 10,),

//             Text(
//               'Retos extra diarios',
//               // Se utiliza el estilo headline6 del Theme y se personaliza para resaltar el título de la sección
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.start,
//             ),
            
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//               child: Divider(
//                 thickness: 1,           // Grosor de la línea
//                 color: Colors.white,     // Color de la línea
//                 indent: 0,             // Espacio a la izquierda (opcional)
//                 endIndent: 0,          // Espacio a la derecha (opcional)
//               ),
//             ),

//             RetosCarrusel(timeperiod: "daily"),
            
//             SizedBox(height: 10,),



//             Text(
//               'Retos semanales',
//               // Se utiliza el estilo headline6 del Theme y se personaliza para resaltar el título de la sección
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.start,
//             ),

//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//               child: Divider(
//                 thickness: 1,           // Grosor de la línea
//                 color: Colors.white,     // Color de la línea
//                 indent: 0,             // Espacio a la izquierda (opcional)
//                 endIndent: 0,          // Espacio a la derecha (opcional)
//               ),
//             ),

//             RetosCarrusel(timeperiod: "weekly"),

//             SizedBox(height: 10,),

//             Text(
//               'Retos mensuales',
//               // Se utiliza el estilo headline6 del Theme y se personaliza para resaltar el título de la sección
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.start,
//             ),

//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//               child: Divider(
//                 thickness: 1,           // Grosor de la línea
//                 color: Colors.white,     // Color de la línea
//                 indent: 0,             // Espacio a la izquierda (opcional)
//                 endIndent: 0,          // Espacio a la derecha (opcional)
//               ),
//             ),

//             RetosCarrusel(timeperiod: "monthly"),

//             SizedBox(height: 10,),

//             Text(
//               'MicroLearning Diario',
//               // Se utiliza el estilo headline6 del Theme y se personaliza para resaltar el título de la sección
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.start,
//             ),

//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//               child: Divider(
//                 thickness: 1,           // Grosor de la línea
//                 color: Colors.white,     // Color de la línea
//                 indent: 0,             // Espacio a la izquierda (opcional)
//                 endIndent: 0,          // Espacio a la derecha (opcional)
//               ),
//             ),

//             LearningTodayPage(),

//             //BOTON FIN JORNADA durante el resto del dia


//           ],
//         ),
//       ),
//     );
//   }
// }










// /// HomePage: Pantalla principal con botón para acceder al módulo Focus
// class FocusScope extends StatelessWidget {
//   const FocusScope({Key? key}) : super(key: key);
 
//   @override
//   Widget build(BuildContext context) {
//     return  Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.pushNamed(context, 'focus');
//           },
//           child: const Text('Focus Module'),
//         )
//     );
//   }
// }

// class BotonFinJornada extends StatelessWidget {
//   const BotonFinJornada({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return  ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFFDC143C),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.pushNamed(context, 'cuestionario_final_1');
//               },
//               child: const Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.question_answer, color: Colors.white),
//                   SizedBox(width: 8),
//                   Text("Cuestionario", style: TextStyle(color: Colors.white)),
//                 ],
//               ),
//             );
//   }
// }


import 'package:chat/pages/main_menu/inicio/learning_today_page.dart';
import 'package:chat/pages/main_menu/inicio/retos_actuales_page.dart';
import 'package:chat/pages/main_menu/inicio/retos_carrusel.dart';
import 'package:chat/pages/main_menu/inicio/seguimiento_rutinas_page.dart';
import 'package:chat/pages/main_menu/inicio/task_list_page.dart';
import 'package:chat/pages/main_menu/inicio/time_progress_bar_page.dart';
import 'package:chat/pages/shared/appbar_page.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/personalData/personalData_service.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({Key? key}) : super(key: key);

  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  DateTime? _finJornada;
  bool _loaded = false;
  bool _needsFinal = false;

  @override
  void initState() {
    super.initState();
    _loadPersonalData();
  }

  Future<void> _loadPersonalData() async {
    final userId = Provider.of<AuthService>(context, listen: false).usuario!.uid;
    final pd = await Provider.of<PersonalDataService>(context, listen: false)
        .getPersonalDataByUserId(userId);

    final today = DateTime.now();
    final hasTodayFinal = pd.actitudFinal.any((r) =>
      r.fecha.year  == today.year &&
      r.fecha.month == today.month &&
      r.fecha.day   == today.day
    );
    setState(() {
      _finJornada = pd.finJornada;
      _needsFinal    = !hasTodayFinal;
      _loaded = true;
    });
  }

  bool get _showInline {
    final now = DateTime.now();
    DateTime base;
    if (_finJornada != null) {
      base = DateTime(now.year, now.month, now.day, _finJornada!.hour, _finJornada!.minute);
    } else {
      base = DateTime(now.year, now.month, now.day, 0, 0);
    }
    final startWindow = base.subtract(const Duration(hours: 2));
    final endWindow = base.add(const Duration(hours: 2));
    return now.isAfter(startWindow) && now.isBefore(endWindow);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TimeProgressBar(),
            if (_showInline)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: BotonFinJornada(needsFinal: _needsFinal),
              ),
            RetosActualesPage(),
            TaskListWidget(),
            SemanaRutinasWidget(),
            const SizedBox(height: 10),
            _sectionTitle('Retos extra diarios'),
            const RetosCarrusel(timeperiod: 'daily'),
            const SizedBox(height: 10),
            _sectionTitle('Retos semanales'),
            const RetosCarrusel(timeperiod: 'weekly'),
            const SizedBox(height: 10),
            _sectionTitle('Retos mensuales'),
            const RetosCarrusel(timeperiod: 'monthly'),
            const SizedBox(height: 10),
            _sectionTitle('MicroLearning Diario'),
            LearningTodayPage(),
            const SizedBox(height: 20),
            if (!_showInline)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BotonFinJornada(needsFinal: _needsFinal),
              ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Divider(thickness: 1, color: Colors.white),
          ],
        ),
      );
}

class BotonFinJornada extends StatelessWidget {
  final bool needsFinal;
  const BotonFinJornada({Key? key, required this.needsFinal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Color rojo si falta actitudFinal hoy, gris si ya se finalizó el día
    final backgroundColor = needsFinal
      ? rojoBurdeos
      : Colors.grey;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      // Activo solo si falta finalización
      onPressed: needsFinal
        ? () => Navigator.pushNamed(context, 'cuestionario_final_1')
        : null,
      // Texto dinámico según estado
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wb_twilight, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            needsFinal ? 'Finalizar día' : 'Día finalizado',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
