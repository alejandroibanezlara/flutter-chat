import 'dart:convert';
import 'package:chat/models/usuario.dart';

/// Convierte cadena JSON o Map a PersonalData
PersonalData personalDataFromJson(String str) {
  final Map<String, dynamic> jsonData = json.decode(str);
  return PersonalData.fromJson(jsonData);
}

String personalDataToJson(PersonalData data) => json.encode(data.toJson());

/// Submodelo genérico para valoraciones con nota y fecha
class Rating {
  final int nota;
  final DateTime fecha;

  Rating({
    required this.nota,
    required this.fecha,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        nota: json['nota'] as int,
        fecha: DateTime.parse(json['fecha'] as String).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        'nota': nota,
        'fecha': fecha.toUtc().toIso8601String(),
      };
}

/// Submodelo para día completado
class DiaCompletado {
  final bool completado;
  final DateTime fecha;

  DiaCompletado({
    required this.completado,
    required this.fecha,
  });

  factory DiaCompletado.fromJson(Map<String, dynamic> json) => DiaCompletado(
        completado: json['completado'] as bool,
        fecha: DateTime.parse(json['fecha'] as String).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        'completado': completado,
        'fecha': fecha.toUtc().toIso8601String(),
      };
}

/// Submodelo para mantra
class Mantra {
  final String texto;
  final int vecesSeleccionado;

  Mantra({
    required this.texto,
    required this.vecesSeleccionado,
  });

  factory Mantra.fromJson(Map<String, dynamic> json) => Mantra(
        texto: json['texto'] as String,
        vecesSeleccionado: json['vecesSeleccionado'] as int,
      );

  Map<String, dynamic> toJson() => {
        'texto': texto,
        'vecesSeleccionado': vecesSeleccionado,
      };
}

/// Modelo principal PersonalData
class PersonalData {
  final String id;
  final Usuario usuario;
  final List<Rating> calidadSueno;
  final List<Rating> actitudInicial;
  final List<Rating> actitudFinal;
  final List<DiaCompletado>? diaCompletado;
  final List<Mantra> mantras;
  final String? mantraFavorito;
  final int? contadorRetosDia;
  final int? contadorRetosSemana;
  final int? contadorRetosMes;
  final int? contadorRetosDestacados;
  final int rachaActual;
  final int rachaMaxima;
  final List<String>? cardsAleatorias;
  final DateTime usuarioCreado;
  final bool cambioSolicitado;
  final bool cambioConfirmado;
  final bool notificacionesActivadas;
  final String planActual;
  final bool tutorialVisto;
  final bool preguntasInicialesRespondidas;
  final bool cuadernoRojoComprado;
  final DateTime? inicioDia;                // Hora al iniciar el día
  final DateTime? finJornada;               // Hora al finalizar la jornada
  final DateTime? picoEnergia;              // Hora de máxima energía
  final bool? rutinaDiaria;                  // ¿Tiene rutina diaria establecida?
  final bool? actividadFisica;               // ¿Practica deporte o actividad?
  final String? genero;                     // Hombre/Mujer/Prefiero no decirlo
  final String? tiempoReflexion;            // 15 mins / 30 mins / más de 1h
  final String? prefAprendizaje;            // Leyendo / Escuchando / Viendo vídeos
  final String? nivelDisciplina;            // Alta / Media / Baja
  final String? satisfaccionActual;         // Muy satisfecho / Algo satisfecho / Poco satisfecho
  final DateTime? fechaCuestionarioInicial; // Fecha en que completó el cuestionario

  PersonalData({
    required this.id,
    required this.usuario,
    required this.calidadSueno,
    required this.actitudInicial,
    required this.actitudFinal,
    this.diaCompletado,
    required this.mantras,
    this.mantraFavorito,
    this.contadorRetosDia,
    this.contadorRetosSemana,
    this.contadorRetosMes,
    this.contadorRetosDestacados,
    required this.rachaActual,
    required this.rachaMaxima,
    this.cardsAleatorias,
    required this.usuarioCreado,
    required this.cambioSolicitado,
    required this.cambioConfirmado,
    required this.notificacionesActivadas,
    required this.planActual,
    required this.tutorialVisto,
    required this.preguntasInicialesRespondidas,
    required this.cuadernoRojoComprado,
        // ——— Cuestionario inicial ———
    this.inicioDia,
    this.finJornada,
    this.picoEnergia,
    this.rutinaDiaria,
    this.actividadFisica,
    this.genero,
    this.tiempoReflexion,
    this.prefAprendizaje,
    this.nivelDisciplina,
    this.satisfaccionActual,
    this.fechaCuestionarioInicial,
  });


