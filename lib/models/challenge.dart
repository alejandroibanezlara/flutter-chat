// Representa cada pregunta del cuestionario
class QuestionnaireItem {
  final String question;
  final List<String> answers;

  QuestionnaireItem({
    required this.question,
    required this.answers,
  });

  factory QuestionnaireItem.fromJson(Map<String, dynamic> json) {
    return QuestionnaireItem(
      question: json['question'] as String,
      answers: (json['answers'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answers': answers,
    };
  }
}

// Modelo base para tus áreas
class AreaInvencible {
  final String titulo;
  final String icono;

  AreaInvencible({
    required this.titulo,
    required this.icono,
  });

  factory AreaInvencible.fromJson(Map<String, dynamic> json) {
    return AreaInvencible(
      titulo: json['titulo'] as String,
      icono: json['icono'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'icono': icono,
    };
  }
}

// Modelo principal de Challenge, con config dinámico
class Challenge {
  final String id;
  final String type;
  final String title;
  final String shortText;
  final String? description;
  final String? icon;
  final List<AreaInvencible>? areasSerInvencible;
  final String timePeriod;
  final String frequency;
  final int points;
  final bool notebook;
  final String status;
  final List<String>? images;
  final dynamic config; // Puede ser Map<String,dynamic> o List<QuestionnaireItem>
  final List<String>? prerequisiteChallenges;
  final int prerequisiteCount;

  Challenge({
    required this.id,
    required this.type,
    required this.title,
    required this.shortText,
    this.description,
    this.icon,
    this.areasSerInvencible,
    required this.timePeriod,
    required this.frequency,
    this.points = 0,
    required this.notebook,
    required this.status,
    this.images,
    this.config,
    this.prerequisiteChallenges,
    this.prerequisiteCount = 0,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    final rawConfig = json['config'];

    dynamic parsedConfig;
    if (json['type'] == 'questionnaire' && rawConfig is List<dynamic>) {
      // Deserializar cada elemento como QuestionnaireItem
      parsedConfig = rawConfig
          .map((e) => QuestionnaireItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (rawConfig is Map<String, dynamic>) {
      // Mantener el Map original para el resto de tipos
      parsedConfig = rawConfig;
    }

    return Challenge(
      id: json['_id'] as String          // ← aquí usamos '_id'
         ?? json['id'] as String,         // ← fallback si existiera 'id'
      type: json['type'] as String,
      title: json['title'] as String,
      shortText: json['shortText'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      areasSerInvencible: (json['areasSerInvencible'] as List<dynamic>?)
          ?.map((e) => AreaInvencible.fromJson(e as Map<String, dynamic>))
          .toList(),
      timePeriod: json['timePeriod'] as String,
      frequency: json['frequency'] as String,
      points: json['points'] as int? ?? 0,
      notebook: json['notebook'] as bool? ?? false,
      status: json['status'] as String? ?? 'pending check',
      images: (json['images'] as List<dynamic>?)?.cast<String>(),
      config: parsedConfig,
      prerequisiteChallenges:
          (json['prerequisiteChallenges'] as List<dynamic>?)
              ?.cast<String>(),
      prerequisiteCount: json['prerequisiteCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {
      'type': type,
      'title': title,
      'shortText': shortText,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (areasSerInvencible != null)
        'areasSerInvencible':
            areasSerInvencible!.map((e) => e.toJson()).toList(),
      'timePeriod': timePeriod,
      'frequency': frequency,
      'points': points,
      'notebook': notebook,
      'status': status,
      if (images != null) 'images': images,
      // Serialización condicional de config
      if (config != null)
        'config': (type == 'questionnaire' && config is List<QuestionnaireItem>)
            ? (config as List<QuestionnaireItem>)
                .map((q) => q.toJson())
                .toList()
            : config,
      if (prerequisiteChallenges != null)
        'prerequisiteChallenges': prerequisiteChallenges,
      'prerequisiteCount': prerequisiteCount,
    };

    return map;
  }
}