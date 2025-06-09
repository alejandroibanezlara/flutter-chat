import 'dart:convert';

class MetaDataUser {
  final String usuario;


  // Arrays de fechas
  final List<DateTime> retosDiariosCompletados;
  final List<DateTime> retosDiariosEnCurso;
  final List<DateTime> retosDiariosNoCompletados;
  final List<DateTime> retosDiariosCancelados;

  final List<DateTime> retosExtraDiariosCompletados;
  final List<DateTime> retosExtraDiariosEnCurso;
  final List<DateTime> retosExtraDiariosNoCompletados;
  final List<DateTime> retosExtraDiariosCancelados;

  final List<DateTime> retosSemanalesCompletados;
  final List<DateTime> retosSemanalesEnCurso;
  final List<DateTime> retosSemanalesNoCompletados;
  final List<DateTime> retosSemanalesCancelados;

  final List<DateTime> retosMensualesCompletados;
  final List<DateTime> retosMensualesEnCurso;
  final List<DateTime> retosMensualesNoCompletados;
  final List<DateTime> retosMensualesCancelados;

  final List<DateTime> retosDestacadosCompletados;
  final List<DateTime> retosDestacadosEnCurso;
  final List<DateTime> retosDestacadosNoCompletados;
  final List<DateTime> retosDestacadosCancelados;

  final List<DateTime> diaTareasCompleto;
  final List<DateTime> diaTareasNoCompleto;
  final List<DateTime> diasRutinasCompletadas;
  final List<DateTime> diasRutinasNoCompletadas;

  final List<DateTime> cuestionarioInicialCompletado;
  final List<DateTime> cuestionarioFinalCompletado;
  final List<DateTime> perfectDay;

  final DateTime? lastActivityDate;

  // Contadores (int)
  final int tareasCompletadas;
  final int tareasNoCompletadas;
  final int tareasSapoCompletadas;
  final int microlearningsLeidos;
  final int cumplimientoGeneral;

  final int retosEmpatiaYSolidaridad;
  final int retosCarisma;
  final int retosDisciplina;
  final int retosOrganizacion;
  final int retosAdaptabilidad;
  final int retosImagenPulida;
  final int retosVisionEstrategica;
  final int retosEducacionFinanciera;
  final int retosActitudDeSuperacion;
  final int retosComunicacionAsertiva;

  final int puntosEmpatiaYSolidaridad;
  final int puntosCarisma;
  final int puntosDisciplina;
  final int puntosOrganizacion;
  final int puntosAdaptabilidad;
  final int puntosImagenPulida;
  final int puntosVisionEstrategica;
  final int puntosEducacionFinanciera;
  final int puntosActitudDeSuperacion;
  final int puntosComunicacionAsertiva;

  final int retosCounter;
  final int retosInverseCounter;
  final int retosChecklist;
  final int retosQuestionnaire;
  final int retosWriting;
  final int retosRedNote;
  final int retosCrono;
  final int retosTempo;
  final int retosMath;
  final int retosSingle;

  // Tiempos medios (double)
  final double tiempoMedioCounter;
  final double tiempoMedioInverseCounter;
  final double tiempoMedioChecklist;
  final double tiempoMedioQuestionnaire;
  final double tiempoMedioWriting;
  final double tiempoMedioRedNote;
  final double tiempoMedioCrono;
  final double tiempoMedioTempo;
  final double tiempoMedioMath;
  final double tiempoMedioSingle;

  // Rachas
  final int rachaTareas;
  final int rachaMaximaTareas;
  final int rachaRutinas;
  final int rachaMaximaRutinas;
  final int rachaRetosDiarios;
  final int rachaMaximaRetosDiarios;

  // Métricas agregadas
  final int averageDailyPoints;
  final double averageCompletionTime;

