import 'dart:convert';
import 'package:chat/models/usuario.dart';

/// Convierte cadena JSON o map a DailyTask
DailyTask dailyTaskFromJson(String str) {
  final Map<String, dynamic> jsonData = json.decode(str);
  final Map<String, dynamic> tareaData = jsonData['tarea'] is String
      ? jsonDecode(jsonData['tarea']) as Map<String, dynamic>
      : (jsonData['tarea'] as Map<String, dynamic>);
  return DailyTask.fromJson(tareaData);
}

String dailyTaskToJson(DailyTask data) => json.encode(data.toJson());

/// Submodelo para cada tarea individual
class Task {
  String title;
  String status;
  DateTime createdAt;
  DateTime? completedAt;
  bool? frog; // Cambiado de Bool? a bool?

  Task({
    required this.title,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.frog, // Añadido el nuevo campo
  });

factory Task.fromJson(Map<String, dynamic> json) => Task(
      title: json['title'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(), // Convertir a local
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String).toLocal() // Convertir a local
          : null,
      frog: json['frog'] as bool?,
    );

  Map<String, dynamic> toJson() => {
        'title': title,
        'status': status,
        'createdAt': createdAt.toUtc().toIso8601String(), // Guardar en UTC
        'completedAt': completedAt?.toUtc().toIso8601String(), // Guardar en UTC
        'frog': frog, // Incluido en el JSON de salida
      };
}

/// Modelo principal DailyTask
class DailyTask {
  final String id;
  final Usuario usuario;
  final DateTime fecha;
  final List<Task> tasks;

  DailyTask({
    required this.id,
    required this.usuario,
    required this.fecha,
    required this.tasks,
  });

  factory DailyTask.fromJson(Map<String, dynamic> json) {
    final userField = json['usuario'];
    final Usuario user = userField is String
        ? Usuario(online: false, nombre: '', email: '', uid: userField)
        : Usuario.fromJson(json['usuario'] as Map<String, dynamic>);

    // Convertir fecha UTC a local
    final utcFecha = DateTime.parse(json['fecha'] as String);
    final localFecha = utcFecha.toLocal();

    return DailyTask(
      id: (json['uid'] ?? json['_id']).toString(),
      usuario: user,
      fecha: localFecha, // Usamos la fecha convertida
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': id,
        'usuario': usuario.toJson(),
        'fecha': fecha.toIso8601String(),
        'tasks': tasks.map((e) => e.toJson()).toList(),
      };
}