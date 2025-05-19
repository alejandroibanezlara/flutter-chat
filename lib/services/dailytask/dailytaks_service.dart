import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat/global/environment.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/models/daily_task_user.dart';

class DailyTaskService with ChangeNotifier {
  Future<DailyTask?> getTasksForDate(String fecha) async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/dailytask/$fecha');
      final headers = {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode != 200) {
        return null;
      }

      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> list = data['tareas'] ?? [];
      if (list.isEmpty) return null;

      final doc = list.first;
      final dailyTask = DailyTask.fromJson(doc);

      return dailyTask;
    } catch (e, st) {
      debugPrint('Exception en getTasksForDate: $e');
      debugPrint(st.toString());
      return null;
    }
  }

  Future<DailyTask?> saveImportantTasks(List<Task> tasks) async {
    try {
      final validTasks = tasks.take(5).toList();
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final fecha = tomorrow.toIso8601String().split('T').first;
      
      final body = jsonEncode({
        'fecha': fecha,
        'tasks': validTasks.map((t) => {
          ...t.toJson(),
          'frog': t.frog ?? false, // Asegura que frog tenga valor
        }).toList(),
      });

      final uri = Uri.parse('${Environment.apiUrl}/dailytask');
      final headers = {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      };

      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint('Error al guardar tareas: ${response.statusCode} - ${response.body}');
        return null;
      }

      try {
        final responseData = json.decode(response.body);
        final tareaField = responseData['tarea'] ?? responseData;
        final tareaJson = tareaField is String 
            ? jsonDecode(tareaField) 
            : tareaField;
        final dailyTask = DailyTask.fromJson(tareaJson);
        notifyListeners();
        return dailyTask;
      } catch (parseError, stack) {
        debugPrint('Error parseando DailyTask: $parseError');
        debugPrint(stack.toString());
        return null;
      }
    } catch (e, st) {
      debugPrint('Exception en saveImportantTasks: $e');
      debugPrint(st.toString());
      return null;
    }
  }

  Future<DailyTask?> updateTask(DailyTask dailyTask) async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/dailytask/${dailyTask.id}');
      final headers = {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      };

      final body = jsonEncode({
        'fecha': dailyTask.fecha.toIso8601String(),
        'tasks': dailyTask.tasks.map((t) => {
          ...t.toJson(),
          'frog': t.frog ?? false, // Asegura que frog tenga valor
        }).toList(),
      });

      final response = await http.put(uri, headers: headers, body: body);

      if (response.statusCode != 200) {
        debugPrint('Error al actualizar tarea: ${response.statusCode} - ${response.body}');
        return null;
      }

      final responseData = json.decode(response.body);
      return DailyTask.fromJson(responseData['tarea'] ?? responseData);
      
    } catch (e, st) {
      debugPrint('Exception en updateTask: $e');
      debugPrint(st.toString());
      return null;
    }
  }
}



// task_provider.dart
class TaskProvider with ChangeNotifier {
  bool _needsRefresh = false;

  bool get needsRefresh => _needsRefresh;

  void markNeedsRefresh() {
    _needsRefresh = true;
    notifyListeners();
  }

  void resetRefresh() {
    _needsRefresh = false;
  }
}