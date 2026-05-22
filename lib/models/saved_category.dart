class SavedCategory {
  final String id;
  String name;
  final String icon;
  int colorValue;
  final DateTime createdAt;

  SavedCategory({
    required this.id,
    required this.name,
    this.icon = 'bookmark',
    this.colorValue = 0xFF6750A4,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'colorValue': colorValue,
    'createdAt': createdAt.toIso8601String(),
  };

  factory SavedCategory.fromJson(Map<String, dynamic> json) => SavedCategory(
    id: json['id'] as String,
    name: json['name'] as String,
    icon: json['icon'] as String? ?? 'bookmark',
    colorValue: json['colorValue'] as int? ?? 0xFF6750A4,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : null,
  );
}
