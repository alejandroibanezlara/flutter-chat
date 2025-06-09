import 'package:chat/models/user_challenge.dart';
import 'package:chat/pages/widgets/finishAndUpdateButton.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/challenges/user_challenge_service.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/challenge.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:provider/provider.dart';

class RetoQuestionnairePage extends StatefulWidget {
  final Challenge reto;
  const RetoQuestionnairePage({ Key? key, required this.reto }) : super(key: key);

  @override
  _RetoQuestionnairePageState createState() => _RetoQuestionnairePageState();
}

class _Question {
  final String question;
  final List<String> answers;
  _Question({ required this.question, required this.answers });
}

class _RetoQuestionnairePageState extends State<RetoQuestionnairePage> {
  late final List<_Question> _questions;
  late final List<int?> _responses;
  late UserChallenge _uc;

  @override
  void initState() {
    super.initState();
    // extrae cfg como lista de dynamic
    final cfg = widget.reto.config;
    List<dynamic> raw;
    if (cfg is List) {
      raw = cfg;
    } else if (cfg is Map<String, dynamic> && cfg['questions'] is List) {
      raw = cfg['questions'] as List;
    } else {
      raw = [];
    }
    _questions = raw.map((e) {
      if (e is Map<String, dynamic>) {
        return _Question(
          question: e['question'] as String? ?? '',
          answers: (e['answers'] as List<dynamic>? ?? []).cast<String>(),
        );
      } else {
        final dyn = e as dynamic;
        return _Question(
          question: dyn.question as String? ?? '',
          answers: (dyn.answers as List<dynamic>? ?? []).cast<String>(),
        );
      }
    }).toList();
    _responses = List<int?>.filled(_questions.length, null);

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

  bool get _allAnswered => !_responses.contains(null);

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
              width: 40, height: 1,
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Título del reto
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
              const Text(
                'Responde las siguientes preguntas:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: blancoSuave,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Lista de preguntas y botones
              Expanded(
                child: ListView.separated(
                  itemCount: _questions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 24),
                  itemBuilder: (_, qi) {
                    final q = _questions[qi];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q.question,
                          style: const TextStyle(
                            fontSize: 18,
                            color: blancoSuave,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(q.answers.length, (ai) {
                            final selected = _responses[qi] == ai;
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _responses[qi] = ai;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selected ? rojoBurdeos : grisClaro,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    q.answers[ai],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: blancoSuave,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              // Botón Finalizar por hoy
              FinishChallengeButton(
                reto: widget.reto,
                uc: _uc,
                // Solo habilitado una vez que _allAnswered sea true
                enabled: _allAnswered,
                // Siempre guardamos 1 al completar el cuestionario
                resultBuilder: () async => 1,
                label: 'Finalizar por hoy',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
