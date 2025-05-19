import 'dart:convert';
import 'package:chat/models/usuario.dart'; // Asumiendo que tienes un modelo Usuario

/// Convierte cadena JSON o map a Routine
Routine routineFromJson(String str) {
  final Map<String, dynamic> jsonData = json.decode(str);
  return Routine.fromJson(jsonData);
}

String routineToJson(Routine data) => json.encode(data.toJson());

/// Submodelo para Área
class Area {
  final String titulo;
  final String icono;

  Area({
    required this.titulo,
    required this.icono,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
        titulo: json['titulo'] as String,
        icono: json['icono'] as String,
      );

  Map<String, dynamic> toJson() => {
        'titulo': titulo,
        'icono': icono,
      };
}

/// Submodelo para Día Completado
class DiaCompletado {
  final DateTime fecha;
  final String status;
  final DateTime? horaCompletado;
  final String? comentarios;

  DiaCompletado({
    required this.fecha,
    required this.status,
    this.horaCompletado,
    this.comentarios,
  });

  factory DiaCompletado.fromJson(Map<String, dynamic> json) => DiaCompletado(
        fecha: DateTime.parse(json['fecha'] as String).toLocal(),
        status: json['status'] as String,
        horaCompletado: json['horaCompletado'] != null
            ? DateTime.parse(json['horaCompletado'] as String).toLocal()
            : null,
        comentarios: json['comentarios'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'fecha': fecha.toUtc().toIso8601String(),
        'status': status,
        'horaCompletado': horaCompletado?.toUtc().toIso8601String(),
        'comentarios': comentarios,
      };
}

/// Submodelo para Configuración de Notificación
class ConfigNotificacion {
  final bool activada;
  final int minutosAntes;
  final String? horaExacta;

  ConfigNotificacion({
    required this.activada,
    required this.minutosAntes,
    this.horaExacta,
  });
  
  factory ConfigNotificacion.fromJson(Map<String, dynamic> json) => ConfigNotificacion(
    activada: json['activada'] == true, // Siempre booleano
    minutosAntes: json['minutosAntes'] is int ? json['minutosAntes'] as int : 0,
    horaExacta: json['horaExacta']?.toString(), // Siempre String o null
  );

  Map<String, dynamic> toJson() {
    return {
      'activada': activada,
      'minutosAntes': minutosAntes,
      if (horaExacta != null) 'horaExacta': horaExacta,
    };
  }
}

/// Submodelo para Horario
class Horario {
  final String? horaInicio;
  final int? duracionMinutos;

  Horario({
    this.horaInicio,
    this.duracionMinutos,
  });

  factory Horario.fromJson(Map<String, dynamic> json) => Horario(
        horaInicio: json['horaInicio'] as String?,
        duracionMinutos: json['duracionMinutos'] as int?,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (horaInicio != null) data['horaInicio'] = horaInicio;
    if (duracionMinutos != null) data['duracionMinutos'] = duracionMinutos;
    return data;
  }
}

/// Submodelo para Metadata
class Metadata {
  final String creadoPor;
  final DateTime ultimaModificacion;

  Metadata({
    required this.creadoPor,
    required this.ultimaModificacion,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        creadoPor: json['creadoPor'] as String,
        ultimaModificacion: DateTime.parse(json['ultimaModificacion'] as String).toLocal(),
      );

  Map<String, dynamic> toJson() {
    return {
      'creadoPor': creadoPor,
      'ultimaModificacion': ultimaModificacion.toUtc().toIso8601String(),
    };
  }
}


/// Submodelo para Las Reglas de Repeticion
class ReglasRepeticion {
  final String tipo;
  final List<int>? diasSemana;
  final List<int>? diasMes;
  final List<int>? semanasMes;
  final DateTime? fechaFin;

  ReglasRepeticion({
    required this.tipo,
    this.diasSemana,
    this.diasMes,
    this.semanasMes,
    this.fechaFin,
  });

  factory ReglasRepeticion.fromJson(Map<String, dynamic> json) => ReglasRepeticion(
        tipo: json['tipo'] as String,
        diasSemana: (json['diasSemana'] as List<dynamic>?)?.cast<int>(),
        diasMes: (json['diasMes'] as List<dynamic>?)?.cast<int>(),
        semanasMes: (json['semanasMes'] as List<dynamic>?)?.cast<int>(),
        fechaFin: json['fechaFin'] != null
            ? DateTime.parse(json['fechaFin'] as String).toLocal()
            : null,
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'tipo': tipo,
    };
    if (diasSemana != null) data['diasSemana'] = diasSemana;
    if (diasMes   != null) data['diasMes']    = diasMes;
    if (semanasMes   != null) data['semanasMes']    = semanasMes;
    if (fechaFin  != null) data['fechaFin']   = fechaFin!.toUtc().toIso8601String();
    return data;
  }
}

/// Modelo principal Routine
class Routine {
  final String id;
  final String title;
  final String tiempoYlugar;
  final String tipoPersona;
  final String declaracionCompleta;
  final List<Area> areas;
  final int? icono;
  final String tipo;
  final List<int>? diasSemana;
  final List<int>? diasMes;
  final List<int>? semanasMes;
  final Horario? horario;
  final String status;
  final ConfigNotificacion configNotificacion;
  final List<DiaCompletado> diasCompletados;
  final Metadata metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReglasRepeticion reglasRepeticion;
  final List<DateTime>? proximosDias;

