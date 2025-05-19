
import 'package:chat/pages/main_menu/inicio/reto_card_page.dart';
import 'package:chat/pages/main_menu/inicio/retos_actuales_page.dart';
import 'package:chat/pages/main_menu/inicio/retos_carrusel.dart';
import 'package:chat/pages/main_menu/inicio/seguimiento_rutinas_page.dart';
import 'package:chat/pages/main_menu/inicio/task_list_page.dart';
import 'package:chat/pages/main_menu/inicio/time_progress_bar_page.dart';
import 'package:chat/pages/shared/appbar_page.dart';
import 'package:flutter/material.dart';


class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget _buildContentContainer(String text, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      padding: const EdgeInsets.all(20.0),
      height: 150,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(viewportFraction: 0.9);
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'connect');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text('Jugar Connect The Dots'),
            ),
            SizedBox(height: 20),
            Text(
              'Conecta los puntos en orden y llena toda la cuadrícula',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),

            TimeProgressBar(),
            RetosActualesPage(),
            TaskListWidget(),
            
            SemanaRutinasWidget(),

            SizedBox(height: 10,),

            Text(
              'Retos extra diarios',
              // Se utiliza el estilo headline6 del Theme y se personaliza para resaltar el título de la sección
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.start,
            ),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Divider(
                thickness: 1,           // Grosor de la línea
                color: Colors.white,     // Color de la línea
                indent: 0,             // Espacio a la izquierda (opcional)
                endIndent: 0,          // Espacio a la derecha (opcional)
              ),
            ),

            RetosCarrusel(),
            
            SizedBox(height: 10,),



            Text(
              'Retos semanales',
              // Se utiliza el estilo headline6 del Theme y se personaliza para resaltar el título de la sección
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.start,
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Divider(
                thickness: 1,           // Grosor de la línea
                color: Colors.white,     // Color de la línea
                indent: 0,             // Espacio a la izquierda (opcional)
                endIndent: 0,          // Espacio a la derecha (opcional)
              ),
            ),

            RetosCarrusel(),

            SizedBox(height: 10,),

            Text(
              'Retos mensuales',
              // Se utiliza el estilo headline6 del Theme y se personaliza para resaltar el título de la sección
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.start,
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Divider(
                thickness: 1,           // Grosor de la línea
                color: Colors.white,     // Color de la línea
                indent: 0,             // Espacio a la izquierda (opcional)
                endIndent: 0,          // Espacio a la derecha (opcional)
              ),
            ),

            RetosCarrusel(),
            // ColorPaletteWidget(),
            //Extra diario Solo aparece si completar el reto diario
            // ProgressOverview(),
            FocusScope()

          ],
        ),
      ),
    );
  }
}










/// HomePage: Pantalla principal con botón para acceder al módulo Focus
class FocusScope extends StatelessWidget {
  const FocusScope({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return  Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, 'focus');
          },
          child: const Text('Focus Module'),
        )
    );
  }
}




