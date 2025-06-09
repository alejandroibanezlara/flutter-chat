import 'dart:async';
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

class RetoMathPage extends StatefulWidget {
  final Challenge reto;
  const RetoMathPage({ Key? key, required this.reto}) : super(key: key);

  @override
  _RetoMathPageState createState() => _RetoMathPageState();
}

class _RetoMathPageState extends State<RetoMathPage> with SingleTickerProviderStateMixin {
  int? _selectedIndex;
  late final String _question;
  late final List<String> _answers;
  late final int _correctIndex;
  late UserChallenge _uc;
  bool _loading = true;

  bool _showResult = false;
  bool _isCorrect = false;

  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    final cfg = widget.reto.config as Map<String, dynamic>? ?? {};
    _question = cfg['question'] as String? ?? '';
    _answers = [
      cfg['answer1'] as String? ?? '',
      cfg['answer2'] as String? ?? '',
      cfg['answer3'] as String? ?? '',
    ];
    final sol = cfg['solution']?.toString() ?? '1';
    _correctIndex = int.parse(sol) - 1;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );

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
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const currentStep = 1;
    if (_loading) {
      return const Scaffold(
        backgroundColor: negroAbsoluto,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: negroAbsoluto,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: blancoSuave),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              'home', (Route<dynamic> route) => false,
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
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    widget.reto.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      color: blancoSuave,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: blancoSuave,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _answers.length,
                      itemBuilder: (context, i) {
                        return RadioListTile<int>(
                          value: i,
                          groupValue: _selectedIndex,
                          onChanged: (val) {
                            if (_showResult) return;
                            setState(() => _selectedIndex = val);
                          },
                          title: Text(
                            _answers[i],
                            style: const TextStyle(fontSize: 18, color: blancoSuave),
                          ),
                          activeColor: rojoBurdeos,
                          tileColor: _selectedIndex == i
                              ? rojoBurdeos.withOpacity(0.1)
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  FinishChallengeButton(
                    reto: widget.reto,
                    uc: _uc,
                    enabled: _selectedIndex != null && !_showResult,
                    preFinish: () async {
                      setState(() {
                        _isCorrect = _selectedIndex == _correctIndex;
                        _showResult = true;
                      });
                      _animController.forward();
                      await Future.delayed(const Duration(seconds: 3));
                    },
                    resultBuilder: () async => 1,
                  ),
                ],
              ),
            ),
          ),
          if (_showResult)
            Center(
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: negroAbsoluto.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isCorrect ? FontAwesomeIcons.checkCircle : FontAwesomeIcons.timesCircle,
                        size: 64,
                        color: _isCorrect ? rojoBurdeos : blancoSuave,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isCorrect ? '¡Correcto!' : 'Incorrecto',
                        style: TextStyle(
                          fontSize: 24,
                          color: _isCorrect ? rojoBurdeos : blancoSuave,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