  Routine({
    required this.id,
    required this.title,
    required this.tiempoYlugar,
    required this.tipoPersona,
    required this.declaracionCompleta,
    required this.areas,
    this.icono,
    required this.tipo,
    this.diasSemana,
    this.diasMes,
    this.semanasMes,
    this.horario,
    required this.status,
    required this.configNotificacion,
    required this.diasCompletados,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    required this.reglasRepeticion,
    this.proximosDias,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'tiempoYlugar': tiempoYlugar,
      'tipoPersona': tipoPersona,
      'declaracionCompleta': declaracionCompleta,
      'areas': areas.map((e) => e.toJson()).toList(),
      'tipo': tipo,
      'status': status,
      'configNotificacion': configNotificacion.toJson(),
      'diasCompletados': diasCompletados.map((e) => e.toJson()).toList(),
      'metadata': metadata.toJson(),
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'reglasRepeticion': reglasRepeticion.toJson(),
    };

    // Manejo de campos opcionales
    if (icono != null) data['icono'] = icono.toString(); // <-- esto lo envía como String
    if (diasSemana != null) data['diasSemana'] = diasSemana;
    if (diasMes != null) data['diasMes'] = diasMes;
    if (semanasMes != null) data['semanasMes'] = semanasMes;
    if (horario != null) data['horario'] = horario!.toJson();

    return data;
  }

  // Actualiza el método fromJson() para manejar campos nulos
  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      tiempoYlugar: json['tiempoYlugar'] ?? '',
      tipoPersona: json['tipoPersona'] ?? '',
      declaracionCompleta: json['declaracionCompleta'] ?? '',
      areas: (json['areas'] as List<dynamic>? ?? [])
          .map((e) => Area.fromJson(e))
          .toList(),
      icono: json['icono'] != null ? int.tryParse(json['icono'].toString()) : null,
      tipo: json['tipo'] ?? 'personalizada',
      diasSemana: (json['diasSemana'] as List<dynamic>?)?.cast<int>(),
      diasMes: (json['diasMes'] as List<dynamic>?)?.cast<int>(),
      semanasMes: (json['semanasMes'] as List<dynamic>?)?.cast<int>(),
      horario: json['horario'] != null ? Horario.fromJson(json['horario']) : null,
      status: json['status'] ?? 'in-progress',
      configNotificacion: ConfigNotificacion.fromJson(json['configNotificacion'] ?? {}),
      diasCompletados: (json['diasCompletados'] as List<dynamic>? ?? [])
          .map((e) => DiaCompletado.fromJson(e))
          .toList(),
      metadata: Metadata.fromJson(json['metadata'] ?? {}),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']).toLocal()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt']).toLocal()
          : DateTime.now(),
      reglasRepeticion: ReglasRepeticion.fromJson(json['reglasRepeticion'] ?? {}),
      proximosDias: (json['cacheDias']?['proximosDias'] as List<dynamic>?)
        ?.map((s) => DateTime.parse(s as String).toLocal())
        .toList(),
    );
  }
}


class TiposRutina {
  static const semanal = 'semanal';
  static const mensual = 'mensual';
  static const personalizada = 'personalizada';

  static const List<String> values = [semanal, mensual, personalizada];
}

class StatusRutina {
  static const inProgress = 'in-progress';
  static const done = 'done';

  static const List<String> values = [inProgress, done];
}

class StatusDiaCompletado {
  static const completado = 'completado';
  static const pendiente = 'pendiente';
  static const omitido = 'omitido';
  static const parcial = 'parcial';

  static const List<String> values = [completado, pendiente, omitido, parcial];
}

class AreasDisponibles {
  static final List<Area> values = [
    Area(titulo: 'Empatía y Solidaridad', icono: 'group'),
    Area(titulo: 'Carisma', icono: 'face'),
    Area(titulo: 'Disciplina', icono: 'check'),
    Area(titulo: 'Organización', icono: 'assignment'),
    Area(titulo: 'Adaptabilidad', icono: 'autorenew'),
    Area(titulo: 'Imagen pulida', icono: 'image'),
    Area(titulo: 'Visión estratégica', icono: 'visibility'),
    Area(titulo: 'Educación financiera', icono: 'money'),
    Area(titulo: 'Actitud de superación', icono: 'trending_up'),
    Area(titulo: 'Comunicación asertiva', icono: 'chat'),
  ];
}