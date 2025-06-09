import 'dart:convert';
import 'package:chat/models/microlearning.dart';
import 'package:chat/services/notificaciones/notificaciones_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:chat/services/auth_service.dart';
import 'package:chat/global/environment.dart';
import 'package:chat/models/personal_data.dart';

/// Servicio para operaciones CRUD y registro de calidad de sueño y actitud inicial
class PersonalDataService with ChangeNotifier {
  // __ Estado local para acumulación de selecciones __
  int? _sleepRating;
  int? _initialAttitudeRating;
  int? _finalAttitudeRating;

  // 1. Cache del último PersonalData cargado
  PersonalData? _personalData;

  /// Exponer todo el objeto si lo necesitas
  PersonalData? get personalData => _personalData;

  /// Getters específicos para la barra de tiempo
  DateTime? get inicioDia    => _personalData?.inicioDia;
  DateTime? get finJornada   => _personalData?.finJornada;


  /// Getters para que los widgets lean directamente
  bool               get notificacionesActivadas => _personalData?.notificacionesActivadas ?? false;

  // Instancia global (puedes ponerla en main.dart y pasar por Provider si lo prefieres)
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Lógica interna: programa o cancela según `notificacionesActivadas`
  void _configureNotifications() {
    final notifSvc = NotificationService(flutterLocalNotificationsPlugin);

    // 1) Cancelamos siempre las IDs previas
    notifSvc.cancel(1); // Buenos días
    notifSvc.cancel(2); // Fin de jornada
    notifSvc.cancel(3); // Mitad de jornada
    notifSvc.cancel(4); // Pico de energía
    notifSvc.cancel(5); // (opcional) notificación de prueba

    // 2) Si el usuario desactivó notificaciones → nada más
    if (!notificacionesActivadas) return;

    final now = DateTime.now();

    // ────────────────────────────────────────────
    // 3) Buenos días
    final inicio = _personalData?.inicioDia ??
        DateTime(now.year, now.month, now.day, 6, 0);
    notifSvc.scheduleDaily(
      id: 1,
      title: '¡Buenos días!',
      body: 'Es hora de empezar tu jornada.',
      hour: inicio.hour,
      minute: inicio.minute,
    );

    // ────────────────────────────────────────────
    // 4) Fin de jornada
    final fin = _personalData?.finJornada ??
        DateTime(now.year, now.month, now.day, 23, 0);
        print(fin.hour-1);
        print(fin.minute+2);
    notifSvc.scheduleDaily(
      id: 2,
      title: 'Fin de jornada',
      body: '¡Vas a completar el día! No olvides tu reflexión final.',
      hour: fin.hour-1,
      minute: fin.minute+2,
    );

    // ────────────────────────────────────────────
    // 5) Mitad de jornada
    // Sólo si inicio < fin, pero si no definiste fin en BD usa 23:00
    final start = inicio;
    final end = fin;
    final diff = end.difference(start);
    if (diff.inMinutes > 0) {
      final midpoint = start.add(Duration(minutes: diff.inMinutes ~/ 2));
      notifSvc.scheduleDaily(
        id: 3,
        title: '¡Ya vas por la mitad!',
        body: 'Llevas media jornada. ¡Sigue así!',
        hour: midpoint.hour,
        minute: midpoint.minute,
      );
    }

    // ────────────────────────────────────────────
    // 6) Pico de energía
    if (_personalData?.picoEnergia != null) {
      final pico = _personalData!.picoEnergia!;
      notifSvc.scheduleDaily(
        id: 4,
        title: 'Hora de tu pico de energía',
        body: 'Aprovecha este momento para tus retos más exigentes.',
        hour: pico.hour,
        minute: pico.minute,
      );
    }

    // ────────────────────────────────────────────
    // 7) (Opcional) tu notificación de prueba puntual
    // var prueba = DateTime(now.year, now.month, now.day, 20, 6);
    // if (now.isAfter(prueba)) prueba = prueba.add(const Duration(days: 1));
    // notifSvc.scheduleOneTime(
    //   id: 5,
    //   title: '¡Notificación de prueba!',
    //   body: 'Si ves esto, tu canal funciona correctamente.',
    //   scheduledDate: prueba,
    // );
  }
 

