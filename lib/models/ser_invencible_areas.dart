
import 'package:flutter/material.dart';

/// Área de la vida
class AreaSerInvencible {
  final String titulo;
  final String icono;

  const AreaSerInvencible({required this.titulo, required this.icono});

  factory AreaSerInvencible.fromJson(Map<String, dynamic> json) => AreaSerInvencible(
        titulo: json['titulo'] as String,
        icono: json['icono'].toString(), // <- CORREGIDO AQUÍ
      );

  Map<String, dynamic> toJson() => {
        'titulo': titulo,
        'icono': icono,
      };
}



/// Lista de áreas “Ser Invencible”
final List<AreaSerInvencible> serInvencibleAreas = [
    AreaSerInvencible(titulo: 'Empatía y Solidaridad' , icono: Icons.group.codePoint.toString()),
    AreaSerInvencible(titulo: 'Carisma'               , icono: Icons.face.codePoint.toString()),
    AreaSerInvencible(titulo: 'Disciplina'            , icono: Icons.check.codePoint.toString()),
    AreaSerInvencible(titulo: 'Organización'          , icono: Icons.assignment.codePoint.toString()),
    AreaSerInvencible(titulo: 'Adaptabilidad'         , icono: Icons.autorenew.codePoint.toString()),
    AreaSerInvencible(titulo: 'Imagen pulida'         , icono: Icons.image.codePoint.toString()),
    AreaSerInvencible(titulo: 'Visión estratégica'    , icono: Icons.visibility.codePoint.toString()),
    AreaSerInvencible(titulo: 'Educación financiera'  , icono: Icons.money.codePoint.toString()),
    AreaSerInvencible(titulo: 'Actitud de superación' , icono: Icons.trending_up.codePoint.toString()),
    AreaSerInvencible(titulo: 'Comunicación asertiva' , icono: Icons.chat.codePoint.toString()),
];

