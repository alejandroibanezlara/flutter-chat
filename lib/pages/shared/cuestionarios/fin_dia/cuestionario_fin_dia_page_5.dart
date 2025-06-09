import 'dart:async';
import 'package:chat/helpers/EndOfDayProcessor.dart';
import 'package:chat/models/daily_task_user.dart';
import 'package:chat/models/personal_data.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/challenges/challenge_service.dart';
import 'package:chat/services/challenges/user_challenge_service.dart';
import 'package:chat/services/dailytask/dailytaks_service.dart';
import 'package:chat/services/personalData/metaData_User_service.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:chat/services/routine/routine_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FifthQuestionPage extends StatefulWidget {
  const FifthQuestionPage({Key? key}) : super(key: key);

  @override
  State<FifthQuestionPage> createState() => _FifthQuestionPageState();
}

class _FifthQuestionPageState extends State<FifthQuestionPage> with TickerProviderStateMixin {
  late AnimationController _streakCtrl;
  late AnimationController _numCtrl;
  late AnimationController _subtitleCtrl;
  late List<Animation<double>> _boltScales;
  late Animation<double> _numScale;

  bool _isSaving = false;
  bool _loadingData = true;
  PersonalData? _personalData;
  late List<Task> _taskObjects;
  int _currentStreak = 1;
  int _maxStreak = 0;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAllAnimations();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    _taskObjects = (args is List<Task>) ? args : <Task>[];
    _loadPersonalData();
  }

  void _initAnimations() {
    _numCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _subtitleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _streakCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _numScale = TweenSequence<double>([
      TweenSequenceItem(
        weight: 60,
        tween: Tween(begin: 0.0, end: 5.0).chain(CurveTween(curve: Curves.easeOutBack)),
      ),
      TweenSequenceItem(
        weight: 40,
        tween: Tween(begin: 5.0, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
      ),
    ]).animate(_numCtrl);
  }

  Future<void> _loadPersonalData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final personalSvc = Provider.of<PersonalDataService>(context, listen: false);

    try {
      final data = await personalSvc.getPersonalDataLight(authService.usuario!.uid);
      if (!mounted) return;
      setState(() {
        _personalData = data;
        _currentStreak = data.rachaActual + 1;
        _maxStreak = data.rachaMaxima;
        _loadingData = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingData = false;
      });
    }
  }

  void _startAllAnimations() {
    final totalBolts = 7;
    _boltScales = List.generate(totalBolts, (i) {
      final start = i / totalBolts;
      final end = (i + 0.8) / totalBolts;
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _streakCtrl,
          curve: Interval(start, end, curve: Curves.elasticOut),
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 300), () async {
      if (!mounted) return;
      await _numCtrl.forward();
      await _subtitleCtrl.forward();
      await _streakCtrl.forward();
    });
  }

  @override
  void dispose() {
    _streakCtrl.dispose();
    _numCtrl.dispose();
    _subtitleCtrl.dispose();
    super.dispose();
  }


  Future<void> _onSaveAndFinish() async {
    if (_personalData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Los datos aún no se han cargado.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    // 1) Recuperar servicios
    final authSvc           = Provider.of<AuthService>(context, listen: false);
    final personalSvc       = Provider.of<PersonalDataService>(context, listen: false);
    final dailySvc          = Provider.of<DailyTaskService>(context, listen: false);
    final challengeSvc      = Provider.of<ChallengeService>(context, listen: false);
    final userChallengeSvc  = Provider.of<UserChallengeService>(context, listen: false);
    final metaDataUserSvc   = Provider.of<MetaDataUserService>(context, listen: false);
    final routineSvc        = Provider.of<RoutineService>(context, listen: false); // ← nuevo

    // 2) Cargar rutinas activas
    final routines = await routineSvc.getRoutinesByStatus('in-progress');

    // 3) Construir el procesador
    final processor = EndOfDayProcessor(
      authService:            authSvc,
      personalDataService:    personalSvc,
      dailyTaskService:       dailySvc,
      challengeService:       challengeSvc,
      userChallengeService:   userChallengeSvc,
      metaDataUserService:    metaDataUserSvc,
    );

    // 4) Ejecutar cierre de jornada completo
    final success = await processor.finalizeDay(
      tasks:        _taskObjects,
      routines:     routines,            // ← aquí pasas las rutinas
      personalData: _personalData!,
    );

    // 5) Actualizar UI según resultado
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (success) {
      Navigator.pushNamedAndRemoveUntil(context, 'home', (r) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar datos')),
      );
    }
  }

  // Future<void> _onSaveAndFinish() async {
  //   if (_personalData == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Los datos aún no se han cargado.')),
  //     );
  //     return;
  //   }

  //   setState(() => _isSaving = true);

  //   final authService = Provider.of<AuthService>(context, listen: false);
  //   final personalSvc = Provider.of<PersonalDataService>(context, listen: false);
  //   final dailySvc = Provider.of<DailyTaskService>(context, listen: false);
  //   final userChallengeSvc = Provider.of<UserChallengeService>(context, listen: false);

  //   final todayEntry = {
  //     'completado': true,
  //     'fecha': DateTime.now().toUtc().toIso8601String(),
  //   };

  //   // final existingDias = (_personalData?.diaCompletado ?? [])
  //   //     .map((d) => d.toJson())
  //   //     .toList()
  //   //   ..add(todayEntry);
  //   final existingDias = await personalSvc.addDiaCompletado(authService.usuario!.uid, todayEntry);


  //   final nuevaRachaActual = _personalData!.rachaActual + 1;
  //   final nuevaRachaMaxima = nuevaRachaActual > _personalData!.rachaMaxima
  //       ? nuevaRachaActual
  //       : _personalData!.rachaMaxima;

  //   // final updatedData = await personalSvc.updatePersonalDataByUserId(
  //   //   authService.usuario!.uid,
  //   //   {
  //   //     'diaCompletado': existingDias,
  //   //     'rachaActual': nuevaRachaActual,
  //   //     'rachaMaxima': nuevaRachaMaxima,
  //   //   },
  //   // );

  //   await personalSvc.addDiaCompletado(authService.usuario!.uid, {
  //     'completado': true,
  //     'fecha': DateTime.now().toUtc().toIso8601String(),
  //   });

  //   final updatedData = await personalSvc.updatePersonalDataByUserId(authService.usuario!.uid, {
  //     'rachaActual': nuevaRachaActual,
  //     'rachaMaxima': nuevaRachaMaxima,
  //   });

  //   await personalSvc.submitFinalQuestionnaire(authService.usuario!.uid);
  //   final savedTasks = await dailySvc.saveImportantTasks(_taskObjects);
  //   final challengeSvc = Provider.of<ChallengeService>(context, listen: false);
  //   userChallengeSvc.setChallengeService(challengeSvc);
  //   await userChallengeSvc.invalidateStaleChallenges(); //Este es el metodo que pone en incomplete

  //   if (!mounted) return;
  //   setState(() => _isSaving = false);
  //   if (updatedData != null && savedTasks != null) {
  //     Navigator.pushNamedAndRemoveUntil(context, 'home', (r) => false);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Error al guardar datos')),
  //     );
  //   }
  // }

  Widget _buildBolt(int idx, bool filled) => Expanded(
        child: ScaleTransition(
          scale: _boltScales[idx],
          child: CircleAvatar(
            backgroundColor: Colors.grey[800],
            child: Icon(
              Icons.bolt,
              color: filled ? rojoBurdeos : Colors.grey,
              size: 28,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (_loadingData) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final days = (_personalData?.diaCompletado ?? [])
        .map((d) => DateTime(d.fecha.year, d.fecha.month, d.fecha.day))
        .toSet();

    final flags = <bool>[];
    for (int i = 3; i > 0; i--) {
      final dt = DateTime.now().subtract(Duration(days: i));
      flags.add(days.contains(DateTime(dt.year, dt.month, dt.day)));
    }
    flags.add(true);
    flags.addAll(List<bool>.filled(3, false)); // Total 7 bolts

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
            (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 40,
              height: 1,
              color: (i <= 4) ? Colors.white : Colors.grey[800],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Número de la racha con animación
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Racha de ',
                      style: TextStyle(color: Colors.white54, fontSize: 18, fontWeight: FontWeight.w600)),
                  ScaleTransition(
                    scale: _numScale,
                    child: Text('$_currentStreak',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  const Text(' días',
                      style: TextStyle(color: Colors.white54, fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 4),
              FadeTransition(
                opacity: _subtitleCtrl,
                child: const Text('¡Sigue así!',
                    style: TextStyle(color: Colors.white70, fontSize: 16, fontStyle: FontStyle.italic)),
              ),
              const SizedBox(height: 24),
              Row(children: List.generate(flags.length, (i) => _buildBolt(i, flags[i]))),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _onSaveAndFinish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rojoBurdeos,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Guardar y terminar por hoy'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}