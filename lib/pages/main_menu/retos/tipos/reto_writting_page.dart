import 'package:chat/pages/widgets/finishAndUpdateButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/challenges/user_challenge_service.dart';
import 'package:chat/models/challenge.dart';
import 'package:chat/models/user_challenge.dart';
import 'package:chat/pages/shared/colores.dart';

class RetoWritingPage extends StatefulWidget {
  final Challenge reto;
  const RetoWritingPage({Key? key, required this.reto}) : super(key: key);

  @override
  _RetoWritingPageState createState() => _RetoWritingPageState();
}

class _RetoWritingPageState extends State<RetoWritingPage> {
  late TextEditingController _controller;
  late int _maxLength;
  late UserChallenge _uc;
  bool _loading = true;
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    final cfg = widget.reto.config;
    _maxLength = (cfg != null && cfg['length'] is int) ? cfg['length'] as int : 150;
    _controller = TextEditingController();

    // Carga de UserChallenge activo
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ucService = Provider.of<UserChallengeService>(context, listen: false);
      await ucService.getUserChallenges();
      _uc = ucService.items.firstWhere(
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
          counter: null,
          writing: '',
          checklist: null,
          progressData: {},
          progressHistory: [],
          lastUpdated: DateTime.now(),
        ),
      );
      // Inicializar texto y longitud
      _controller.text = _uc.writing ?? '';
      _currentLength = _controller.text.length;
      setState(() => _loading = false);
    });

    // Listener para el contador de caracteres
    _controller.addListener(() {
      setState(() => _currentLength = _controller.text.length);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Guarda borrador mostrando SnackBar
  Future<void> _saveDraftWithFeedback() async {
    final texto = _controller.text;
    try {
      await Provider.of<UserChallengeService>(context, listen: false)
          .updateUserChallenge(_uc.id, {'writing': texto});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Borrador guardado')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error guardando borrador: $e')),
      );
    }
  }

  // Guarda borrador SIN feedback, para usar en el `preFinish`
  Future<void> _saveDraftSilently() async {
    final texto = _controller.text;
    await Provider.of<UserChallengeService>(context, listen: false)
        .updateUserChallenge(_uc.id, {'writing': texto});
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: negroAbsoluto,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    const currentStep = 1;
    return Scaffold(
      backgroundColor: negroAbsoluto,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: blancoSuave),
          onPressed: () =>
              Navigator.of(context).pushNamedAndRemoveUntil('home', (r) => false),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 40, height: 1,
            color: (i <= currentStep) ? Colors.white : Colors.grey[800],
          )),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              const SizedBox(height: 12),
              if (widget.reto.shortText.isNotEmpty) ...[
                Text(
                  widget.reto.shortText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: blancoSuave),
                ),
                const SizedBox(height: 20),
              ],
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLength: _maxLength,
                  minLines: 5,
                  maxLines: null,
                  style: const TextStyle(color: blancoSuave),
                  decoration: InputDecoration(
                    hintText: 'Escribe aquí tu respuesta...',
                    hintStyle: TextStyle(color: blancoSuave.withOpacity(0.6)),
                    counterText: '$_currentLength/$_maxLength',
                    counterStyle: const TextStyle(color: blancoSuave),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: blancoSuave),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: rojoBurdeos),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // Guardar borrador con feedback
              ElevatedButton(
                onPressed: _saveDraftWithFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: grisClaro,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                child: const Text(
                  'Guardar borrador',
                  style: TextStyle(
                      fontSize: 18,
                      color: blancoSuave,
                      fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),
              // Botón Finalizar que guarda sin feedback y registra currentTotal = 1
              FinishChallengeButton(
                reto: widget.reto,
                uc: _uc,
                enabled: _controller.text.isNotEmpty,
                preFinish: _saveDraftSilently,
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