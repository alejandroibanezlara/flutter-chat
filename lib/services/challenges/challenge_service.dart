import 'dart:convert';
import 'package:chat/services/challenges/user_challenge_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat/global/environment.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/models/challenge.dart';  // Tu modelo Dart

class ChallengeService with ChangeNotifier {
  final _baseUrl = '${Environment.apiUrl}/challenge';
  // Aquí podrías exponer una lista interna y notificar listeners cuando cambie:
  List<Challenge> _challenges = [];
  List<Challenge> get challenges => _challenges;
  late UserChallengeService _ucService;

  // Recibimos el UserChallengeService por DI
  ChallengeService(this._ucService);


    /// Llamado por ChangeNotifierProxyProvider cuando cambia _ucService
    void updateUserChallengeService(UserChallengeService newUc) {
      _ucService = newUc;
      // ← ¡Aquí NO debes llamar a getByTimePeriod!
      // getByTimePeriod('daily'); <— BORRAR O COMENTAR ESTA LÍNEA
    }


  Future<Map<String, String>> _headers() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'x-token': token ?? '',
    };
  }

  Future<List<Challenge>> getAll() async {
    final url  = Uri.parse('$_baseUrl');
    final resp = await http.get(url, headers: await _headers());
    if (resp.statusCode == 200) {
      final body    = json.decode(resp.body) as Map<String, dynamic>;
      final rawList = body['retos'] as List<dynamic>;
      _challenges = rawList
          .map((e) => Challenge.fromJson(e as Map<String, dynamic>))
          .toList();
      notifyListeners();
      return _challenges;
    }
    throw Exception('Error cargando retos: ${resp.body}');
  }

  /// Nuevo método: filtra por timePeriod
/// Nuevo método: filtra por timePeriod y estado ‘activa’
  /// Filtra por timePeriod y status=active, y excluye retos ya iniciados/completados
  Future<List<Challenge>> getByTimePeriod(String timePeriod) async {
    // 1) Aseguramos tener la lista de UserChallenges del usuario
    await _ucService.getUserChallenges();
    final enCursoIds = _ucService.items
        .map((uc) => uc.challengeId)
        .toSet();

    // 2) Llamada al backend con filtros timePeriod y status
    final url = Uri.parse('$_baseUrl?timePeriod=$timePeriod&status=active');
    final resp = await http.get(url, headers: await _headers());

    if (resp.statusCode != 200) {
      throw Exception('Error cargando retos "$timePeriod": ${resp.body}');
    }

    // 3) Mapear respuesta y filtrar
    final decoded = json.decode(resp.body) as Map<String, dynamic>;
    final lista   = decoded['retos'] as List<dynamic>;

    _challenges = lista
      .map((json) => Challenge.fromJson(json as Map<String, dynamic>))
      // Sólo status active (redundante si el backend lo respeta)
      .where((c) => c.status == 'active')
      // Excluimos los retos que ya están en UserChallenge
      .where((c) => !enCursoIds.contains(c.id))
      .toList();

    notifyListeners();
    return _challenges;
  }


  Future<Challenge> getById(String id) async {
    final url = Uri.parse('$_baseUrl/$id');
    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken(),
    });
    if (resp.statusCode == 200) {
      return Challenge.fromJson(json.decode(resp.body)['reto']);
    }
    throw Exception('Reto no encontrado: ${resp.body}');
  }

  Future<Challenge> create(Challenge c) async {
    final url = Uri.parse('$_baseUrl');
    final map = c.toJson()..removeWhere((k, v) => v == null);
    final resp = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken(),
      },
      body: jsonEncode(map),
    );
    if (resp.statusCode == 201) {
      return Challenge.fromJson(json.decode(resp.body)['reto']);
    }
    throw Exception('Error al crear reto: ${resp.body}');
  }

  Future<Challenge> update(Challenge c) async {
    final url = Uri.parse('$_baseUrl/${c.id}');
    final map = c.toJson()..removeWhere((k, v) => v == null);
    final resp = await http.put(url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken(),
      },
      body: jsonEncode(map),
    );
    if (resp.statusCode == 200) {
      return Challenge.fromJson(json.decode(resp.body)['reto']);
    }
    throw Exception('Error al actualizar reto: ${resp.body}');
  }

  Future<void> delete(String id) async {
    final url = Uri.parse('$_baseUrl/$id');
    final resp = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken(),
    });
    if (resp.statusCode != 200) {
      final msg = json.decode(resp.body)['msg'];
      throw Exception('Error al eliminar reto: $msg');
    }
  }
}