import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';


class NotificationService {
  final FlutterLocalNotificationsPlugin _flnp;

  NotificationService(this._flnp);

  /// Cancela la notificación con el [id] dado.
  Future<void> cancel(int id) => _flnp.cancel(id);

  /// Programa una notificación diaria a la hora indicada.
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year, now.month, now.day, hour, minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    try {
      await _flnp.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel',
            'Notificaciones diarias',
            channelDescription: 'Recordatorios diarios',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        // parámetro correcto para Android
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        // parámetro correcto para iOS/macOS
        // uiLocalNotificationDateInterpretation:
        //     UILocalNotificationDateInterpretation.absoluteTime,
        // dispara cada día a la misma hora
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } on PlatformException catch (e) {
      if (e.code == 'exact_alarms_not_permitted') {
        // fallback a inexacto
        await _flnp.zonedSchedule(
          id,
          title,
          body,
          scheduled,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'daily_channel',
              'Notificaciones diarias',
              channelDescription: 'Recordatorios diarios',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          // uiLocalNotificationDateInterpretation:
          //     UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } else {
        rethrow;
      }
    }
  }

  /// Programa una notificación puntual (one-shot).
  /// Programa una notificación puntual usando un Timer + show()
  // Future<void> scheduleOneTime({
  //   required int id,
  //   required String title,
  //   required String body,
  //   required DateTime scheduledDate,
  // }) async {
  //   // Calculamos cuánto falta desde ahora hasta la fecha objetivo
  //   final delay = scheduledDate.difference(DateTime.now());
  //   if (delay.isNegative) {
  //     // Si ya pasó, la lanzamos al momento
  //     await _show(id, title, body);
  //     return;
  //   }

    

  //   // Disparamos un Timer que al expirar llama a show()
  //   Timer(delay, () => _show(id, title, body));
  // }

    /// Programa una notificación puntual usando zonedSchedule
  Future<void> scheduleOneTime({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate, // hora local deseada
  }) async {
    // Convierte tu DateTime a TZDateTime en tu zona local
    final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);
    // Si ya pasó, dispara inmediatamente
    final when = tzDate.isBefore(tz.TZDateTime.now(tz.local))
        ? tz.TZDateTime.now(tz.local)
        : tzDate;

    await _flnp.zonedSchedule(
      id,
      title,
      body,
      when,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'one_time_channel',        // Asegúrate de haber creado este canal
          'Notificaciones de prueba',
          channelDescription: 'Canal para pruebas puntuales',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      // Usamos el nuevo parámetro
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // Interpretación absoluta de la fecha
      // null = solo se dispara una vez
      matchDateTimeComponents: null,
    );
  }

  /// Envía inmediatamente una notificación "de la forma FocusModule"
  Future<void> _show(int id, String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'one_time_channel',          // igual canal que creaste en main
      'Notificaciones de prueba',
      channelDescription: 'Canal para pruebas puntuales',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: false,
      visibility: NotificationVisibility.public,
      onlyAlertOnce: false,
    );
    const iosDetails = DarwinNotificationDetails();
    await _flnp.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
    );
  }
}