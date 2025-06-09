import 'package:chat/pages/widgets/finishAndUpdateButton.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/challenges/user_challenge_service.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/models/challenge.dart';
import 'package:chat/models/user_challenge.dart';
import 'package:chat/pages/shared/colores.dart';

class RetoInverseCounterPage extends StatefulWidget {
  final Challenge reto;

  const RetoInverseCounterPage({
    Key? key,
    required this.reto,
  }) : super(key: key);

  @override
  _RetoInverseCounterPageState createState() => _RetoInverseCounterPageState();
}

class _RetoInverseCounterPageState extends State<RetoInverseCounterPage> {
  late UserChallenge _uc;
  int count = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ucService = Provider.of<UserChallengeService>(context, listen: false);
      await ucService.getUserChallenges();
      // Buscar reto activo o crear uno nuevo
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
          counter: widget.reto.config['inverse_counter'] as int? ?? 10,
          writing: null,
          checklist: null,
          progressData: {},
          progressHistory: [],
          lastUpdated: DateTime.now(),
        ),
      );
      setState(() {
        _uc = found;
        count = _uc.counter ?? 0;
        _loading = false;
      });
    });
  }

  Future<void> _decrementCount() async {
    if (count <= 0) return;
    setState(() => count--); // Optimistic UI
    try {
      final ucService = Provider.of<UserChallengeService>(context, listen: false);
      final updated = await ucService.decrementCounter(_uc.id);
      setState(() {
        _uc = updated;
        count = updated.counter ?? 0;
      });
    } catch (e) {
      // Rollback si falla
      setState(() => count++);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar el contador: $e')),
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
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
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

                      // Texto indicativo
                      Text(
                        'Te quedan: $count',
                        style: const TextStyle(
                          fontSize: 20,
                          color: blancoSuave,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Contador inverso grande
                      Text(
                        '$count',
                        style: const TextStyle(
                          fontSize: 80,
                          color: rojoBurdeos,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Botón circular para decrementar
                      ElevatedButton(
                        onPressed: count > 0 ? _decrementCount : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: negroAbsoluto,
                          padding: const EdgeInsets.all(20),
                          shape: const CircleBorder(),
                          side: BorderSide(
                            color: count > 0 ? blancoSuave : blancoSuave.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: count > 0 ? blancoSuave : blancoSuave.withOpacity(0.3),
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Finalizar por hoy
                      FinishChallengeButton(
                        reto: widget.reto,
                        uc: _uc,
                        // siempre habilitado (o pon tu propia condición si quieres deshabilitarlo a 0)
                        enabled: true,
                        // devolvemos el valor actual del contador inverso
                        resultBuilder: () async => count,
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
