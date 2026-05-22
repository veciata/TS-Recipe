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
