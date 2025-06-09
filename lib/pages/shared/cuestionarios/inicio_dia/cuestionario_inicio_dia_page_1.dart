// first_start_day_page.dart
import 'package:chat/pages/shared/colores.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirstStartDayPage extends StatefulWidget {
  const FirstStartDayPage({Key? key}) : super(key: key);

  @override
  State<FirstStartDayPage> createState() => _FirstStartDayPageState();
}

class _FirstStartDayPageState extends State<FirstStartDayPage> {
  String? sleepQuality;
  String? dayOutlook;



// sustituyen las listas de emoji
final List<String> iconPaths = [
  'assets/icons/face_icon_1.png',
  'assets/icons/face_icon_2.png',
  'assets/icons/face_icon_3.png',
  'assets/icons/face_icon_4.png',
  'assets/icons/face_icon_5.png',
];


final List<String> sleepOptions = [
  'Excelente',     // 😀  (icono 1 muy alegre)
  'Bien',          // 🙂  (icono 2 alegre)
  'Regular',       // 😐  (icono 3 neutro)
  'Mal',           // 🙁  (icono 4 triste)
  'Muy mal',       // 😫  (icono 5 muy triste)
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

    // 1. Obtienes el servicio (sin escuchar repaints aquí)
    final personalDataSvc = Provider.of<PersonalDataService>(context, listen: false);

    const double kMaxIconSize = 40;   // tamaño del icono más grande (derecha)
    const double kStepPercent  = 0.1; // 3 % de diferencia por paso

    // ---------------- variables de tamaño ----------------
    double sizeVerySad    = 32;   // icono 1  (muy triste)
    double sizeSad        = 30;   // icono 2
    double sizeNeutral    = 30;   // icono 3
    double sizeHappy      = 35;   // icono 4
    double sizeVeryHappy  = 43;   // icono 5  (muy alegre)
        
    final currentStep = 0;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        // Flecha a la izquierda (atras minimalista)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            // Acción para ir atrás
            Navigator.pop(context);
          },
        ),
        // 5 barras centrales para indicar el paso actual
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 40,
              height: 1,
              // Cambia 'currentStep' por la variable que controla en qué paso estás (0..4)
              color: (index <= currentStep) ? Colors.white : Colors.grey[800],
            );
          }),
        ),
        // Botón "X" a la derecha para volver al inicio
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              // Acción para volver al inicio
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pregunta "¿Cómo has dormido?" con opciones en una fila
            const Text(
              '¿Cómo has dormido?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    /// Icono 1 – Muy triste
    Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => sleepQuality = sleepOptions[0]);
          personalDataSvc.setSleepQuality(sleepQuality!, sleepOptions);
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/icons/face_icon_1.png',
            width:  sizeVerySad,
            height: sizeVerySad,
            fit: BoxFit.contain,
            color: sleepQuality == sleepOptions[0] ? rojoBurdeos : Colors.grey,
          ),
        ),
      ),
    ),

    /// Icono 2 – Triste
    Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => sleepQuality = sleepOptions[1]);
          personalDataSvc.setSleepQuality(sleepQuality!, sleepOptions);
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/icons/face_icon_2.png',
            width:  sizeSad,
            height: sizeSad,
            fit: BoxFit.contain,
            color: sleepQuality == sleepOptions[1] ? rojoBurdeos : Colors.grey,
          ),
        ),
      ),
    ),

    /// Icono 3 – Indiferente
    Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => sleepQuality = sleepOptions[2]);
          personalDataSvc.setSleepQuality(sleepQuality!, sleepOptions);
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/icons/face_icon_3.png',
            width:  sizeNeutral,
            height: sizeNeutral,
            fit: BoxFit.contain,
            color: sleepQuality == sleepOptions[2] ? rojoBurdeos : Colors.grey,
          ),
        ),
      ),
    ),

    /// Icono 4 – Alegre
    Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => sleepQuality = sleepOptions[3]);
          personalDataSvc.setSleepQuality(sleepQuality!, sleepOptions);
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/icons/face_icon_4.png',
            width:  sizeHappy,
            height: sizeHappy,
            fit: BoxFit.contain,
            color: sleepQuality == sleepOptions[3] ? rojoBurdeos : Colors.grey,
          ),
        ),
      ),
    ),

    /// Icono 5 – Muy alegre
    Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => sleepQuality = sleepOptions[4]);
          personalDataSvc.setSleepQuality(sleepQuality!, sleepOptions);
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/icons/face_icon_5.png',
            width:  sizeVeryHappy,
            height: sizeVeryHappy,
            fit: BoxFit.contain,
            color: sleepQuality == sleepOptions[4] ? rojoBurdeos : Colors.grey,
          ),
        ),
      ),
    ),
  ],
),
            const SizedBox(height: 20),
            // Pregunta "¿Cómo vas a afrontar el día?" con opciones en una fila
            const Text(
              '¿Cómo vas a afrontar el día?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   children: List.generate(outlookOptions.length, (index) {
//     final iconPath   = iconPaths[index];
//     final option     = outlookOptions[index];
//     final isSelected = dayOutlook == option;

//     // tamaño escalado: más pequeño a la izquierda, mayor a la derecha
//     final size = kMaxIconSize * (1 - kStepPercent * (outlookOptions.length - 1 - index));

//     return Expanded(
//       child: GestureDetector(
//         onTap: () => setState(() => dayOutlook = option),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Image.asset(
//             iconPath,
//             width: size,
//             height: size,
//             fit: BoxFit.contain,
//             color: isSelected ? rojoBurdeos : Colors.grey,
//           ),
//         ),
//       ),
//     );
//   }),
// ),

// ---------------- fila sin lógica de escalado ----------------
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    /// Icono 1 – Muy triste
    Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => dayOutlook = outlookOptions[0]);
          personalDataSvc.setInitialAttitude(dayOutlook!, outlookOptions);
        }, 
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/icons/face_icon_1.png',
            width:  sizeVerySad,
            height: sizeVerySad,
            fit: BoxFit.contain,
            color: dayOutlook == outlookOptions[0] ? rojoBurdeos : Colors.grey,
          ),
        ),
      ),
    ),

    /// Icono 2 – Triste
    Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => dayOutlook = outlookOptions[1]);
          personalDataSvc.setInitialAttitude(dayOutlook!, outlookOptions);
        }, 
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/icons/face_icon_2.png',
            width:  sizeSad,
            height: sizeSad,
            fit: BoxFit.contain,
            color: dayOutlook == outlookOptions[1] ? rojoBurdeos : Colors.grey,
          ),
        ),
      ),
    ),

    /// Icono 3 – Indiferente
    Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => dayOutlook = outlookOptions[2]);
          personalDataSvc.setInitialAttitude(dayOutlook!, outlookOptions);
        }, 
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/icons/face_icon_3.png',
            width:  sizeNeutral,
            height: sizeNeutral,
            fit: BoxFit.contain,
            color: dayOutlook == outlookOptions[2] ? rojoBurdeos : Colors.grey,
          ),
        ),
      ),
    ),

    /// Icono 4 – Alegre
    Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => dayOutlook = outlookOptions[3]);
          personalDataSvc.setInitialAttitude(dayOutlook!, outlookOptions);
        }, 
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/icons/face_icon_4.png',
            width:  sizeHappy,
            height: sizeHappy,
            fit: BoxFit.contain,
            color: dayOutlook == outlookOptions[3] ? rojoBurdeos : Colors.grey,
          ),
        ),
      ),
    ),

    /// Icono 5 – Muy alegre
    Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => dayOutlook = outlookOptions[4]);
          personalDataSvc.setInitialAttitude(dayOutlook!, outlookOptions);
        }, 
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/icons/face_icon_5.png',
            width:  sizeVeryHappy,
            height: sizeVeryHappy,
            fit: BoxFit.contain,
            color: dayOutlook == outlookOptions[4] ? rojoBurdeos : Colors.grey,
          ),
        ),
      ),
    ),
  ],
),     
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: (sleepQuality != null && dayOutlook != null)
                    ? () => Navigator.pushNamed(context, 'cuestionario_inicial_2')
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: rojoBurdeos,          // color de fondo
                  foregroundColor: Colors.white,         // color de texto e iconos
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(         // radio de 8 px
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Siguiente',
                  style: TextStyle(fontSize: 16),         // ya hereda color blanco
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}