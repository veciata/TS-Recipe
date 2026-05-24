import 'package:dio/dio.dart';
import '../models/recipe.dart';
import '../models/search_result.dart';
import 'duck_duck_go_service.dart';

class OnlineSearchService {
  final Dio _dio = Dio();
  final DuckDuckGoService _duckDuckGoService = DuckDuckGoService();

  OnlineSearchService() {
    _dio.options.baseUrl = 'https://www.themealdb.com/api/json/v1/1';
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    // Search TheMealDB
    final themeDbResults = await _searchThemeDb(query);
    
    // Search DuckDuckGo for additional results
    final duckDuckGoResults = await _duckDuckGoService.searchRecipes(query);
    
    // Convert DuckDuckGo results to Recipe objects (basic conversion)
    final duckDuckGoRecipes = _convertSearchResultsToRecipes(duckDuckGoResults);
    
    // Combine and deduplicate results
    return _mergeAndDeduplicateResults([themeDbResults, duckDuckGoRecipes]);
  }

  Future<List<Recipe>> _searchThemeDb(String query) async {
    try {
      final response = await _dio.get('/search.php', queryParameters: {
        's': query,
      });
      
      if (response.data['meals'] == null) {
        return [];
      }
      
      final List<dynamic> meals = response.data['meals'];
      return meals.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  List<Recipe> _convertSearchResultsToRecipes(List<SearchResult> results) {
    return results.map((result) {
      // Create a basic Recipe from SearchResult
      // Note: This is a simplified conversion for display purposes
      return Recipe(
        id: result.url.hashCode.toString(),
        name: result.title,
        category: '',
        area: '',
        instructions: result.snippet,
        imageUrl: result.imageUrl ?? '',
        ingredients: [],
        measures: [],
        sourceUrl: result.url,
        youtubeUrl: null,
      );
    }).toList();
  }

  List<Recipe> _mergeAndDeduplicateResults(List<List<Recipe>> resultLists) {
    final seenIds = <String>{};
    final combined = <Recipe>[];

    for (final list in resultLists) {
      for (final recipe in list) {
        final id = recipe.id;
        if (!seenIds.contains(id)) {
          seenIds.add(id);
          combined.add(recipe);
        }
      }
    }

    return combined;
  }
}