  MetaDataUser({
    required this.usuario,
    this.retosDiariosCompletados = const [],
    this.retosDiariosEnCurso = const [],
    this.retosDiariosNoCompletados = const [],
    this.retosDiariosCancelados = const [],
    this.retosExtraDiariosCompletados = const [],
    this.retosExtraDiariosEnCurso = const [],
    this.retosExtraDiariosNoCompletados = const [],
    this.retosExtraDiariosCancelados = const [],
    this.retosSemanalesCompletados = const [],
    this.retosSemanalesEnCurso = const [],
    this.retosSemanalesNoCompletados = const [],
    this.retosSemanalesCancelados = const [],
    this.retosMensualesCompletados = const [],
    this.retosMensualesEnCurso = const [],
    this.retosMensualesNoCompletados = const [],
    this.retosMensualesCancelados = const [],
    this.retosDestacadosCompletados = const [],
    this.retosDestacadosEnCurso = const [],
    this.retosDestacadosNoCompletados = const [],
    this.retosDestacadosCancelados = const [],
    this.diaTareasCompleto = const [],
    this.diaTareasNoCompleto = const [],
    this.diasRutinasCompletadas = const [],
    this.diasRutinasNoCompletadas = const [],
    this.cuestionarioInicialCompletado = const [],
    this.cuestionarioFinalCompletado = const [],
    this.perfectDay = const [],
    this.lastActivityDate,
    this.tareasCompletadas = 0,
    this.tareasNoCompletadas = 0,
    this.tareasSapoCompletadas = 0,
    this.microlearningsLeidos = 0,
    this.cumplimientoGeneral = 0,
    this.retosEmpatiaYSolidaridad = 0,
    this.retosCarisma = 0,
    this.retosDisciplina = 0,
    this.retosOrganizacion = 0,
    this.retosAdaptabilidad = 0,
    this.retosImagenPulida = 0,
    this.retosVisionEstrategica = 0,
    this.retosEducacionFinanciera = 0,
    this.retosActitudDeSuperacion = 0,
    this.retosComunicacionAsertiva = 0,
    this.puntosEmpatiaYSolidaridad = 0,
    this.puntosCarisma = 0,
    this.puntosDisciplina = 0,
    this.puntosOrganizacion = 0,
    this.puntosAdaptabilidad = 0,
    this.puntosImagenPulida = 0,
    this.puntosVisionEstrategica = 0,
    this.puntosEducacionFinanciera = 0,
    this.puntosActitudDeSuperacion = 0,
    this.puntosComunicacionAsertiva = 0,
    this.retosCounter = 0,
    this.retosInverseCounter = 0,
    this.retosChecklist = 0,
    this.retosQuestionnaire = 0,
    this.retosWriting = 0,
    this.retosRedNote = 0,
    this.retosCrono = 0,
    this.retosTempo = 0,
    this.retosMath = 0,
    this.retosSingle = 0,
    this.tiempoMedioCounter = 0.0,
    this.tiempoMedioInverseCounter = 0.0,
    this.tiempoMedioChecklist = 0.0,
    this.tiempoMedioQuestionnaire = 0.0,
    this.tiempoMedioWriting = 0.0,
    this.tiempoMedioRedNote = 0.0,
    this.tiempoMedioCrono = 0.0,
    this.tiempoMedioTempo = 0.0,
    this.tiempoMedioMath = 0.0,
    this.tiempoMedioSingle = 0.0,
    this.rachaTareas = 0,
    this.rachaMaximaTareas = 0,
    this.rachaRutinas = 0,
    this.rachaMaximaRutinas = 0,
    this.rachaRetosDiarios = 0,
    this.rachaMaximaRetosDiarios = 0,
    this.averageDailyPoints = 0,
    this.averageCompletionTime = 0.0,
  });

