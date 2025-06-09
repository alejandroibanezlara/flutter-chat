import 'package:chat/pages/widgets/finishAndUpdateButton.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/challenges/user_challenge_service.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/models/challenge.dart';
import 'package:chat/models/user_challenge.dart';
import 'package:chat/pages/shared/colores.dart';

class RetoCounterPage extends StatefulWidget {
  final Challenge reto;

  const RetoCounterPage({
    Key? key,
    required this.reto,
  }) : super(key: key);

  @override
  _RetoCounterPageState createState() => _RetoCounterPageState();
}

class _RetoCounterPageState extends State<RetoCounterPage> {
  int count = 0;
  late UserChallenge _uc;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // Carga inicial de datos del UserChallenge
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ucService = Provider.of<UserChallengeService>(context, listen: false);
      // Asegurarse de tener la lista
      await ucService.getUserChallenges();
      final found = ucService.items.firstWhere(
        (u) => u.challengeId == widget.reto.id && u.isActive,
        orElse: () => UserChallenge(
          id: '',
          userId: '',
          challengeId: widget.reto.id,
          status: 'active',
          startDate: DateTime.now(),
          isActive: true,
          currentTotal: 0,
          streakDays: 0,
          counter: 0,
          writing: null,
          checklist: null,
          progressData: {},
          progressHistory: [],
          lastUpdated: DateTime.now(),
        ),
      );
      setState(() {
        _uc = found;
        count = found.counter ?? 0;
        _loading = false;
      });
    });
  }

  Future<void> _incrementCount() async {
    final ucService = Provider.of<UserChallengeService>(context, listen: false);
    try {
      final updated = await ucService.incrementCounter(_uc.id);
      setState(() {
        _uc = updated;
        count = updated.counter ?? 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al incrementar contador: $e')),
      );
    }
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
            Navigator.of(context).pushNamedAndRemoveUntil(
              'home',
              (Route<dynamic> route) => false,
            );
          },
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 40,
              height: 1,
              color: (index <= currentStep) ? Colors.white : Colors.grey[800],
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Título del reto
                      Text(
                        widget.reto.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          color: blancoSuave,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Contador
                      Text(
                        '$count',
                        style: const TextStyle(
                          fontSize: 100,
                          color: rojoBurdeos,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Botón para incrementar
                      ElevatedButton(
                        onPressed: _incrementCount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: negroAbsoluto,
                          padding: const EdgeInsets.all(20),
                          shape: const CircleBorder(),
                          side: const BorderSide(color: blancoSuave, width: 2),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: blancoSuave,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Finalizar por hoy
                      FinishChallengeButton(
                        reto: widget.reto,
                        uc: _uc,
                        enabled: true,                // o alguna condición si quisieras deshabilitarlo
                        resultBuilder: () async => count,  // devolvemos el valor actual del contador
                        label: 'Finalizar por hoy',
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
