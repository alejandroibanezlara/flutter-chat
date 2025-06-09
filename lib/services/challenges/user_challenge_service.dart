import 'dart:convert';
import 'package:chat/global/environment.dart';
import 'package:chat/models/challenge.dart';
import 'package:chat/models/user_challenge.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/challenges/challenge_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Servicio para consumir la API de UserChallenge
/// Servicio para consumir la API de UserChallenge
class UserChallengeService with ChangeNotifier {
  final _baseUrl = '${Environment.apiUrl}/user_challenge';

  
  ChallengeService? _challengeService;

  UserChallengeService();

  /// Inyecta dinámicamente el ChallengeService
  void setChallengeService(ChallengeService service) {
    _challengeService = service;
  }

  List<UserChallenge> _items = [];

  /// Sólo los UserChallenge activos y sin duplicados por challengeId
  List<UserChallenge> get items => List.unmodifiable(_items);


  Future<Map<String, String>> _headers() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'x-token': token,
    };
  }

  /// POST /api/user_challenges
  /// POST /api/user_challenges
  /// Crea un UserChallenge inicializando las propiedades según el tipo de reto
  Future<UserChallenge> createUserChallenge(Challenge reto) async {
    final url = Uri.parse('$_baseUrl');

    // 1) Determinar valor inicial del counter
    int? initialCounter;
    if (reto.type == 'counter') {
      initialCounter = 0;
    } else if (reto.type == 'inverse_counter') {
      initialCounter = (reto.config['inverse_counter'] as int?) ?? 0;
    }

    // 2) Determinar valor inicial de writing o checklist
    String? initialWriting;
    List<Map<String, dynamic>>? initialChecklist;

    if (reto.type == 'writing') {
      // Reto de escritura: texto vacío
      initialWriting = '';
    }

    if (reto.type == 'checklist') {
      // Reto de checklist: todos los ítems en false
      final cfg = reto.config as Map<String, dynamic>;
      initialChecklist = cfg.entries.map((entry) => {
            'check': entry.value as String,
            'complete': false,
          }).toList();
    }



    // 3) Construir el cuerpo de la petición
    final bodyMap = <String, dynamic>{
      'challengeId': reto.id,
      if (initialCounter != null) 'counter': initialCounter,
      if (initialWriting != null) 'writing': initialWriting,
      if (initialChecklist != null) 'checklist': initialChecklist,
    };

    // 4) Enviar petición
    final resp = await http.post(
      url,
      headers: await _headers(),
      body: jsonEncode(bodyMap),
    );



    // 5) Procesar respuesta
    if (resp.statusCode == 201) {
      // Refrescar la lista y devolver el nuevo registro
      await getUserChallenges();
      return _items.firstWhere((uc) => uc.challengeId == reto.id);
    }

    throw Exception('Error creando UserChallenge: ${resp.statusCode} ${resp.body}');
  }

  /// GET /api/user_challenges
  Future<List<UserChallenge>> getUserChallenges() async {
    final url  = Uri.parse('$_baseUrl');
    final resp = await http.get(url, headers: await _headers());
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body) as Map<String, dynamic>;
      final raw  = (body['userChallenges'] as List)
            .map((e) => UserChallenge.fromJson(e))
            .toList();
      final uniqueBy = <String, UserChallenge>{};
      for (var uc in raw) {
        if (uc.isActive) uniqueBy[uc.challengeId] = uc;
      }
      _items = uniqueBy.values.toList();
      notifyListeners();
      return _items;
    }
    throw Exception('Error cargando UserChallenges: ${resp.body}');
  }

  /// GET /api/user_challenges/:id
  Future<UserChallenge> getUserChallenge(String id) async {
    final url  = Uri.parse('$_baseUrl/$id');
    final resp = await http.get(url, headers: await _headers());
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body) as Map<String, dynamic>;
      return UserChallenge.fromJson(body['userChallenge']);
    }
    throw Exception('Error obteniendo UserChallenge: ${resp.body}');
  }

  /// PUT /api/user_challenges/:id
  Future<UserChallenge> updateUserChallenge(
      String id,
      Map<String, dynamic> changes,
  ) async {
    final url  = Uri.parse('$_baseUrl/$id');
    final resp = await http.put(
      url,
      headers: await _headers(),
      body: jsonEncode(changes),
    );
    if (resp.statusCode == 200) {
      final body    = json.decode(resp.body) as Map<String, dynamic>;
      final updated = UserChallenge.fromJson(body['userChallenge']);
      final idx     = _items.indexWhere((e) => e.id == id);
      if (idx >= 0) {
        _items[idx] = updated;
        notifyListeners();
      }
      return updated;
    }
    throw Exception('Error actualizando UserChallenge: ${resp.body}');
  }

  /// PATCH /api/user_challenges/:id/finish
  Future<UserChallenge> finishToday(String id, int currentTotal) async {
    final url  = Uri.parse('$_baseUrl/$id/finish');
    final resp = await http.patch(
      url,
      headers: await _headers(),
      body: jsonEncode({'currentTotal': currentTotal}),
    );
    if (resp.statusCode == 200) {
      final body    = json.decode(resp.body) as Map<String, dynamic>;
      final finished = UserChallenge.fromJson(body['userChallenge']);
      final idx      = _items.indexWhere((e) => e.id == id);
      if (idx >= 0) {
        _items[idx] = finished;
        notifyListeners();
      }
      return finished;
    }
    throw Exception('Error finalizando UserChallenge: ${resp.body}');
  }

  /// PATCH /api/user_challenges/:id/counter
  /// Incrementa o decrementa el campo "counter" directamente
  Future<UserChallenge> updateChallengeCounter(
      String id,
      int newCounter,
  ) async {
    return await updateUserChallenge(id, {'counter': newCounter});
  }

  /// Métodos para retos de tipo "counter"
  Future<UserChallenge> incrementCounter(String id) async {
    final uc = _items.firstWhere((e) => e.id == id);
    return await updateChallengeCounter(id, uc.counter! + 1);
  }

  Future<UserChallenge> decrementCounter(String id) async {
    final uc = _items.firstWhere((e) => e.id == id);
    final next = uc.counter! > 0 ? uc.counter! - 1 : 0;
    return await updateChallengeCounter(id, next);
  }

  /// DELETE /api/user_challenges/:id
  Future<void> deleteUserChallenge(String id) async {
    final url  = Uri.parse('$_baseUrl/$id');
    final resp = await http.delete(url, headers: await _headers());
    if (resp.statusCode == 200) {
      _items.removeWhere((e) => e.id == id);
      notifyListeners();
      return;
    }
    throw Exception('Error eliminando UserChallenge: ${resp.body}');
  }


  /// Marca como "incompleted" los retos activos según su periodo de tiempo:
  /// - Diario: inactivo tras 24 horas desde startDate
  /// - Semanal: inactivo tras 7 días
  /// - Mensual: inactivo tras 30 días
  Future<void> invalidateStaleChallenges() async {
    // 1) Refrescar lista de UserChallenges activos
    await getUserChallenges();
    final now = DateTime.now();

    for (final uc in _items.where((uc) => uc.isActive)) {
      // 2) Obtener detalles del reto para conocer su timePeriod
      final Challenge reto = await _challengeService!.getById(uc.challengeId);
      final period = reto.timePeriod.toLowerCase();
      final diff = now.difference(uc.startDate);

      bool shouldInvalidate = false;
      switch (period) {
        case 'daily':
          // Más de 24 horas sin completar
          shouldInvalidate = diff.inHours >= 0;
          break;
        case 'weekly':
          // Más de 7 días activos
          shouldInvalidate = diff.inDays >= 7;
          break;
        case 'monthly':
          // Más de 30 días activos
          shouldInvalidate = diff.inDays >= 30;
          break;
        default:
          // Otros periodos se pueden añadir según sea necesario
          break;
      }

      if (shouldInvalidate) {
        await updateUserChallenge(uc.id, {
          'status': 'incomplete',
          'isActive': false,
          'endDate': now.toIso8601String(),
        });
      }
    }

    // 3) Refrescar la lista tras invalidar
    await getUserChallenges();
  }


}