  factory MetaDataUser.fromJson(Map<String, dynamic> json) {
    // Extrae un String de json['usuario'], venga como String o Map
    String parseUsuario(dynamic u) {
      if (u is String) return u;
      if (u is Map<String, dynamic>) {
        // mongoose populate suele devolver { _id: "...", nombre:..., email:... }
        return (u['_id'] ?? u['uid'] ?? u['id']).toString();
      }
      return u.toString();
    }

    // Parsea listas de fechas que puedan venir como ISO-strings o como {"$date":"..."}
    List<DateTime> parseDates(dynamic list) {
      if (list is! List) return [];
      return list.map<DateTime>((e) {
        String raw;
        if (e is String) {
          raw = e;
        } else if (e is Map<String, dynamic>) {
          raw = e[r'$date'] ?? e.values.first.toString();
        } else {
          raw = e.toString();
        }
        return DateTime.parse(raw).toLocal();
      }).toList();
    }

    return MetaDataUser(
      usuario: parseUsuario(json['usuario']),
      retosDiariosCompletados: parseDates(json['retosDiariosCompletados']),
      retosDiariosEnCurso: parseDates(json['retosDiariosEnCurso']),
      retosDiariosNoCompletados: parseDates(json['retosDiariosNoCompletados']),
      retosDiariosCancelados: parseDates(json['retosDiariosCancelados']),
      retosExtraDiariosCompletados: parseDates(json['retosExtraDiariosCompletados']),
      retosExtraDiariosEnCurso: parseDates(json['retosExtraDiariosEnCurso']),
      retosExtraDiariosNoCompletados: parseDates(json['retosExtraDiariosNoCompletados']),
      retosExtraDiariosCancelados: parseDates(json['retosExtraDiariosCancelados']),
      retosSemanalesCompletados: parseDates(json['retosSemanalesCompletados']),
      retosSemanalesEnCurso: parseDates(json['retosSemanalesEnCurso']),
      retosSemanalesNoCompletados: parseDates(json['retosSemanalesNoCompletados']),
      retosSemanalesCancelados: parseDates(json['retosSemanalesCancelados']),
      retosMensualesCompletados: parseDates(json['retosMensualesCompletados']),
      retosMensualesEnCurso: parseDates(json['retosMensualesEnCurso']),
      retosMensualesNoCompletados: parseDates(json['retosMensualesNoCompletados']),
      retosMensualesCancelados: parseDates(json['retosMensualesCancelados']),
      retosDestacadosCompletados: parseDates(json['retosDestacadosCompletados']),
      retosDestacadosEnCurso: parseDates(json['retosDestacadosEnCurso']),
      retosDestacadosNoCompletados: parseDates(json['retosDestacadosNoCompletados']),
      retosDestacadosCancelados: parseDates(json['retosDestacadosCancelados']),
      diaTareasCompleto: parseDates(json['diaTareasCompleto']),
      diaTareasNoCompleto: parseDates(json['diaTareasNoCompleto']),
      diasRutinasCompletadas: parseDates(json['diasRutinasCompletadas']),
      diasRutinasNoCompletadas: parseDates(json['diasRutinasNoCompletadas']),
      cuestionarioInicialCompletado: parseDates(json['cuestionarioInicialCompletado']),
      cuestionarioFinalCompletado: parseDates(json['cuestionarioFinalCompletado']),
      perfectDay: parseDates(json['perfectDay']),
      lastActivityDate: json['lastActivityDate'] != null ? DateTime.parse(json['lastActivityDate'] as String) : null,
      tareasCompletadas: json['tareasCompletadas'] ?? 0,
      tareasNoCompletadas: json['tareasNoCompletadas'] ?? 0,
      tareasSapoCompletadas: json['tareasSapoCompletadas'] ?? 0,
      microlearningsLeidos: json['microlearningsLeidos'] ?? 0,
      cumplimientoGeneral: json['cumplimientoGeneral'] ?? 0,
      retosEmpatiaYSolidaridad: json['retosEmpatiaYSolidaridad'] ?? 0,
      retosCarisma: json['retosCarisma'] ?? 0,
      retosDisciplina: json['retosDisciplina'] ?? 0,
      retosOrganizacion: json['retosOrganizacion'] ?? 0,
      retosAdaptabilidad: json['retosAdaptabilidad'] ?? 0,
      retosImagenPulida: json['retosImagenPulida'] ?? 0,
      retosVisionEstrategica: json['retosVisionEstrategica'] ?? 0,
      retosEducacionFinanciera: json['retosEducacionFinanciera'] ?? 0,
      retosActitudDeSuperacion: json['retosActitudDeSuperacion'] ?? 0,
      retosComunicacionAsertiva: json['retosComunicacionAsertiva'] ?? 0,
      puntosEmpatiaYSolidaridad: json['puntosEmpatiaYSolidaridad'] ?? 0,
      puntosCarisma: json['puntosCarisma'] ?? 0,
      puntosDisciplina: json['puntosDisciplina'] ?? 0,
      puntosOrganizacion: json['puntosOrganizacion'] ?? 0,
      puntosAdaptabilidad: json['puntosAdaptabilidad'] ?? 0,
      puntosImagenPulida: json['puntosImagenPulida'] ?? 0,
      puntosVisionEstrategica: json['puntosVisionEstrategica'] ?? 0,
      puntosEducacionFinanciera: json['puntosEducacionFinanciera'] ?? 0,
      puntosActitudDeSuperacion: json['puntosActitudDeSuperacion'] ?? 0,
      puntosComunicacionAsertiva: json['puntosComunicacionAsertiva'] ?? 0,
      retosCounter: json['retosCounter'] ?? 0,
      retosInverseCounter: json['retosInverseCounter'] ?? 0,
      retosChecklist: json['retosChecklist'] ?? 0,
      retosQuestionnaire: json['retosQuestionnaire'] ?? 0,
      retosWriting: json['retosWriting'] ?? 0,
      retosRedNote: json['retosRedNote'] ?? 0,
      retosCrono: json['retosCrono'] ?? 0,
      retosTempo: json['retosTempo'] ?? 0,
      retosMath: json['retosMath'] ?? 0,
      retosSingle: json['retosSingle'] ?? 0,
      tiempoMedioCounter: (json['tiempoMedioCounter'] as num?)?.toDouble() ?? 0.0,
      tiempoMedioInverseCounter: (json['tiempoMedioInverseCounter'] as num?)?.toDouble() ?? 0.0,
      tiempoMedioChecklist: (json['tiempoMedioChecklist'] as num?)?.toDouble() ?? 0.0,
      tiempoMedioQuestionnaire: (json['tiempoMedioQuestionnaire'] as num?)?.toDouble() ?? 0.0,
      tiempoMedioWriting: (json['tiempoMedioWriting'] as num?)?.toDouble() ?? 0.0,
      tiempoMedioRedNote: (json['tiempoMedioRedNote'] as num?)?.toDouble() ?? 0.0,
      tiempoMedioCrono: (json['tiempoMedioCrono'] as num?)?.toDouble() ?? 0.0,
      tiempoMedioTempo: (json['tiempoMedioTempo'] as num?)?.toDouble() ?? 0.0,
      tiempoMedioMath: (json['tiempoMedioMath'] as num?)?.toDouble() ?? 0.0,
      tiempoMedioSingle: (json['tiempoMedioSingle'] as num?)?.toDouble() ?? 0.0,
      rachaTareas: json['rachaTareas'] ?? 0,
      rachaMaximaTareas: json['rachaMaximaTareas'] ?? 0,
      rachaRutinas: json['rachaRutinas'] ?? 0,
      rachaMaximaRutinas: json['rachaMaximaRutinas'] ?? 0,
      rachaRetosDiarios: json['rachaRetosDiarios'] ?? 0,
      rachaMaximaRetosDiarios: json['rachaMaximaRetosDiarios'] ?? 0,
      averageDailyPoints: json['averageDailyPoints'] ?? 0,
      averageCompletionTime: (json['averageCompletionTime'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    List<String> formatDates(List<DateTime> list) =>
        list.map((d) => d.toIso8601String()).toList();

    return {
      'usuario': usuario,
      'retosDiariosCompletados': formatDates(retosDiariosCompletados),
      'retosDiariosEnCurso': formatDates(retosDiariosEnCurso),
      'retosDiariosNoCompletados': formatDates(retosDiariosNoCompletados),
      'retosDiariosCancelados': formatDates(retosDiariosCancelados),
      'retosExtraDiariosCompletados': formatDates(retosExtraDiariosCompletados),
      'retosExtraDiariosEnCurso': formatDates(retosExtraDiariosEnCurso),
      'retosExtraDiariosNoCompletados': formatDates(retosExtraDiariosNoCompletados),
      'retosExtraDiariosCancelados': formatDates(retosExtraDiariosCancelados),
      'retosSemanalesCompletados': formatDates(retosSemanalesCompletados),
      'retosSemanalesEnCurso': formatDates(retosSemanalesEnCurso),
      'retosSemanalesNoCompletados': formatDates(retosSemanalesNoCompletados),
      'retosSemanalesCancelados': formatDates(retosSemanalesCancelados),
      'retosMensualesCompletados': formatDates(retosMensualesCompletados),
      'retosMensualesEnCurso': formatDates(retosMensualesEnCurso),
      'retosMensualesNoCompletados': formatDates(retosMensualesNoCompletados),
      'retosMensualesCancelados': formatDates(retosMensualesCancelados),
      'retosDestacadosCompletados': formatDates(retosDestacadosCompletados),
      'retosDestacadosEnCurso': formatDates(retosDestacadosEnCurso),
      'retosDestacadosNoCompletados': formatDates(retosDestacadosNoCompletados),
      'retosDestacadosCancelados': formatDates(retosDestacadosCancelados),
      'diaTareasCompleto': formatDates(diaTareasCompleto),
      'diaTareasNoCompleto': formatDates(diaTareasNoCompleto),
      'diasRutinasCompletadas': formatDates(diasRutinasCompletadas),
      'diasRutinasNoCompletadas': formatDates(diasRutinasNoCompletadas),
      'cuestionarioInicialCompletado': formatDates(cuestionarioInicialCompletado),
      'cuestionarioFinalCompletado': formatDates(cuestionarioFinalCompletado),
      'perfectDay': formatDates(perfectDay),
      'lastActivityDate': lastActivityDate?.toIso8601String(),
      'tareasCompletadas': tareasCompletadas,
      'tareasNoCompletadas': tareasNoCompletadas,
      'tareasSapoCompletadas': tareasSapoCompletadas,
      'microlearningsLeidos': microlearningsLeidos,
      'cumplimientoGeneral': cumplimientoGeneral,
      'retosEmpatiaYSolidaridad': retosEmpatiaYSolidaridad,
      'retosCarisma': retosCarisma,
      'retosDisciplina': retosDisciplina,
      'retosOrganizacion': retosOrganizacion,
      'retosAdaptabilidad': retosAdaptabilidad,
      'retosImagenPulida': retosImagenPulida,
      'retosVisionEstrategica': retosVisionEstrategica,
      'retosEducacionFinanciera': retosEducacionFinanciera,
      'retosActitudDeSuperacion': retosActitudDeSuperacion,
      'retosComunicacionAsertiva': retosComunicacionAsertiva,
      'puntosEmpatiaYSolidaridad': puntosEmpatiaYSolidaridad,
      'puntosCarisma': puntosCarisma,
      'puntosDisciplina': puntosDisciplina,
      'puntosOrganizacion': puntosOrganizacion,
      'puntosAdaptabilidad': puntosAdaptabilidad,
      'puntosImagenPulida': puntosImagenPulida,
      'puntosVisionEstrategica': puntosVisionEstrategica,
      'puntosEducacionFinanciera': puntosEducacionFinanciera,
      'puntosActitudDeSuperacion': puntosActitudDeSuperacion,
      'puntosComunicacionAsertiva': puntosComunicacionAsertiva,
      'retosCounter': retosCounter,
      'retosInverseCounter': retosInverseCounter,
      'retosChecklist': retosChecklist,
      'retosQuestionnaire': retosQuestionnaire,
      'retosWriting': retosWriting,
      'retosRedNote': retosRedNote,
      'retosCrono': retosCrono,
      'retosTempo': retosTempo,
      'retosMath': retosMath,
      'retosSingle': retosSingle,
      'tiempoMedioCounter': tiempoMedioCounter,
      'tiempoMedioInverseCounter': tiempoMedioInverseCounter,
      'tiempoMedioChecklist': tiempoMedioChecklist,
      'tiempoMedioQuestionnaire': tiempoMedioQuestionnaire,
      'tiempoMedioWriting': tiempoMedioWriting,
      'tiempoMedioRedNote': tiempoMedioRedNote,
      'tiempoMedioCrono': tiempoMedioCrono,
      'tiempoMedioTempo': tiempoMedioTempo,
      'tiempoMedioMath': tiempoMedioMath,
      'tiempoMedioSingle': tiempoMedioSingle,
      'rachaTareas': rachaTareas,
      'rachaMaximaTareas': rachaMaximaTareas,
      'rachaRutinas': rachaRutinas,
      'rachaMaximaRutinas': rachaMaximaRutinas,
      'rachaRetosDiarios': rachaRetosDiarios,
      'rachaMaximaRetosDiarios': rachaMaximaRetosDiarios,
      'averageDailyPoints': averageDailyPoints,
      'averageCompletionTime': averageCompletionTime,
    };
  }
}
