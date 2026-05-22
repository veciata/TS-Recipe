import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../models/search_result.dart';
import '../services/api_service.dart';
import '../services/duck_duck_go_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final duckDuckGoServiceProvider = Provider<DuckDuckGoService>((ref) => DuckDuckGoService());

final categoriesProvider = FutureProvider((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getCategories();
});

final recipesByCategoryProvider = FutureProvider.family<List<Recipe>, String>((ref, category) async {
  final api = ref.watch(apiServiceProvider);
  return api.getRecipesByCategory(category);
});

final recipeDetailProvider = FutureProvider.family<Recipe, String>((ref, id) async {
  final api = ref.watch(apiServiceProvider);
  return api.getRecipeDetail(id);
});

final searchResultsProvider = FutureProvider.family<List<Recipe>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final api = ref.watch(apiServiceProvider);
  return api.searchRecipes(query);
});

final duckDuckGoSearchProvider = FutureProvider.family<List<SearchResult>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  final ddg = ref.watch(duckDuckGoServiceProvider);
  return ddg.searchRecipes(query);
});
