import 'dart:async';

import 'package:chat/pages/shared/colores.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecondQuestionPage extends StatefulWidget {
  const SecondQuestionPage({Key? key}) : super(key: key);

  @override
  State<SecondQuestionPage> createState() => _SecondQuestionPageState();
}

class _SecondQuestionPageState extends State<SecondQuestionPage> {
  int? selectedIndex;

  // tamaños por icono (izq. → der.)
  final List<double> sizes = [32, 30, 30, 35, 43];

  final List<String> iconPaths = [
    'assets/icons/face_icon_1.png',
    'assets/icons/face_icon_2.png',
    'assets/icons/face_icon_3.png',
    'assets/icons/face_icon_4.png',
    'assets/icons/face_icon_5.png',
  ];

  final List<String> outlookOptions = [
    'Con mucho entusiasmo',
    'Tranquilamente',
    'Con dudas',
    'Con estrés',
    'Muy agobiado',
  ];

  @override
  Widget build(BuildContext context) {
    
    const currentStep = 1;
    final personalDataSvc = Provider.of<PersonalDataService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 40,
              height: 1,
              color:
                  (index <= currentStep) ? Colors.white : Colors.grey[800],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '¿Cómo ha ido el día?',
            style: TextStyle(color: Colors.white70, fontSize: 24),
          ),
          const SizedBox(height: 24),

          // ───── fila de iconos seleccionables ──────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(iconPaths.length, (i) {
              final isSel = selectedIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => selectedIndex = i);
                    personalDataSvc.setFinalAttitude(outlookOptions[i], outlookOptions);
                    // pausa corta para mostrar el resaltado
                    Timer(const Duration(milliseconds: 150), () {
                      Navigator.pushNamed(
                        context,
                        'cuestionario_final_3',
                        arguments: outlookOptions[i], // opcional: pasar dato
                      );
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      iconPaths[i],
                      width: sizes[i],
                      height: sizes[i],
                      fit: BoxFit.contain,
                      color: isSel ? rojoBurdeos : Colors.grey,
                    ),
                  ),
                ),
              );
            }),
          ),

          // Si prefieres ocultar el botón, comenta lo siguiente
          // const SizedBox(height: 40),
          // ElevatedButton(
          //   onPressed: (selectedIndex != null)
          //       ? () => Navigator.pushNamed(context, 'cuestionario_final_3')
          //       : null,
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: rojoBurdeos,
          //     foregroundColor: Colors.white,
          //     padding:
          //         const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          //   child: const Text('Siguiente', style: TextStyle(fontSize: 16)),
          // ),
        ],
      ),
    );
  }
}