  factory PersonalData.fromJson(Map<String, dynamic> json) {
    // Procesa el campo usuario, puede venir como String ID o JSON completo
    final userField = json['usuario'];
    final Usuario user = userField is String
        ? Usuario(online: false, nombre: '', email: '', uid: userField)
        : Usuario.fromJson(json['usuario'] as Map<String, dynamic>);

    return PersonalData(
      id: (json['uid'] ?? json['_id']).toString(),
      usuario: user,
      calidadSueno: (json['calidadSueno'] as List<dynamic>?)
              ?.map((e) => Rating.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
      actitudInicial: (json['actitudInicial'] as List<dynamic>?)
              ?.map((e) => Rating.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
      actitudFinal: (json['actitudFinal'] as List<dynamic>?)
              ?.map((e) => Rating.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
      diaCompletado: (json['diaCompletado'] as List<dynamic>?)
              ?.map((e) => DiaCompletado.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
      mantras: (json['mantras'] as List<dynamic>?)
              ?.map((e) => Mantra.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
      mantraFavorito: json['mantraFavorito'] as String?,
      contadorRetosDia: json['contadorRetosDia'] as int? ?? 0,
      contadorRetosSemana: json['contadorRetosSemana'] as int? ?? 0,
      contadorRetosMes: json['contadorRetosMes'] as int? ?? 0,
      contadorRetosDestacados: json['contadorRetosDestacados'] as int? ?? 0,
      rachaActual: json['rachaActual'] as int? ?? 0,
      rachaMaxima: json['rachaMaxima'] as int? ?? 0,
      cardsAleatorias: List<String>.from(json['cardsAleatorias'] ?? []),
      usuarioCreado: json['usuarioCreado'] != null
          ? DateTime.tryParse(json['usuarioCreado'] as String) ?? DateTime.now()
          : DateTime.now(),
      cambioSolicitado: json['cambioSolicitado'] ?? false,
      cambioConfirmado: json['cambioConfirmado'] ?? false,
      notificacionesActivadas: json['notificacionesActivadas'] ?? true,
      planActual: json['planActual'] ?? 'inicial',
      tutorialVisto: json['tutorialVisto'] ?? false,
      preguntasInicialesRespondidas: json['preguntasInicialesRespondidas'] ?? false,
      cuadernoRojoComprado: json['cuadernoRojoComprado'] ?? false,
            inicioDia: json['inicioDia'] != null
          ? DateTime.parse(json['inicioDia'] as String).toLocal()
          : null,
      finJornada: json['finJornada'] != null
          ? DateTime.parse(json['finJornada'] as String).toLocal()
          : null,
      picoEnergia: json['picoEnergia'] != null
          ? DateTime.parse(json['picoEnergia'] as String).toLocal()
          : null,
      rutinaDiaria: json['rutinaDiaria'] as bool? ?? false,
      actividadFisica: json['actividadFisica'] as bool? ?? false,
      genero: json['genero'] as String?,
      tiempoReflexion: json['tiempoReflexion'] as String?,
      prefAprendizaje: json['prefAprendizaje'] as String?,
      nivelDisciplina: json['nivelDisciplina'] as String?,
      satisfaccionActual: json['satisfaccionActual'] as String?,
      fechaCuestionarioInicial: json['fechaCuestionarioInicial'] != null
          ? DateTime.parse(json['fechaCuestionarioInicial'] as String).toLocal()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': id,
        'usuario': usuario.toJson(),
        'calidadSueno': calidadSueno.map((e) => e.toJson()).toList(),
        'actitudInicial': actitudInicial.map((e) => e.toJson()).toList(),
        'actitudFinal': actitudFinal.map((e) => e.toJson()).toList(),
        'diaCompletado': (diaCompletado ?? []).map((e) => e.toJson()).toList(),
        'mantras': mantras.map((e) => e.toJson()).toList(),
        'mantraFavorito': mantraFavorito,
        'contadorRetosDia': contadorRetosDia,
        'contadorRetosSemana': contadorRetosSemana,
        'contadorRetosMes': contadorRetosMes,
        'contadorRetosDestacados': contadorRetosDestacados,
        'rachaActual': rachaActual,
        'rachaMaxima': rachaMaxima,
        'cardsAleatorias': cardsAleatorias,
        'usuarioCreado': usuarioCreado,
        'cambioSolicitado': cambioSolicitado,
        'cambioConfirmado': cambioConfirmado,
        'notificacionesActivadas': notificacionesActivadas,
        'planActual': planActual,
        'tutorialVisto': tutorialVisto,
        'preguntasInicialesRespondidas': preguntasInicialesRespondidas,
        'cuadernoRojoComprado': cuadernoRojoComprado,
                // ——— Cuestionario inicial ———
        'inicioDia': inicioDia?.toUtc().toIso8601String(),
        'finJornada': finJornada?.toUtc().toIso8601String(),
        'picoEnergia': picoEnergia?.toUtc().toIso8601String(),
        'rutinaDiaria': rutinaDiaria,
        'actividadFisica': actividadFisica,
        'genero': genero,
        'tiempoReflexion': tiempoReflexion,
        'prefAprendizaje': prefAprendizaje,
        'nivelDisciplina': nivelDisciplina,
        'satisfaccionActual': satisfaccionActual,
        'fechaCuestionarioInicial': fechaCuestionarioInicial?.toUtc().toIso8601String(),
                
      };
}