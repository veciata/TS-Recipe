import 'recipe.dart';
import 'search_result.dart';

class SavedRecipe {
  final String id;
  String categoryId;
  final String name;
  final String category;
  final String area;
  final String imageUrl;
  final String url;
  final String source;
  final DateTime savedAt;

  SavedRecipe({
    required this.id,
    required this.categoryId,
    required this.name,
    this.category = '',
    this.area = '',
    this.imageUrl = '',
    this.url = '',
    this.source = '',
    DateTime? savedAt,
  }) : savedAt = savedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'categoryId': categoryId,
    'name': name,
    'category': category,
    'area': area,
    'imageUrl': imageUrl,
    'url': url,
    'source': source,
    'savedAt': savedAt.toIso8601String(),
  };

  factory SavedRecipe.fromJson(Map<String, dynamic> json) => SavedRecipe(
    id: json['id'] as String,
    categoryId: json['categoryId'] as String,
    name: json['name'] as String,
    category: json['category'] as String? ?? '',
    area: json['area'] as String? ?? '',
    imageUrl: json['imageUrl'] as String? ?? '',
    url: json['url'] as String? ?? '',
    source: json['source'] as String? ?? '',
    savedAt: json['savedAt'] != null
        ? DateTime.parse(json['savedAt'] as String)
        : null,
  );

  factory SavedRecipe.fromRecipe(Recipe recipe, String categoryId) {
    return SavedRecipe(
      id: recipe.id,
      categoryId: categoryId,
      name: recipe.name,
      category: recipe.category,
      area: recipe.area,
      imageUrl: recipe.imageUrl,
    );
  }

  factory SavedRecipe.fromSearchResult(SearchResult result, String categoryId) {
    return SavedRecipe(
      id: result.url,
      categoryId: categoryId,
      name: result.title,
      imageUrl: result.imageUrl ?? '',
      url: result.url,
      source: result.snippet,
    );
  }
}
