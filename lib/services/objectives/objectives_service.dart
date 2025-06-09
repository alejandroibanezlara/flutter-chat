import 'dart:convert';
import 'package:chat/global/environment.dart';
import 'package:chat/models/objective.dart';
import 'package:chat/models/ser_invencible_areas.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Servicio para CRUD de ObjetivoPersonal y estado local de nombre/tipo
class ObjectivesService with ChangeNotifier {
  String? _nombre;
  int? _tipo;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  String? _beneficio;
  List<AreaSerInvencible>? _selectedAreas = [];

  /// Nombre del objetivo en edición
  String? get nombre => _nombre;

  /// Tipo de objetivo en edición (1, 3 o 5 años)
  int? get tipo => _tipo;

  /// Beneficios
  String? get beneficio => _beneficio;

  /// Fecha Inicio
  DateTime? get fechaInicio => _fechaInicio;

  /// Fecha Fin
  DateTime? get fechaFin => _fechaFin;

  /// Listado de areas
  List<AreaSerInvencible>? get selectedAreas => _selectedAreas;

  /// Asigna el nombre del objetivo y notifica a listeners
  void setNombre(String nombre) {
    _nombre = nombre;
    notifyListeners();
  }

  /// Asigna el tipo de objetivo (1, 3 o 5) y notifica a listeners
  void setTipo(int tipo) {
    _tipo = tipo;
    notifyListeners();
  }

  /// Asigna Beneficio
  void setBeneficio(String beneficio) {
    _beneficio = beneficio;
    notifyListeners();
  }

  /// Asigna Fecha Inicio
  void setFechaInicio(DateTime fechaInicio) {
    _fechaInicio = fechaInicio;
    notifyListeners();
  }

  /// Asigna Fecha Fin
  void setFechaFin(DateTime fechaFin) {
    _fechaFin = fechaFin;
    notifyListeners();
  }

  /// Asigna Áreas
  void setSerInvencibleAreas(List<AreaSerInvencible> areas) {
    _selectedAreas = areas;
    notifyListeners();
  }

  /// Marca un área como seleccionada
  void selectArea(AreaSerInvencible area) {
    if (!_selectedAreas!.contains(area)) {
      _selectedAreas!.add(area);
      notifyListeners();
    }
  }

  /// Desmarca un área
  void deselectArea(AreaSerInvencible area) {
    if (_selectedAreas!.remove(area)) {
      notifyListeners();
    }
  }

  /// Limpieza de datos
  void clear() {
    _nombre = null;
    _tipo = null;
    _fechaInicio = null;
    _fechaFin = null;
    _beneficio = null;
    _selectedAreas = [];
    notifyListeners();
  }

  /// Crea un nuevo objetivo personal
  Future<ObjetivoPersonal> createObjective() async {
    final url = Uri.parse('${Environment.apiUrl}/objectives');
    final token = await AuthService.getToken();

    final payload = {
      'titulo': _nombre,
      'tipo': _tipo,
      'beneficios': _beneficio,
      'areaSerInvencible': _selectedAreas!
          .map((a) => {'titulo': a.titulo, 'icono': a.icono})
          .toList(),
      'completado': false,
      'fechaCreacion': _fechaInicio!.toIso8601String(),
      'fechaObjetivo': _fechaFin!.toIso8601String(),
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final objJson = jsonData['objective'] as Map<String, dynamic>;
      return ObjetivoPersonal.fromJson(objJson);
    }

    throw Exception(
      'Error al crear Objective: ${response.statusCode} ${response.body}',
    );
  }

  /// Obtiene un único objetivo personal de un usuario por su ID
  Future<ObjetivoPersonal> getObjectiveByUserId(String userId) async {
    final url = Uri.parse('${Environment.apiUrl}/objectives/$userId');
    final token = await AuthService.getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final objJson = jsonData['objective'] as Map<String, dynamic>;
      return ObjetivoPersonal.fromJson(objJson);
    } else if (response.statusCode == 404) {
      throw Exception('Objetivo no encontrado para el usuario $userId');
    }

    throw Exception(
      'Error al obtener Objective: ${response.statusCode} ${response.body}',
    );
  }

  /// Obtiene todos los objetivos de un usuario
