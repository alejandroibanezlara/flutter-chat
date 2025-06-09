/// Modelo de ítem de checklist
class ChecklistItem {
  final String check;
  final bool complete;

  ChecklistItem({
    required this.check,
    required this.complete,
  });

  factory ChecklistItem.fromJson(Map<String, dynamic> json) => ChecklistItem(
        check: json['check'] as String,
        complete: json['complete'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'check': check,
        'complete': complete,
      };
}

/// Modelo de historial de progreso
class ProgressHistory {
  final DateTime date;
  final dynamic value;

  ProgressHistory({
    required this.date,
    required this.value,
  });

  factory ProgressHistory.fromJson(Map<String, dynamic> json) =>
      ProgressHistory(
        date: DateTime.parse(json['date'] as String),
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'value': value,
      };
}

/// Modelo de UserChallenge
class UserChallenge {
  final String id;
  final String userId;
  final String challengeId;
  final String status;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final int currentTotal;
  final int streakDays;

  // Nuevas propiedades opcionales del backend
  final int? counter;
  final String? writing;
  final List<ChecklistItem>? checklist;

  final Map<String, dynamic> progressData;
  final List<ProgressHistory> progressHistory;
  final DateTime lastUpdated;

  UserChallenge({
    required this.id,
    required this.userId,
    required this.challengeId,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.currentTotal,
    required this.streakDays,
    this.counter,
    this.writing,
    this.checklist,
    this.progressData = const {},
    this.progressHistory = const [],
    required this.lastUpdated,
  });

  factory UserChallenge.fromJson(Map<String, dynamic> json) => UserChallenge(
        id: json['_id'] as String,
        userId: json['userId'] as String,
        challengeId: json['challengeId'] as String,
        status: json['status'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: json['endDate'] != null
            ? DateTime.parse(json['endDate'] as String)
            : null,
        isActive: json['isActive'] as bool,
        currentTotal: json['currentTotal'] as int,
        streakDays: json['streakDays'] as int,
        // Parsear nuevas propiedades opcionales
        counter: (json['counter'] as int?) ,
        writing: json['writing'] as String?,
        checklist: (json['checklist'] as List<dynamic>?)
                ?.map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>))
                .toList(),
        progressData: (json['progressData'] as Map<String, dynamic>?) ?? {},
        progressHistory: (json['progressHistory'] as List<dynamic>?)
                ?.map((e) => ProgressHistory.fromJson(e as Map<String, dynamic>))
                .toList() ?? [],
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'challengeId': challengeId,
      'status': status,
      'isActive': isActive,
      'currentTotal': currentTotal,
      'streakDays': streakDays,
      'progressData': progressData,
      'progressHistory': progressHistory.map((e) => e.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
    if (endDate != null) {
      data['endDate'] = endDate!.toIso8601String();
    }
    // Añadir nuevas propiedades solo si no son null
    if (counter != null) data['counter'] = counter;
    if (writing != null) data['writing'] = writing;
    if (checklist != null) {
      data['checklist'] = checklist!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}
