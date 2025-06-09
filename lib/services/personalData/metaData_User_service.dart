import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chat/global/environment.dart';
import 'package:chat/models/metaData_User.dart';
import 'package:chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

/// Servicio para consumir la API de MetaDataUser
class MetaDataUserService with ChangeNotifier {
  final String _baseUrl = '${Environment.apiUrl}/metaDataUser';
  MetaDataUser? _metaData;
  int? pendingTasks;
  int? completedTasks;
  int? pendingRoutines;
  int? completedRoutines;
  /// Acceso de solo lectura al último MetaDataUser obtenido
  MetaDataUser? get metaData => _metaData;








  /// Construye los headers incluyendo el token de autenticación
  Future<Map<String, String>> _headers() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'x-token': token,
    };
  }

  /// Upsert: crea o devuelve
  Future<MetaDataUser> createOrGet() async {
    final url = Uri.parse('$_baseUrl');
    final resp = await http.post(url, headers: await _headers());
    if (resp.statusCode == 201) {
    final data = json.decode(resp.body)['MetaDataUser'] as Map<String,dynamic>;
      _metaData = MetaDataUser.fromJson(data);
      notifyListeners();
      return _metaData!;
    }
    throw Exception('Error ${resp.statusCode}: ${resp.body}');
  }

  /// Obtener completo
  Future<MetaDataUser> getStats(String userId) async {
    final url = Uri.parse('$_baseUrl/$userId');
    final resp = await http.get(url, headers: await _headers());
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body)['MetaDataUser'] as Map<String,dynamic>;
      _metaData = MetaDataUser.fromJson(data);
      notifyListeners();
      return _metaData!;
    }
    throw Exception('Error ${resp.statusCode}: ${resp.body}');
  }

  /// Obtener versión ligera
  Future<MetaDataUser> getStatsLight(String userId) async {
    final url = Uri.parse('$_baseUrl/$userId/light');
    final resp = await http.get(url, headers: await _headers());
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body)['MetaDataUser'] as Map<String,dynamic>;
      _metaData = MetaDataUser.fromJson(data);
      notifyListeners();
      return _metaData!;
    }
    throw Exception('Error ${resp.statusCode}: ${resp.body}');
  }


  /// En MetaDataUserService (lib/services/personalData/metaData_User_service.dart)
  /// Actualiza múltiples campos usando el endpoint PATCH genérico.
  Future<MetaDataUser> updateFields({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    final url = Uri.parse('$_baseUrl/$userId');
    final resp = await http.patch(
      url,
      headers: await _headers(),
      body: json.encode(data),
    );
    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body)['MetaDataUser'] as Map<String, dynamic>;
      _metaData = MetaDataUser.fromJson(jsonData);
      notifyListeners();
      return _metaData!;
    }
    throw Exception('Error ${resp.statusCode}: ${resp.body}');
  }

  /// Agregar fecha única
  Future<MetaDataUser> addDate({
    required String userId,
    required String field,
    required DateTime date,
  }) async {
    final url = Uri.parse('$_baseUrl/$userId/$field');
    final body = json.encode({'date': date.toIso8601String()});
    final resp = await http.patch(url, headers: await _headers(), body: body);
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body)['MetaDataUser'] as Map<String,dynamic>;
      _metaData = MetaDataUser.fromJson(data);
      notifyListeners();
      return _metaData!;
    }
    throw Exception('Error ${resp.statusCode}: ${resp.body}');
  }

  /// Set valor numérico
  Future<MetaDataUser> setNumber({
    required String userId,
    required String field,
    required int value,
  }) async {
    final url = Uri.parse('$_baseUrl/$userId/$field');
    final body = json.encode({'value': value});
    final resp = await http.patch(url, headers: await _headers(), body: body);
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body)['MetaDataUser'] as Map<String,dynamic>;
      _metaData = MetaDataUser.fromJson(data);
      notifyListeners();
      return _metaData!;
    }
    throw Exception('Error ${resp.statusCode}: ${resp.body}');
  }

  /// Incrementar contador
  Future<MetaDataUser> incNumber({
    required String userId,
    required String field,
    required int delta,
  }) async {
    final url = Uri.parse('$_baseUrl/$userId/inc/$field');
    final body = json.encode({'delta': delta});
    final resp = await http.patch(url, headers: await _headers(), body: body);
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body)['MetaDataUser'] as Map<String,dynamic>;
      _metaData = MetaDataUser.fromJson(data);
      notifyListeners();
      return _metaData!;
    }
    throw Exception('Error ${resp.statusCode}: ${resp.body}');
  }

  /// Set valor double (tiempos medios)
  Future<MetaDataUser> setDouble({
    required String userId,
    required String field,
    required double value,
  }) async {
    final url = Uri.parse('$_baseUrl/$userId/$field');
    final body = json.encode({'value': value});
    final resp = await http.patch(url, headers: await _headers(), body: body);
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body)['MetaDataUser'] as Map<String,dynamic>;
      _metaData = MetaDataUser.fromJson(data);
      notifyListeners();
      return _metaData!;
    }
    throw Exception('Error ${resp.statusCode}: ${resp.body}');
  }

  /// Eliminar stats
  Future<void> deleteStats(String userId) async {
    final url = Uri.parse('$_baseUrl/$userId');
    final resp = await http.delete(url, headers: await _headers());
    if (resp.statusCode == 204) {
      _metaData = null;
      notifyListeners();
      return;
    }
    throw Exception('Error ${resp.statusCode}: ${resp.body}');
  }

  /// Establece un campo de tipo Date (no array) usando el endpoint PATCH genérico
  Future<MetaDataUser> setDateField({
    required String userId,
    required String field,
    required DateTime date,
  }) async {
    final url = Uri.parse('$_baseUrl/$userId');
    final body = json.encode({ field: date.toIso8601String() });
    final resp = await http.patch(url, headers: await _headers(), body: body);
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body)['MetaDataUser'] as Map<String,dynamic>;
      _metaData = MetaDataUser.fromJson(data);
      notifyListeners();
      return _metaData!;
    }
    throw Exception('Error ${resp.statusCode}: ${resp.body}');
  }

}