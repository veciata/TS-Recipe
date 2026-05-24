import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/config/env_config.dart';
import '../models/user.dart';

class AuthService {
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.apiAuthBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  String get baseUrl => EnvConfig.apiAuthBaseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<User?> register(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post('/register', data: userData);
      return _handleAuthResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final response =
          await _dio.post('/login', data: {'email': email, 'password': password});
      return _handleAuthResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<User?> _handleAuthResponse(dynamic data) async {
    if (data is! Map) {
      throw Exception('Invalid server response');
    }
    final body = Map<String, dynamic>.from(data);
    await _saveTokensFromResponse(body);
    final userJson = body['user'];
    if (userJson is Map) {
      return User.fromJson(Map<String, dynamic>.from(userJson));
    }
    return fetchCurrentUser();
  }

  Future<void> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }
      final response =
          await _dio.post('/refresh', data: {'refresh_token': refreshToken});
      await _saveTokensFromResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> logout() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken != null) {
        await _dio.post('/logout', data: {'refresh_token': refreshToken});
      }
    } on DioException catch (_) {
      // Ignore logout errors, still clear local tokens
    } finally {
      await clearTokens();
    }
  }

  Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return false;
    // Additional check: try to validate token with server
    try {
      await _dio.get('/validate',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      return true;
    } on DioException catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return null;
    try {
      final response = await _dio.get('/me',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      if (data is Map) return Map<String, dynamic>.from(data);
      return null;
    } on DioException catch (_) {
      return null;
    }
  }

  Future<User?> fetchCurrentUser() async {
    final data = await getCurrentUser();
    if (data == null) return null;
    return User.fromJson(data);
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<void> _saveTokensFromResponse(Map<String, dynamic> responseData) async {
    final accessToken = responseData['access_token'] as String?;
    final refreshToken = responseData['refresh_token'] as String?;
    if (accessToken == null || refreshToken == null) {
      throw Exception('Invalid token response from server');
    }
    await saveTokens(accessToken, refreshToken);
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Server: $baseUrl';
      case DioExceptionType.connectionError:
        return 'Cannot reach server at $baseUrl. '
            'On a phone, use your PC\'s LAN IP (not localhost).';
      case DioExceptionType.badResponse:
        final data = error.response?.data;
        final message = data is Map ? data['message']?.toString() : null;
        if (error.response?.statusCode == 401) {
          return message ?? 'Invalid email or password.';
        }
        if (error.response?.statusCode == 400) {
          return message ?? 'Bad request. Please check your input.';
        }
        return message ?? 'Server error: ${error.response?.statusCode}';
      default:
        return error.message ?? 'Network error';
    }
  }
}