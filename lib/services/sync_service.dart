import 'auth_service.dart';
import 'api_client.dart';
import 'local_database_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final LocalDatabaseService _localDb = LocalDatabaseService();
  final AuthService _authService = AuthService();
  final ApiClient _apiClient = ApiClient();

  Future<bool> syncLocalToServer() async {
    try {
      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) return false;

      final recipes = await _localDb.getMyRecipes();
      if (recipes.isEmpty) return true;

      final response = await _apiClient.post('/sync/push', data: {
        'recipes': recipes,
      });
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> syncServerToLocal() async {
    try {
      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) return false;

      final response = await _apiClient.get('/sync/pull');
      if (response.statusCode == 200) {
        final List<dynamic> recipesData = response.data['recipes'] ?? [];
        for (var data in recipesData) {
          await _localDb.saveRecipeFromJson(data);
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, bool>> fullSync() async {
    final localToServer = await syncLocalToServer();
    final serverToLocal = await syncServerToLocal();
    return {'localToServer': localToServer, 'serverToLocal': serverToLocal};
  }
}