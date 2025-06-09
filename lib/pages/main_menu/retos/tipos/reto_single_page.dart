import 'package:chat/models/user_challenge.dart';
import 'package:chat/pages/widgets/finishAndUpdateButton.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/challenges/user_challenge_service.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/challenge.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RetoSinglePage extends StatefulWidget {
  final Challenge reto;
  const RetoSinglePage({ Key? key, required this.reto }) : super(key: key);

  @override
  State<RetoSinglePage> createState() => _RetoSinglePageState();
}

class _RetoSinglePageState extends State<RetoSinglePage> {
  IconData _iconFromString(String? name) {
    switch (name) {
      case 'check_circle': return FontAwesomeIcons.checkCircle;
      case 'star':         return FontAwesomeIcons.star;
      case 'flag':         return FontAwesomeIcons.flag;
      case 'running':      return FontAwesomeIcons.running;
      default:             return FontAwesomeIcons.questionCircle;
    }
  }
  late UserChallenge _uc;

  @override
  void initState() {
    super.initState();

      WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ucService = Provider.of<UserChallengeService>(context, listen: false);
      await ucService.getUserChallenges();
      final found = ucService.items.firstWhere(
        (u) => u.challengeId == widget.reto.id && u.isActive,
        orElse: () => UserChallenge(
          id: '', userId: '', challengeId: widget.reto.id,
          status: 'active', startDate: DateTime.now(), isActive: true,
          currentTotal: 0, streakDays: 0, counter: 0,
          writing: null, checklist: null, progressData: {},
          progressHistory: [], lastUpdated: DateTime.now(),
        ),
      );
      setState(() {
        _uc = found;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const currentStep = 1;
    return Scaffold(
      backgroundColor: negroAbsoluto,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: blancoSuave),
          onPressed: () {
            // Acción para ir atrás
            Navigator.of(context).pushNamedAndRemoveUntil(
              'home',                           // Nombre de tu ruta Home
              (Route<dynamic> route) => false,  // Elimina todo lo anterior
            );
          },
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 40,
              height: 1,
              color: (i <= currentStep) ? Colors.white : Colors.grey[800],
            );
          }),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: blancoSuave),
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icono del reto
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: grisClaro.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: FaIcon(
                      _iconFromString(widget.reto.icon),
                      size: 50,
                      color: grisCarbon,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Título dinámico
                Text(
                  widget.reto.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    color: blancoSuave,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtítulo / descripción corta
                if (widget.reto.shortText.isNotEmpty) 
                  Text(
                    widget.reto.shortText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: blancoSuave,
                    ),
                  ),

                const SizedBox(height: 40),

                // Botón “HECHO”
                FinishChallengeButton(
                  reto: widget.reto,
                  uc: _uc,
                  enabled: true,                   // siempre habilitado
                  resultBuilder: () async => 1,    // guardamos siempre 1 en single
                  label: 'HECHO',                  // texto personalizado
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
