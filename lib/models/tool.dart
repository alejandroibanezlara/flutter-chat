class Tool {
  final String id;
  final String title;
  final String icon;
  final String route;
  final DateTime fecha;
  final DateTime createdAt;
  final DateTime updatedAt;

  Tool({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    required this.fecha,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tool.fromJson(Map<String, dynamic> json) => Tool(
        id: json['_id'],
        title: json['title'],
        icon: json['icon'],
        route: json['route'],
        fecha: DateTime.parse(json['fecha']),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'icon': icon,
        'route': route,
        'fecha': fecha.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}