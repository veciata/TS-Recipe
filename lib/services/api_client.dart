import 'package:dio/dio.dart';

import '../core/config/env_config.dart';
import '../models/recipe.dart';
import 'auth_service.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal() {
    _init();
  }

  final Dio _dio = Dio();
  final AuthService _authService = AuthService();

  Dio get dio => _dio;
  String get baseUrl => EnvConfig.apiServerBaseUrl;

  void _init() {
    _dio.options.baseUrl = EnvConfig.apiServerBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add auth interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token if available
        final token = await _authService.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        // Handle 401 errors - try to refresh token
        if (error.response?.statusCode == 401) {
          try {
            // Attempt to refresh token
            await _authService.refreshToken();
            
            // Retry the original request with new token
            final token = await _authService.getAccessToken();
            if (token != null) {
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            }
          } on DioException catch (_) {
            // If refresh fails, clear tokens and propagate error
            await _authService.clearTokens();
          }
        }
        return handler.next(error);
      },
    ));
  }

  // GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await _dio.get(path, queryParameters: queryParams);
  }

  // POST request
  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  // PUT request
  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  // DELETE request
  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }

  // Search recipes with language parameter
  Future<List<Recipe>> searchRecipes(String query, {String language = 'en'}) async {
    final response = await get('/search', queryParams: {
      'q': query,
      'language': language,
    });

    final body = response.data;
    final List<dynamic> list;
    if (body is List) {
      list = body;
    } else if (body is Map<String, dynamic> && body['recipes'] is List) {
      list = body['recipes'] as List;
    } else {
      return [];
    }
    return list
        .whereType<Map>()
        .map((json) => Recipe.fromServerJson(Map<String, dynamic>.from(json)))
        .toList();
  }
}