Future<List<ObjetivoPersonal>> getObjectivesByUser(String userId) async {
  final url = Uri.parse('${Environment.apiUrl}/objectives/$userId');
  final token = await AuthService.getToken();

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'x-token': token,
    },
  );

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    List<dynamic> listJson;

    // Si el backend devuelve un array directamente:
    if (decoded is List) {
      listJson = decoded;
    }
    // Si viene envuelto en 'objective' (clave singular):
    else if (decoded is Map<String, dynamic> && decoded['objective'] is List) {
      listJson = decoded['objective'] as List<dynamic>;
    }
    // Si viene envuelto en 'objectives' (clave plural):
    else if (decoded is Map<String, dynamic> && decoded['objectives'] is List) {
      listJson = decoded['objectives'] as List<dynamic>;
    } else {
      // Ningún formato esperado → vacío
      return [];
    }

    return listJson
        .map((obj) => ObjetivoPersonal.fromJson(obj as Map<String, dynamic>))
        .toList();
  }

  throw Exception(
    'Error al obtener Objectives: ${response.statusCode} ${response.body}',
  );
}

  /// Actualiza un objetivo personal existente (PATCH) usando su ID
  Future<ObjetivoPersonal> updateObjectiveById(String objectiveId) async {
    final url = Uri.parse('${Environment.apiUrl}/objectives/$objectiveId');
    final token = await AuthService.getToken();

    // Construye el payload con los campos que quieras actualizar
    final payload = {
      if (_nombre != null) 'titulo': _nombre,
      if (_tipo != null) 'tipo': _tipo,
      if (_beneficio != null) 'beneficios': _beneficio,
      if (_fechaInicio != null) 'fechaCreacion': _fechaInicio!.toIso8601String(),
      if (_fechaFin != null) 'fechaObjetivo': _fechaFin!.toIso8601String(),
      if (_selectedAreas != null)
        'areaSerInvencible': _selectedAreas!
            .map((a) => {'titulo': a.titulo, 'icono': a.icono})
            .toList(),
    };

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      // Según tu API, el objeto puede venir en 'objective' o en la raíz
      final objJson = (jsonData['objective'] ?? jsonData) as Map<String, dynamic>;
      return ObjetivoPersonal.fromJson(objJson);
    }

    throw Exception(
      'Error al actualizar Objective: ${response.statusCode} ${response.body}',
    );
  }

  Future<void> updateObjectiveMilestones(String objectiveId, List<Hito> hitos) async {
  final url = Uri.parse('${Environment.apiUrl}/objectives/$objectiveId');
  final token = await AuthService.getToken();

  // Prepara el payload con la lista completa de hitos
  final payload = {
    'hitos': hitos.map((h) => {
      'titulo': h.titulo,
      'fechaInicioHito': h.fechaInicioHito.toIso8601String(),
      'fechaFinHito':    h.fechaFinHito.toIso8601String(),
      'completado':      h.completado,
    }).toList(),
  };

  final response = await http.patch(
    url,
    headers: {
      'Content-Type': 'application/json',
      'x-token': token,
    },
    body: jsonEncode(payload),
  );

  if (response.statusCode != 200) {
    throw Exception('Error al actualizar hitos: ${response.statusCode} ${response.body}');
  }
}

  /// Elimina un objetivo personal dado el ID de usuario y el ID del objetivo
  Future<void> deleteObjective(String objectiveId, String userId, ) async {
    final url = Uri.parse('${Environment.apiUrl}/objectives/$objectiveId/$userId');
    final token = await AuthService.getToken();

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    // Decodificar siempre la respuesta para mensajes de error
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      if (data['ok'] == true) {
        // Eliminación correcta
        return;
      } else {
        throw Exception('No se eliminó el objetivo: ${data['msg'] ?? 'Error desconocido'}');
      }
    } else if (response.statusCode == 404) {
      throw Exception('Objetivo no encontrado: ${data['msg'] ?? objectiveId}');
    } else {
      throw Exception(
        'Error al eliminar objetivo (HTTP ${response.statusCode}): ${data['msg'] ?? response.body}',
      );
    }
  }


}
