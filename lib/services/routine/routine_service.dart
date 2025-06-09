import 'package:chat/models/routine.dart';
import 'dart:convert'; // ✅ Importación necesaria para jsonEncode
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat/global/environment.dart';


class RoutineService with ChangeNotifier {
  Future<Routine> createRoutine(Routine routine) async {
    final url = Uri.parse('${Environment.apiUrl}/routines');
    
    // Convertir a mapa y eliminar claves con valor null
    final routineMap = routine.toJson()..removeWhere((key, value) => value == null);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken(),
      },
      body: jsonEncode(routineMap),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final rutinaJson = jsonData['rutina']; // Solo extrae la rutina
      return Routine.fromJson(rutinaJson);   // <-- y aquí ya parsea bien
    } else {
      throw Exception('Failed to create routine: ${response.body}');
    }
  }


  Future<List<Routine>> getRoutinesByStatus(String status) async {
    final url = Uri.parse('${Environment.apiUrl}/routines?status=$status');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken(),
    });

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return (decoded['rutinas'] as List)
          .map((item) => Routine.fromJson(item))
          .toList();
    } else {
      throw Exception('Error al cargar rutinas: ${response.body}');
    }
  }


    static Future<Routine> updateRoutine(String routineId, Map<String, dynamic> updatedData) async {
    final url = Uri.parse('${Environment.apiUrl}/routines/$routineId');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken(),
      },
      body: json.encode(updatedData),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return Routine.fromJson(decoded['rutina']);
    } else {
      throw Exception('Error al actualizar rutina: ${response.body}');
    }
  }


  static Future<void> deleteRoutine(String routineId) async {
  final url = Uri.parse('${Environment.apiUrl}/routines/$routineId');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken(),
      },
      body: jsonEncode({'status': 'inactive'}),
    );

    if (response.statusCode != 200) {
      final decoded = jsonDecode(response.body);
      throw Exception('Error al eliminar rutina: ${decoded['msg']}');
    }
  }

  Future<List<DateTime>> getNextDays(String id) async {
    final resp = await http.get(Uri.parse('${Environment.apiUrl}/routines/$id/proximos-dias'));
    if (resp.statusCode != 200) throw Exception('Error cargando próximos días');
    final List<dynamic> list = json.decode(resp.body);
    return list.map((s) => DateTime.parse(s as String).toLocal()).toList();
  }
}