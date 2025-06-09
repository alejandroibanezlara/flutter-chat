import 'package:chat/models/ser_invencible_areas.dart';
import 'package:flutter/material.dart';


class MicroLearning {
  final String id;
  final String titulo;
  final String textoCorto;
  final String textoLargo;
  final String? icono;
  final String imagen;
  final int vecesSeleccionado;
  final DateTime createdAt;
  final DateTime updatedAt;
  final AreaSerInvencible? areaInvencibleObj;

  MicroLearning({
    required this.id,
    required this.titulo,
    required this.textoCorto,
    required this.textoLargo,
    this.icono,
    required this.imagen,
    required this.vecesSeleccionado,
    required this.createdAt,
    required this.updatedAt,
    this.areaInvencibleObj,
  });

factory MicroLearning.fromJson(Map<String, dynamic> json) => MicroLearning(
  id: json['_id'],
  titulo: json['titulo'],
  textoCorto: json['textoCorto'],
  textoLargo: json['textoLargo'],
  icono: json['icono'],
  imagen: json['imagen'],
  vecesSeleccionado: json['vecesSeleccionado'],
  createdAt: DateTime.parse(json['createdAt']),
  updatedAt: DateTime.parse(json['updatedAt']),
  areaInvencibleObj: json['areaInvencibleObj'] != null
    ? AreaSerInvencible.fromJson(json['areaInvencibleObj'] as Map<String, dynamic>)
    : null,
);

  

  Map<String, dynamic> toJson() => {
        '_id': id,
        'titulo': titulo,
        'textoCorto': textoCorto,
        'textoLargo': textoLargo,
        if (icono != null) 'icono': icono, // <- solo si existe
        'imagen': imagen,
        'vecesSeleccionado': vecesSeleccionado,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (areaInvencibleObj != null) 'areaInvencibleObj': areaInvencibleObj!.toJson(),
      };
}