  /// Crea o recupera (upsert) el registro PersonalData del usuario autenticado
  Future<PersonalData> createOrGetPersonalData() async {
    final url = Uri.parse('${Environment.apiUrl}/personalData');
    final token = await AuthService.getToken();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final dataJson = jsonData['personalData'] as Map<String, dynamic>;
      // return PersonalData.fromJson(dataJson);
      final pd = PersonalData.fromJson(dataJson);
      _personalData = pd;           // ← guardar en caché
      notifyListeners();            // ← notificar cambios
      return pd;
    }
    throw Exception('Error al crear/recuperar PersonalData: ${response.body}');
  }

  /// Obtiene el registro PersonalData de un usuario por su ID
  // Future<PersonalData> getPersonalDataByUserId(String userId) async {
  //   final url = Uri.parse('${Environment.apiUrl}/personalData/$userId');
  //   final token = await AuthService.getToken();

  //   final response = await http.get(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'x-token': token,
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> jsonData = jsonDecode(response.body);
  //     final dataJson = jsonData['personalData'] as Map<String, dynamic>;
  //     return PersonalData.fromJson(dataJson);
  //   } else if (response.statusCode == 404) {
  //     throw Exception('No existe PersonalData para el usuario $userId');
  //   }
  //   throw Exception('Error al cargar PersonalData: ${response.body}');
  // }

  Future<PersonalData> getPersonalDataByUserId(String userId) async {


    final url = Uri.parse('${Environment.apiUrl}/personalData/$userId');
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

      if (!jsonData.containsKey('personalData') || jsonData['personalData'] == null) {
        throw Exception('El campo "personalData" no está presente o es null en la respuesta.');
      }

      final dataJson = jsonData['personalData'] as Map<String, dynamic>;


      try {
        final personalData = PersonalData.fromJson(dataJson);

        // return personalData;
        _personalData = personalData;  // ← guardar en caché
        notifyListeners();             // ← notificar cambios

        // 2) (Re)programa o cancela notificaciones
        _configureNotifications();

        return personalData;
      } catch (e, stacktrace) {
        print('❌ Error al parsear PersonalData: $e');
        print(stacktrace);
        rethrow;
      }
    } else if (response.statusCode == 404) {
      throw Exception('No existe PersonalData para el usuario $userId');
    }

    throw Exception('Error al cargar PersonalData: ${response.body}');
  }



  

  Future<PersonalData> getPersonalDataLight(String userId) async {
  final url = Uri.parse('${Environment.apiUrl}/personalData/$userId/light');
  final token = await AuthService.getToken();

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'x-token': token,
    },
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final dataJson = jsonData['personalData'] as Map<String, dynamic>;
    return PersonalData.fromJson(dataJson);
  } else if (response.statusCode == 404) {
    throw Exception('No existe PersonalData para el usuario $userId');
  }

  throw Exception('Error al cargar PersonalData (versión light): ${response.body}');
}

 /// Actualiza parcialmente campos de PersonalData usando PATCH
