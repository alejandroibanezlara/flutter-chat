import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat/pages/shared/colores.dart'; // define aquí tu Color rojoBurdeos
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/challenges/user_challenge_service.dart';
import 'package:chat/services/personalData/microlearning_service.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FourthStartDayPage extends StatefulWidget {
  const FourthStartDayPage({Key? key}) : super(key: key);

  @override
  State<FourthStartDayPage> createState() => _FourthStartDayPageState();
}

class _FourthStartDayPageState extends State<FourthStartDayPage>
    with TickerProviderStateMixin {
  late final AnimationController _btnController;
  late Animation<double> _pulse;

  late final AnimationController _iconController;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  late final AnimationController _takeoffController;
  late Animation<Offset> _takeoffAnimation;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _btnController, curve: Curves.easeInOut),
    );

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: const Offset(0, -0.2),
    ).animate(CurvedAnimation(parent: _iconController, curve: Curves.easeInOut));

    _fade = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );

    _takeoffController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _takeoffAnimation = AlwaysStoppedAnimation<Offset>(Offset.zero);
  }

  @override
  void dispose() {
    _btnController.dispose();
    _iconController.dispose();
    _takeoffController.dispose();
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
              color: (index <= currentStep) ? Colors.white : Colors.grey[800],
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
      body: Stack(
        alignment: Alignment.center,
        children: [
          // ── CONTENIDO PRINCIPAL ──────────────────────────────
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  const SizedBox(height: 100), // separa del botón
                  ScaleTransition(
                    scale: _pulse,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() => _isLoading = true);
                              _btnController.stop();
                              _iconController.stop();

                              _takeoffAnimation = Tween<Offset>(
                                begin: Offset.zero,
                                end: const Offset(0, -3),
                              ).animate(CurvedAnimation(
                                parent: _takeoffController,
                                curve: Curves.fastOutSlowIn,
                              ));

                              final ucService = Provider.of<UserChallengeService>(
                                context,
                                listen: false,
                              );

                              // 1) Invalidar retos activos con más de 24h
                              await ucService.invalidateStaleChallenges();


                              await _takeoffController.forward();

                              final service = Provider.of<PersonalDataService>(
                                  context,
                                  listen: false);
                              final authService = Provider.of<AuthService>(
                                  context,
                                  listen: false);
                              final microProv =
                                  Provider.of<MicrolearningProvider>(context,
                                      listen: false);

                              try {
                                final cards =
                                    await service.getRandomMicrolearnings();
                                final cardIds =
                                    cards.map((c) => c.id).toList();

                                await service.replaceMicrolearningCards(
                                    authService.usuario!.uid, cardIds);
                                microProv.setMicrolearnings(cards);
                                await service.submitInitialQuestionnaire(
                                    authService.usuario!.uid);

                                Navigator.pushNamed(context, 'home');
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Error al cargar tarjetas: $e')),
                                  );
                                  setState(() => _isLoading = false);
                                  _btnController.repeat(reverse: true);
                                  _iconController.repeat(reverse: true);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: rojoBurdeos,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
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

          // ── COHETE ANIMADO ────────────────────────────────────
          SlideTransition(
            position: _isLoading ? _takeoffAnimation : _slide,
            child: FadeTransition(
              opacity: _fade,
              child:
              Image.asset(
                'assets/icons/little_phoenix.png',
                width: 48,
                height: 48,
                color: rojoBurdeos,
              ), 
              // Icon(
              //   Icons.rocket_launch,
              //   color: rojoBurdeos,
              //   size: 48,
              // ),
            ),
          ),
        ],
      ),
    );
  }
}