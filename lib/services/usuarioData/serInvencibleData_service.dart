import 'dart:convert';
import 'package:chat/models/serInvencibleData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat/global/environment.dart';
import 'package:chat/services/auth_service.dart';

class SerInvencibleService with ChangeNotifier {
  SerInvencibleData? _data;

  SerInvencibleData? get data => _data;

  /// Recuperar o crear (upsert) los datos del usuario autenticado
  Future<SerInvencibleData> createOrGetData() async {
    final url = Uri.parse('${Environment.apiUrl}/serinvencible/');
    final token = await AuthService.getToken();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    final jsonData = jsonDecode(response.body);
    if (response.statusCode == 201 && jsonData['success'] == true) {
      _data = SerInvencibleData.fromJson(jsonData['data']);
      notifyListeners();
      return _data!;
    } else {
      throw Exception('Error al crear/obtener datos: ${response.body}');
    }
  }

  /// Obtener datos por ID del usuario
  Future<SerInvencibleData> getDataByUserId(String idUsuario) async {
    final url = Uri.parse('${Environment.apiUrl}/serinvencible/$idUsuario');
    final token = await AuthService.getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonData['success'] == true) {
      _data = SerInvencibleData.fromJson(jsonData['data']);
      notifyListeners();
      return _data!;
    } else {
      throw Exception('Error al obtener datos del usuario: ${response.body}');
    }
  }

  /// Actualizar datos parciales (solo campos válidos como mindset)
  Future<SerInvencibleData> updateDataMindset(String idUsuario, Map<String, dynamic> payload) async {
    final url = Uri.parse('${Environment.apiUrl}/serinvencible/$idUsuario');
    final token = await AuthService.getToken();

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
      body: jsonEncode(payload),
    );
    // Si el backend devuelve vacío o no JSON, prevenir fallo
    if (response.body.isEmpty) {
      throw Exception('El backend devolvió una respuesta vacía.');
    }

    late final Map<String, dynamic> jsonData;
    try {
      jsonData = jsonDecode(response.body);
    } catch (e) {
      throw Exception('La respuesta no es JSON válido: ${response.body}');
    }

    if (response.statusCode == 200 && jsonData['success'] == true) {
      _data = SerInvencibleData.fromJson(jsonData['data']);
      notifyListeners();
      return _data!;
    } else {
      throw Exception('Error al actualizar mindset: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> updateMindsetByReplacing(String uid, {
    required String oldText,
    required String newText,
  }) async {
    final url = Uri.parse('${Environment.apiUrl}/serinvencible/$uid/mindset/update');
    final token = await AuthService.getToken();

    final payload = {
      'oldText': oldText,
      'newText': newText,
    };

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
      body: jsonEncode(payload),
    );

    final jsonData = jsonDecode(response.body);

    if (response.statusCode != 200 || jsonData['success'] != true) {
      throw Exception('Error al actualizar frase: ${jsonData['message']}');
    }
  }


  Future<void> removeMindsetByText(String uid, String texto) async {
    final url = Uri.parse('${Environment.apiUrl}/serinvencible/$uid/mindset');
    final token = await AuthService.getToken();

    final request = http.Request("DELETE", url)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'x-token': token,
      })
      ..body = jsonEncode({'texto': texto});

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final jsonData = jsonDecode(response.body);

    if (response.statusCode != 200 || jsonData['success'] != true) {
      throw Exception('Error al eliminar frase: ${jsonData['message']}');
    }
  }

  /// Eliminar completamente los datos del usuario
  Future<void> deleteData(String idUsuario) async {
    final url = Uri.parse('${Environment.apiUrl}/serinvencible/$idUsuario');
    final token = await AuthService.getToken();

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar datos: ${response.body}');
    }

    _data = null;
    notifyListeners();
  }

  /// Añadir una Tool
  Future<SerInvencibleData> addTool(String idUsuario, String toolId) async {
    final url = Uri.parse('${Environment.apiUrl}/serinvencible/$idUsuario/tools/$toolId');
    final token = await AuthService.getToken();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    final jsonData = jsonDecode(response.body);
    if (response.statusCode == 200 && jsonData['success'] == true) {
      _data = SerInvencibleData.fromJson(jsonData['data']);
      notifyListeners();
      return _data!;
    } else {
      throw Exception('Error al añadir Tool: ${response.body}');
    }
  }

  /// Quitar una Tool
  Future<SerInvencibleData> removeTool(String idUsuario, String toolId) async {
    final url = Uri.parse('${Environment.apiUrl}/serinvencible/$idUsuario/tools/$toolId');
    final token = await AuthService.getToken();

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    final jsonData = jsonDecode(response.body);
    if (response.statusCode == 200 && jsonData['success'] == true) {
      _data = SerInvencibleData.fromJson(jsonData['data']);
      notifyListeners();
      return _data!;
    } else {
      throw Exception('Error al quitar Tool: ${response.body}');
    }
  }

  /// Añadir microlearning a la biblioteca
  Future<SerInvencibleData> addLibraryItem(String idUsuario, String mlId) async {
    final url = Uri.parse('${Environment.apiUrl}/serinvencible/$idUsuario/library/$mlId');
    final token = await AuthService.getToken();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonData['success'] == true) {
      _data = SerInvencibleData.fromJson(jsonData['data']);
  
      notifyListeners();
      return _data!;
    } else {
      throw Exception('Error al añadir microlearning: ${response.body}');
    }
  }

  /// Quitar microlearning
  Future<SerInvencibleData> removeLibraryItem(String idUsuario, String mlId) async {
    final url = Uri.parse('${Environment.apiUrl}/serinvencible/$idUsuario/library/$mlId');
    final token = await AuthService.getToken();

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    final jsonData = jsonDecode(response.body);
    if (response.statusCode == 200 && jsonData['success'] == true) {
      _data = SerInvencibleData.fromJson(jsonData['data']);
      notifyListeners();
      return _data!;
    } else {
      throw Exception('Error al quitar microlearning: ${response.body}');
    }
  }
}