/// En `diaCompletado` y `actitudFinalDia`, solo se añade el nuevo elemento
  // Future<PersonalData> updatePersonalDataByUserId(
  //   String userId,
  //   Map<String, dynamic> updatedData,
  // ) async {
  //   final url = Uri.parse('${Environment.apiUrl}/personalData/$userId');
  //   final token = await AuthService.getToken();

  //   // Extraer los últimos elementos si existen
  //   final dynamic nuevoDia = updatedData.remove('diaCompletado');
  //   final dynamic nuevaActitud = updatedData.remove('actitudFinalDia');

  //   // Construir payload solo con cambios nuevos
  //   final Map<String, dynamic> patchPayload = {
  //     ...updatedData,
  //     if (nuevoDia != null) 'nuevoDiaCompletado': nuevoDia,
  //     if (nuevaActitud != null) 'nuevaActitudFinalDia': nuevaActitud,
  //   };

  //   final response = await http.patch(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'x-token': token,
  //     },
  //     body: jsonEncode(patchPayload),
  //   );

  //   if (response.statusCode == 200) {

  //     final Map<String, dynamic> jsonData = jsonDecode(response.body);
  //     final dataJson = jsonData['personalData'] as Map<String, dynamic>;
  //     return PersonalData.fromJson(dataJson);
  //   }

  //   throw Exception(
  //     'Error ${response.statusCode} al actualizar PersonalData: ${response.body}'
  //   );
  // }

  Future<PersonalData> updatePersonalDataByUserId(
    String userId,
    Map<String, dynamic> updatedData,
  ) async {
    final url = Uri.parse('${Environment.apiUrl}/personalData/$userId');
    final token = await AuthService.getToken();

    // Construir payload
    final Map<String, dynamic> patchPayload = {
      ...updatedData,
      // elimina solo los campos específicos si existen
    };



    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
      body: jsonEncode(patchPayload),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final dataJson = jsonData['personalData'] as Map<String, dynamic>;
      final pd = PersonalData.fromJson(dataJson);

      _personalData = pd;           // ← refresca la caché con los nuevos valores
      // NOTIFY: informa a listeners de que hubo un cambio
      notifyListeners();

      // 2) (Re)programa o cancela notificaciones
      _configureNotifications();


      return pd;
    }

    throw Exception(
      'Error ${response.statusCode} al actualizar PersonalData: ${response.body}'
    );
  }


  /// Elimina el registro PersonalData de un usuario
  Future<void> deletePersonalDataByUserId(String userId) async {
    final url = Uri.parse('${Environment.apiUrl}/personalData/$userId');
    final token = await AuthService.getToken();

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (response.statusCode == 204) return;
    if (response.statusCode == 404) {
      throw Exception('No existe PersonalData para eliminar: $userId');
    }
    throw Exception(
      'Error ${response.statusCode} al eliminar PersonalData: ${response.body}'
    );
  }

  // ==================== Funciones para cuestionario inicial ====================

  /// Mapea la opción de texto a una nota numérica (1 a 5)
  int _mapSelectionToRating(String selection, List<String> options) {
    final index = options.indexOf(selection);
    if (index < 0) throw Exception('Opción inválida: \$selection');
    // Nota: excelente (index 0) -> 1, ... muy mal (last index) -> 5
    return index + 1;
  }


  /// Asigna la calidad de sueño seleccionada
  void setSleepQuality(String selection, List<String> sleepOptions) {
    _sleepRating = _mapSelectionToRating(selection, sleepOptions);
    notifyListeners();
  }

  /// Asigna la actitud inicial seleccionada
  void setInitialAttitude(String selection, List<String> attitudeOptions) {
    _initialAttitudeRating = _mapSelectionToRating(selection, attitudeOptions);
    notifyListeners();
  }


  /// Asigna la actitud final seleccionada
  void setFinalAttitude(String selection, List<String> attitudeOptions) {
    _finalAttitudeRating = _mapSelectionToRating(selection, attitudeOptions);
    notifyListeners();
  }

  /// Envía solo la última nota de calidad de sueño y actitud inicial al backend
  Future<void> submitInitialQuestionnaire(String userId) async {
    if (_sleepRating == null || _initialAttitudeRating == null) {
      throw Exception('Debe completar calidad de sueño y actitud inicial');
    }

    final nowUtc = DateTime.now().toUtc().toIso8601String();
    final token = await AuthService.getToken();

    final headers = {
      'Content-Type': 'application/json',
      'x-token': token,
    };

    try {
      // 🔹 Enviar calidad de sueño
      await http.patch(
        Uri.parse('${Environment.apiUrl}/personalData/$userId/calidadSueno'),
        headers: headers,
        body: jsonEncode({
          'nota': _sleepRating,
          'fecha': nowUtc,
        }),
      );

      // 🔹 Enviar actitud inicial
      await http.patch(
        Uri.parse('${Environment.apiUrl}/personalData/$userId/actitudInicial'),
        headers: headers,
        body: jsonEncode({
          'nota': _initialAttitudeRating,
          'fecha': nowUtc,
        }),
      );

      // 🧹 Limpiar valores locales tras éxito
      _sleepRating = null;
      _initialAttitudeRating = null;
      notifyListeners();
    } catch (e) {
      print('❌ Error al enviar cuestionario inicial: $e');
      rethrow;
    }
  }

  /// Envía al backend los valores de actitud final seleccionados
  Future<PersonalData> submitFinalQuestionnaire(String userId) async {
    if (_finalAttitudeRating == null) {
      throw Exception('Debe completar la actitud final');
    }
    final nowUtc = DateTime.now().toUtc().toIso8601String();
    final current = await getPersonalDataByUserId(userId);

    // Acumula antigua lista + nueva entrada
    final lista = current.actitudFinal.map((r) => r.toJson()).toList()
      ..add({'nota': _finalAttitudeRating, 'fecha': nowUtc});

    // final result = await updatePersonalDataByUserId(userId, {
    //   'actitudFinal': lista,
    // });
    final result = await addActitudFinal(userId, {
      'nota': _finalAttitudeRating,
      'fecha': nowUtc,
    });
    _finalAttitudeRating = null;
    notifyListeners();
    return result;
  }



    /// Obtiene 3 microlearnings aleatorios y los guarda en el modelo PersonalData
  Future<List<MicroLearning>> getRandomMicrolearnings() async {
    final url = Uri.parse('${Environment.apiUrl}/microlearning/aleatorios');
    final token = await AuthService.getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => MicroLearning.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener microlearnings: ${response.statusCode}');
    }
  }

  Future<void> replaceMicrolearningCards(String userId, List<String> cardIds) async {
    final url = Uri.parse('${Environment.apiUrl}/personalData/$userId/replaceCards');
    final token = await AuthService.getToken();

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
      body: jsonEncode({ 'cardIds': cardIds }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar las tarjetas aleatorias: ${response.body}');
    }
  }

  Future<List<MicroLearning>> getMicrolearningsFromUser(String uid) async {
    final url = Uri.parse('${Environment.apiUrl}/personalData/$uid');
    final token = await AuthService.getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al obtener PersonalData: ${response.body}');
    }

    final jsonData = jsonDecode(response.body);
    final data = jsonData['personalData'] as Map<String, dynamic>;

    // Aquí asumimos que el backend ha añadido el campo `microlearnings` con populate
    final List<dynamic> tarjetas = data['microlearnings'] ?? [];

    return tarjetas.map((json) => MicroLearning.fromJson(json)).toList();
  }


  Future<PersonalData> addDiaCompletado(String userId, Map<String, dynamic> entry) async {
    final url = Uri.parse('${Environment.apiUrl}/personalData/$userId/diaCompletado');
    final token = await AuthService.getToken();

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
      body: jsonEncode(entry),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return PersonalData.fromJson(jsonData['personalData']);
    }

    throw Exception('Error ${response.statusCode} al añadir día completado');
  }

  Future<PersonalData> addActitudFinal(String userId, Map<String, dynamic> entry) async {
    final url = Uri.parse('${Environment.apiUrl}/personalData/$userId/actitudFinal');
    final token = await AuthService.getToken();

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
      body: jsonEncode(entry),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return PersonalData.fromJson(jsonData['personalData']);
    }

    throw Exception('Error ${response.statusCode} al añadir actitud final');
  }



    /// Registra la finalización de un reto y actualiza el contador correspondiente
  /// [retoType] puede ser:
  ///   'daily'     → contadorRetosDia
  ///   'weekly'    → contadorRetosSemana
  ///   'monthly'   → contadorRetosMes
  ///   'featured'  → contadorRetosDestacados
  Future<PersonalData> completeChallenge(
    String userId,
    String retoType,
  ) async {
    // 1) Cargar datos actuales
    final current = await getPersonalDataByUserId(userId);

    // 2) Seleccionar campo y calcular nuevo valor
    late String field;
    late int newCount;
    switch (retoType) {
      case 'daily':
        field = 'contadorRetosDia';
        newCount = (current.contadorRetosDia ?? 0) + 1;
        break;
      case 'weekly':
        field = 'contadorRetosSemana';
        newCount = (current.contadorRetosSemana ?? 0) + 1;
        break;
      case 'monthly':
        field = 'contadorRetosMes';
        newCount = (current.contadorRetosMes ?? 0) + 1;
        break;
      case 'featured':
        field = 'contadorRetosDestacados';
        newCount = (current.contadorRetosDestacados ?? 0) + 1;
        break;
      default:
        throw Exception('Tipo de reto desconocido: $retoType');
    }

    // 3) Hacer patch en el backend
    return await updatePersonalDataByUserId(userId, { field: newCount });
  }




}