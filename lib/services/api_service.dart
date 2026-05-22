import 'package:dio/dio.dart';
import '../core/constants/app_constants.dart';
import '../models/recipe.dart';
import '../models/recipe_category.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: kApiBaseUrl,
          queryParameters: {'apiKey': kApiKey},
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  Future<List<RecipeCategory>> getCategories() async {
    final response = await _dio.get('/categories.php', queryParameters: {});
    final data = response.data as Map<String, dynamic>;
    final list = data['categories'] as List<dynamic>;
    return list.map((e) => RecipeCategory.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Recipe>> getRecipesByCategory(String category) async {
    final response = await _dio.get('/filter.php', queryParameters: {'c': category});
    final data = response.data as Map<String, dynamic>;
    final list = data['meals'] as List<dynamic>? ?? [];
    return list.map((e) {
      final map = e as Map<String, dynamic>;
      return Recipe(
        id: map['idMeal'] as String? ?? '',
        name: map['strMeal'] as String? ?? '',
        category: category,
        area: '',
        instructions: '',
        imageUrl: map['strMealThumb'] as String? ?? '',
        ingredients: [],
        measures: [],
      );
    }).toList();
  }

  Future<Recipe> getRecipeDetail(String id) async {
    final response = await _dio.get('/lookup.php', queryParameters: {'i': id});
    final data = response.data as Map<String, dynamic>;
    final list = data['meals'] as List<dynamic>;
    return Recipe.fromJson(list[0] as Map<String, dynamic>);
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    final response = await _dio.get('/search.php', queryParameters: {'s': query});
    final data = response.data as Map<String, dynamic>;
    final list = data['meals'] as List<dynamic>? ?? [];
    return list.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
  }
}
