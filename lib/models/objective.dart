// lib/models/objetivo_personal.dart
import 'dart:convert';

import 'package:chat/models/ser_invencible_areas.dart';

/// Subesquema Progreso (0–100%)
class Progreso {
  final int porcentaje;
  final DateTime fecha;

  Progreso({required this.porcentaje, required this.fecha});

  factory Progreso.fromJson(Map<String, dynamic> json) => Progreso(
        porcentaje: json['porcentaje'] as int,
        fecha: DateTime.parse(json['fecha'] as String),
      );

  Map<String, dynamic> toJson() => {
        'porcentaje': porcentaje,
        'fecha': fecha.toIso8601String(),
      };
}

/// Subesquema Hito
class Hito {
  final String titulo;
  late DateTime fechaInicioHito;
  late DateTime fechaFinHito;
  bool completado = false;

  Hito({
    required this.titulo,
    required this.fechaInicioHito,
    required this.fechaFinHito,
    this.completado = false,
  });

  factory Hito.fromJson(Map<String, dynamic> json) => Hito(
        titulo: json['titulo'] as String,
        fechaInicioHito: DateTime.parse(json['fechaInicioHito'] as String),
        fechaFinHito: DateTime.parse(json['fechaFinHito'] as String),
        completado: json['completado'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'titulo': titulo,
        'fechaInicioHito': fechaInicioHito.toIso8601String(),
        'fechaFinHito': fechaFinHito.toIso8601String(),
        'completado': completado,
      };
}

/// Subesquema Nota
class Nota {
  final String texto;
  final DateTime fecha;

  Nota({required this.texto, required this.fecha});

  factory Nota.fromJson(Map<String, dynamic> json) => Nota(
        texto: json['texto'] as String,
        fecha: DateTime.parse(json['fecha'] as String),
      );

  Map<String, dynamic> toJson() => {
        'texto': texto,
        'fecha': fecha.toIso8601String(),
      };
}

/// Modelo principal Objetivo Personal
class ObjetivoPersonal {
  final String id;
  final String usuarioId;
  final String titulo;
  final int tipo;
  final String? descripcion;
  final String? beneficios;
  final DateTime fechaCreacion;
  final DateTime fechaObjetivo;
  final bool completado;
  final List<AreaSerInvencible> areaSerInvencible;
  final List<Progreso> progreso;
  final List<Hito> hitos;
  final List<Nota> notas;

  ObjetivoPersonal({
    this.id = '',
    required this.usuarioId,
    required this.titulo,
    required this.tipo,
    this.descripcion,
    this.beneficios,
    DateTime? fechaCreacion,
    required this.fechaObjetivo,
    this.completado = false,
    required this.areaSerInvencible,
    List<Progreso>? progreso,
    List<Hito>? hitos,
    List<Nota>? notas,
  })  : fechaCreacion = fechaCreacion ?? DateTime.now(),
        progreso = progreso ?? [],
        hitos = hitos ?? [],
        notas = notas ?? [];

  /// Convierte valor dinámico a int y lanza si es nulo o inválido
  static int _parseTipo(dynamic raw) {
    if (raw == null) {
      throw FormatException('El campo "tipo" está ausente en el JSON');
    }
    if (raw is int) return raw;
    final parsed = int.tryParse(raw.toString());
    if (parsed != null) return parsed;
    throw FormatException('Valor inválido para "tipo": $raw');
  }

  factory ObjetivoPersonal.fromJson(Map<String, dynamic> json) {
    final tipo = _parseTipo(json['tipo']);

    return ObjetivoPersonal(
      id: json['_id'] as String? ?? '',
      usuarioId: json['usuario'] as String,
      titulo: json['titulo'] as String,
      tipo: tipo,
      descripcion: json['descripcion'] as String?,
      beneficios: json['beneficios'] as String?,
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
      fechaObjetivo: DateTime.parse(json['fechaObjetivo'] as String),
      completado: json['completado'] as bool? ?? false,
      areaSerInvencible: (json['areaSerInvencible'] as List)
          .map((e) => AreaSerInvencible.fromJson(e as Map<String, dynamic>))
          .toList(),
      progreso: (json['progreso'] as List<dynamic>?)
              ?.map((e) => Progreso.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      hitos: (json['hitos'] as List<dynamic>?)
              ?.map((e) => Hito.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      notas: (json['notas'] as List<dynamic>?)
              ?.map((e) => Nota.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        if (id.isNotEmpty) '_id': id,
        'usuario': usuarioId,
        'titulo': titulo,
        'tipo': tipo,
        if (descripcion != null) 'descripcion': descripcion,
        if (beneficios != null) 'beneficios': beneficios,
        'fechaCreacion': fechaCreacion.toIso8601String(),
        'fechaObjetivo': fechaObjetivo.toIso8601String(),
        'completado': completado,
        'areaSerInvencible':
            areaSerInvencible.map((e) => e.toJson()).toList(),
        'progreso': progreso.map((e) => e.toJson()).toList(),
        'hitos': hitos.map((e) => e.toJson()).toList(),
        'notas': notas.map((e) => e.toJson()).toList(),
      };
}
