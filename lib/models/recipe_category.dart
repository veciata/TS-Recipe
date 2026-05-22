class RecipeCategory {
  final String id;
  final String name;
  final String thumbnail;
  final String description;

  const RecipeCategory({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.description,
  });

  factory RecipeCategory.fromJson(Map<String, dynamic> json) {
    return RecipeCategory(
      id: json['idCategory'] as String? ?? '',
      name: json['strCategory'] as String? ?? '',
      thumbnail: json['strCategoryThumb'] as String? ?? '',
      description: json['strCategoryDescription'] as String? ?? '',
    );
  }
}
