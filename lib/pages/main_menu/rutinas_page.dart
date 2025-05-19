
import 'package:chat/pages/main_menu/rutinas/objetivos_list_page.dart';
import 'package:chat/pages/main_menu/rutinas/rutinas_list_page.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class RutinasPage extends StatefulWidget {
  const RutinasPage({Key? key}) : super(key: key);

  @override
  _RutinasPageState createState() => _RutinasPageState();
}

class _RutinasPageState extends State<RutinasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        body: SingleChildScrollView(
        child: Column(
          children: const [
            RutinasListPage(),
            ObjectivesListPage(),
          ],
        ),
      ),


    );
  }
}




