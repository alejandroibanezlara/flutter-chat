import 'package:chat/models/microlearning.dart';
import 'package:chat/models/usuario.dart';

class MindsetEntry {
  final String texto;
  final String status;
  final int contador;
  final DateTime fecha;

  MindsetEntry({
    required this.texto,
    required this.status,
    required this.contador,
    required this.fecha,
  });

  factory MindsetEntry.fromJson(Map<String, dynamic> json) => MindsetEntry(
        texto: json['texto'],
        status: json['status'],
        contador: json['contador'],
        fecha: DateTime.parse(json['fecha']),
      );

  Map<String, dynamic> toJson() => {
        'texto': texto,
        'status': status,
        'contador': contador,
        'fecha': fecha.toIso8601String(),
      };
}

class SerInvencibleData {
  final String id;
  final Usuario usuario; // ← Antes era String
  final List<String> tools;
  final List<MindsetEntry> mindset;
  final List<MicroLearning> library;
  final DateTime createdAt;
  final DateTime updatedAt;

  SerInvencibleData({
    required this.id,
    required this.usuario,
    required this.tools,
    required this.mindset,
    required this.library,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SerInvencibleData.fromJson(Map<String, dynamic> json) =>
      SerInvencibleData(
        id: json['_id'],
        usuario: Usuario.fromJson(json['usuario']), // ← Aquí el cambio importante
        tools: List<String>.from(json['tools']),
        mindset: (json['mindset'] as List)
            .map((e) => MindsetEntry.fromJson(e))
            .toList(),
        library: (json['library'] as List)
            .map((e) => MicroLearning.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'usuario': usuario.toJson(),
        'tools': tools,
        'mindset': mindset.map((e) => e.toJson()).toList(),
        'library': library,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}