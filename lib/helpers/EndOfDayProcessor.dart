import 'dart:math';
import 'package:chat/models/daily_task_user.dart';
import 'package:chat/models/metaData_User.dart';
import 'package:chat/models/personal_data.dart';
import 'package:flutter/material.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:chat/services/challenges/challenge_service.dart';
import 'package:chat/services/challenges/user_challenge_service.dart';
import 'package:chat/services/dailytask/dailytaks_service.dart';
import 'package:chat/services/personalData/metaData_User_service.dart';
import 'package:chat/models/routine.dart';

/// Servicio dedicado a procesar el cierre de jornada diario:
/// - Registro en PersonalData
/// - Invalidación de retos
/// - Registro en MetaDataUser
/// - Cálculo de rachas y perfect day
class EndOfDayProcessor {
  EndOfDayProcessor({
    required this.personalDataService,
    required this.dailyTaskService,
    required this.challengeService,
    required this.userChallengeService,
    required this.metaDataUserService,
    required this.authService,
  });

  final PersonalDataService personalDataService;
  final DailyTaskService dailyTaskService;
  final ChallengeService challengeService;
  final UserChallengeService userChallengeService;
  final MetaDataUserService metaDataUserService;
  final AuthService authService;

  Future<bool> finalizeDay({
    required List<Task> tasks,
    required List<Routine> routines,
    required PersonalData personalData,
  }) async {
    final uid = authService.usuario!.uid;
    final today = DateTime.now();

    // 1) Añadir día completado y actualizar racha en PersonalData
    await personalDataService.addDiaCompletado(uid, {
      'completado': true,
      'fecha': today.toUtc().toIso8601String(),
    });
    final newRacha = personalData.rachaActual + 1;
    final maxRacha = max(newRacha, personalData.rachaMaxima);
    await personalDataService.updatePersonalDataByUserId(uid, {
      'rachaActual': newRacha,
      'rachaMaxima': maxRacha,
    });

    // 2) Enviar cuestionario final
    await personalDataService.submitFinalQuestionnaire(uid);

    // 3) Guardar tareas y recuperar conteos
    await dailyTaskService.saveImportantTasks(tasks);
    final fetched = await dailyTaskService.getTasksForDate(
      today.toIso8601String().split('T').first);
    final todaysTasks = fetched?.tasks ?? [];
    final completedTasks = todaysTasks.where((t) => t.completedAt != null).length;
    final pendingTasks = todaysTasks.length - completedTasks;
    // Guardar en servicio para reutilización
    metaDataUserService.completedTasks = completedTasks;
    metaDataUserService.pendingTasks = pendingTasks;

    // 4) Invalidar retos incompletos
    userChallengeService.setChallengeService(challengeService);
    await userChallengeService.invalidateStaleChallenges();

    // 5) Registrar contadores de retos en MetaDataUser
    await _registerCounter(
      uid: uid,
      count: personalData.contadorRetosDia!,
      completedField: 'retosDiariosCompletados',
      notCompletedField: 'retosDiariosNoCompletados',
    );
    await _registerCounter(
      uid: uid,
      count: personalData.contadorRetosSemana!,
      completedField: 'retosSemanalesCompletados',
      notCompletedField: 'retosSemanalesNoCompletados',
    );
    await _registerCounter(
      uid: uid,
      count: personalData.contadorRetosMes!,
      completedField: 'retosMensualesCompletados',
      notCompletedField: 'retosMensualesNoCompletados',
    );

    // 6) Registrar día de tareas
    if (completedTasks > 0 && pendingTasks == 0) {
      await metaDataUserService.addDate(userId: uid, field: 'diaTareasCompleto', date: today);
    } else if (!(completedTasks == 0 && pendingTasks == 0)) {
      await metaDataUserService.addDate(userId: uid, field: 'diaTareasNoCompleto', date: today);
    }

    // 7) Registrar día de rutinas usando exactamente la misma lógica que en la UI:
    final List<Routine> rutinasHoy = routines.where((routine) {
      final dias = routine.diasCompletados ?? [];
      return dias.any((d) => isSameDay(d.fecha.toLocal(), today));
    }).toList();

    // Contamos solo dentro de las rutinas que efectivamente tienen un registro HOY
    final int completedRoutines = rutinasHoy.where((routine) {
      final d = routine.diasCompletados!
          .firstWhere((dia) => isSameDay(dia.fecha.toLocal(), today));
      return d.status == StatusDiaCompletado.completado;
    }).length;

    // Y el resto de rutinas “de hoy” será pendiente
    final int pendingRoutines = rutinasHoy.length - completedRoutines;

    // (Opcional) Guardar en el servicio para elección posterior,
    // pero **no** volver a usarlo para el cálculo.
    metaDataUserService.completedRoutines = completedRoutines;
    metaDataUserService.pendingRoutines   = pendingRoutines;

    print('completedRoutines: $completedRoutines');
    print('pendingRoutines:   $pendingRoutines');

    if (completedRoutines > 0 && pendingRoutines == 0) {
      await metaDataUserService.addDate(
        userId: uid,
        field: 'diasRutinasCompletadas',
        date: today,
      );
    } else if (!(completedRoutines == 0 && pendingRoutines == 0)) {
      await metaDataUserService.addDate(
        userId: uid,
        field: 'diasRutinasNoCompletadas',
        date: today,
      );
    }
    // 8) Cuestionario final y última actividad
    await metaDataUserService.addDate(userId: uid, field: 'cuestionarioFinalCompletado', date: today);
    await metaDataUserService.setDateField(
      userId: uid,
      field: 'lastActivityDate',
      date: today,
    );

    // 9) Calcular y guardar rachas
    final meta = await metaDataUserService.getStatsLight(uid);
    final newRachaTareas = (metaDataUserService.completedTasks! > 0 && metaDataUserService.pendingTasks! == 0)
      ? meta.rachaTareas + 1 : 0;
    final maxRachaTareas = max(meta.rachaMaximaTareas, newRachaTareas);
    final newRachaRutinas = (metaDataUserService.completedRoutines! > 0 && metaDataUserService.pendingRoutines! == 0)
      ? meta.rachaRutinas + 1 : 0;
    final maxRachaRutinas = max(meta.rachaMaximaRutinas, newRachaRutinas);
    final newRachaRetos = personalData.contadorRetosDia! >= 3
      ? meta.rachaRetosDiarios + 1 : 0;
    final maxRachaRetos = max(meta.rachaMaximaRetosDiarios, newRachaRetos);
    await metaDataUserService.updateFields(
      userId: uid,
      data: {
        'rachaTareas': newRachaTareas,
        'rachaMaximaTareas': maxRachaTareas,
        'rachaRutinas': newRachaRutinas,
        'rachaMaximaRutinas': maxRachaRutinas,
        'rachaRetosDiarios': newRachaRetos,
        'rachaMaximaRetosDiarios': maxRachaRetos,
      },
    );

    // 10) Perfect day (tareas, rutinas y retos diarios)
    if (metaDataUserService.completedTasks! > 0
        && metaDataUserService.pendingTasks! == 0
        && metaDataUserService.completedRoutines! > 0
        && metaDataUserService.pendingRoutines! == 0
        && personalData.contadorRetosDia! >= 3) {
      await metaDataUserService.addDate(userId: uid, field: 'perfectDay', date: today);
    }

    return true;
  }

  Future<void> _registerCounter({
    required String uid,
    required int count,
    required String completedField,
    required String notCompletedField,
  }) async {
    final field = count >= 3 ? completedField : notCompletedField;
    await metaDataUserService.addDate(userId: uid, field: field, date: DateTime.now());
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}