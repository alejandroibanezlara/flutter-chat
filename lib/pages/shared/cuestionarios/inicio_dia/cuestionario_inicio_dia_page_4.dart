// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:chat/pages/shared/colores.dart';
// import 'package:flutter/material.dart';

// class FourthStartDayPage extends StatefulWidget {
//   const FourthStartDayPage({Key? key}) : super(key: key);

//   @override
//   State<FourthStartDayPage> createState() => _FourthStartDayPageState();
// }

// class _FourthStartDayPageState extends State<FourthStartDayPage>
//     with SingleTickerProviderStateMixin {
// late final AnimationController _btnController;
// late final Animation<double>   _pulse;    // ← animación ya escalada

// @override
// void initState() {
//   super.initState();

//   _btnController = AnimationController(
//     vsync: this,
//     duration: const Duration(milliseconds: 1500),
//   )..repeat(reverse: true);

//   // escala 0.95 ↔ 1.05 y aplica la curva
//   _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
//     CurvedAnimation(parent: _btnController, curve: Curves.easeInOut),
//   );
// }
// @override
// void dispose() {
//   _btnController.dispose();
//   super.dispose();
// }

//   @override
//   Widget build(BuildContext context) {
//     const currentStep = 3;
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         title: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: List.generate(
//             4,
//             (index) => Container(
//               margin: const EdgeInsets.symmetric(horizontal: 2),
//               width: 40,
//               height: 1,
//               color: (index <= currentStep)
//                   ? Colors.white
//                   : Colors.grey[800],
//             ),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.close, color: Colors.white),
//             onPressed: () =>
//                 Navigator.popUntil(context, (route) => route.isFirst),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // ── Animación de zoom‑in + rebote ──────────────────────────
//               TweenAnimationBuilder<double>(
//                 tween: Tween(begin: 0.0, end: 1.0),
//                 duration: const Duration(milliseconds: 800),
//                 curve: Curves.elasticOut,
//                 builder: (context, value, child) => Transform.scale(
//                   scale: value,
//                   child: child,
//                 ),
//                 child: const Text(
//                   '¡Bien hecho!',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               // ── Texto motivador con efecto máquina de escribir ─────────
//               AnimatedTextKit(
//                 animatedTexts: [
//                   TypewriterAnimatedText(
//                     '¡Hoy vas a comerte el día!',
//                     textStyle: const TextStyle(
//                       color: Colors.white70,
//                       fontSize: 20,
//                     ),
//                     speed: const Duration(milliseconds: 60),
//                     cursor: ' ',
//                   ),
//                 ],
//                 isRepeatingAnimation: false,
//                 totalRepeatCount: 1,
//               ),
//               const SizedBox(height: 48),
//               // ── Botón pulsante ─────────────────────────────────────────
//               ScaleTransition(
//                 scale: _pulse,
//                 child: ElevatedButton(
//                   onPressed: () =>
//                       Navigator.pushNamed(context, 'home'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: rojoBurdeos,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 32, vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text('¡A por todas!', style: TextStyle(fontSize: 16)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat/pages/shared/colores.dart';      // define aquí tu Color rojoBurdeos
import 'package:flutter/material.dart';

class FourthStartDayPage extends StatefulWidget {
  const FourthStartDayPage({Key? key}) : super(key: key);

  @override
  State<FourthStartDayPage> createState() => _FourthStartDayPageState();
}

class _FourthStartDayPageState extends State<FourthStartDayPage>
    with TickerProviderStateMixin {
  // ───────── controllers y animaciones ─────────────────────────────
  late final AnimationController _btnController;   // latido del botón
late Animation<double>   _pulse = AlwaysStoppedAnimation(1.0);

  late final AnimationController _iconController;  // movimiento del icono
late Animation<Offset>   _slide = AlwaysStoppedAnimation(Offset.zero);
late Animation<double>   _fade  = AlwaysStoppedAnimation(1.0);

@override
void initState() {
  super.initState();

  // ── botón ────────────────────────────────────────────────
  _btnController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat(reverse: true);

  _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
    CurvedAnimation(parent: _btnController, curve: Curves.easeInOut),
  );

  // ── icono ────────────────────────────────────────────────
  _iconController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  _slide = Tween<Offset>(
    begin: const Offset(0, 0.2),
    end:   const Offset(0, -0.2),
  ).animate(CurvedAnimation(parent: _iconController, curve: Curves.easeInOut));

  _fade = Tween<double>(begin: 0.4, end: 1.0).animate(
    CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
  );
}
  @override
  void dispose() {
    _btnController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const currentStep = 3;

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
            4,
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── título con rebote ────────────────────────────────────
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, value, child) =>
                    Transform.scale(scale: value, child: child),
                child: const Text(
                  '¡Bien hecho!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── texto máquina de escribir ───────────────────────────
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    '¡Hoy vas a comerte el día!',
                    textStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                    ),
                    speed: const Duration(milliseconds: 60),
                    cursor: ' ',
                  ),
                ],
                isRepeatingAnimation: false,
                totalRepeatCount: 1,
              ),
              const SizedBox(height: 32),

              // ── icono motivador (cohete) ────────────────────────────
              SlideTransition(
                position: _slide,
                child: FadeTransition(
                  opacity: _fade,
                  child: Icon(
                    Icons.rocket_launch,        // usa Icons.arrow_upward si tu versión de Flutter es antigua
                    color: rojoBurdeos,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // ── botón pulsante ──────────────────────────────────────
              ScaleTransition(
                scale: _pulse,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, 'home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rojoBurdeos,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '¡A por todas!',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}