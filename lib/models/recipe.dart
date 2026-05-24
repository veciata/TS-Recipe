class Recipe {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> measures;
  final String? sourceUrl;
  final String? youtubeUrl;

  const Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.imageUrl,
    required this.ingredients,
    required this.measures,
    this.sourceUrl,
    this.youtubeUrl,
  });

  factory Recipe.fromServerJson(Map<String, dynamic> json) {
    final rawIngredients = json['ingredients'];
    final ingredients = rawIngredients is List
        ? rawIngredients.map((e) => e.toString()).toList()
        : (rawIngredients as String?)
                ?.split('\n')
                .where((s) => s.trim().isNotEmpty)
                .toList() ??
            [];

    return Recipe(
      id: (json['id'] ?? json['idMeal'] ?? '').toString(),
      name: (json['title'] ?? json['name'] ?? json['strMeal'] ?? '').toString(),
      category: (json['category'] ?? json['strCategory'] ?? '').toString(),
      area: (json['area'] ?? json['strArea'] ?? '').toString(),
      instructions:
          (json['instructions'] ?? json['strInstructions'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? json['image_url'] ?? json['strMealThumb'] ?? '')
          .toString(),
      ingredients: ingredients,
      measures: const [],
      sourceUrl: json['sourceUrl'] as String? ?? json['strSource'] as String?,
      youtubeUrl: json['youtubeUrl'] as String? ?? json['strYoutube'] as String?,
    );
  }

  factory Recipe.fromLocalRow(Map<String, dynamic> row) {
    final raw = row['ingredients'] as String?;
    return Recipe(
      id: row['id'].toString(),
      name: row['title'] as String? ?? '',
      category: '',
      area: '',
      instructions: row['instructions'] as String? ?? '',
      imageUrl: row['imageUrl'] as String? ?? '',
      ingredients: raw?.split('\n').where((s) => s.trim().isNotEmpty).toList() ?? [],
      measures: const [],
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];
    final measures = <String>[];
    for (var i = 1; i <= 20; i++) {
      final ing = json['strIngredient$i'] as String?;
      final meas = json['strMeasure$i'] as String?;
      if (ing != null && ing.isNotEmpty) {
        ingredients.add(ing);
        measures.add(meas ?? '');
      }
    }
    return Recipe(
      id: json['idMeal'] as String? ?? '',
      name: json['strMeal'] as String? ?? '',
      category: json['strCategory'] as String? ?? '',
      area: json['strArea'] as String? ?? '',
      instructions: json['strInstructions'] as String? ?? '',
      imageUrl: json['strMealThumb'] as String? ?? '',
      ingredients: ingredients,
      measures: measures,
      sourceUrl: json['strSource'] as String?,
      youtubeUrl: json['strYoutube'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'idMeal': id,
    'strMeal': name,
    'strCategory': category,
    'strArea': area,
    'strInstructions': instructions,
    'strMealThumb': imageUrl,
    'strSource': sourceUrl,
    'strYoutube': youtubeUrl,
    for (var i = 0; i < ingredients.length; i++)
      'strIngredient${i + 1}': ingredients[i],
    for (var i = 0; i < measures.length; i++)
      'strMeasure${i + 1}': measures[i],
  };
}
