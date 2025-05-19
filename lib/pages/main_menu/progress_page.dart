import 'package:chat/pages/main_menu/progreso/hall_of_fame_page.dart';
import 'package:chat/pages/main_menu/progreso/record_page.dart';
import 'package:chat/pages/main_menu/progreso/sumary_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        body: SingleChildScrollView(
        child: Column(
          children: const [
            RadarChartExample(),
            RecordPage(),
            HallOfFamePage(),
          ],
        ),
      ),


    );
  }
}

