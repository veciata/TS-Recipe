import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Runtime API configuration from `.env`, then `--dart-define`, then defaults.
///
/// `.env` examples:
///   API_BASE_URL=http://192.168.1.50:3001/api
///   API_HOST=192.168.1.50
///   API_PORT=3001
class EnvConfig {
  EnvConfig._();

  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    await dotenv.load(fileName: '.env.example');
    try {
      await dotenv.load(fileName: '.env', mergeWith: dotenv.env);
    } catch (_) {
      // Optional local override (add `.env` to pubspec assets if you use one).
    }
    _loaded = true;
  }

  static String get apiServerBaseUrl {
    final fromFile = dotenv.maybeGet('API_BASE_URL');
    if (fromFile != null && fromFile.trim().isNotEmpty) {
      return _normalizeApiBase(fromFile);
    }

    final host = dotenv.maybeGet('API_HOST');
    if (host != null && host.trim().isNotEmpty) {
      final h = host.trim();
      final port = dotenv.maybeGet('API_PORT')?.trim();
      if (port != null && port.isNotEmpty) {
        return 'http://$h:$port/api';
      }
      return 'http://$h/api';
    }

    const fromDefine = String.fromEnvironment('API_BASE_URL');
    if (fromDefine.isNotEmpty) {
      return _normalizeApiBase(fromDefine);
    }

    const hostDefine = String.fromEnvironment('API_HOST');
    if (hostDefine.isNotEmpty) {
      const portDefine = String.fromEnvironment('API_PORT', defaultValue: '3001');
      return 'http://$hostDefine:$portDefine/api';
    }

    return 'http://api.recepy.veciata.info/api';
  }

  static String get apiAuthBaseUrl => '${apiServerBaseUrl.replaceAll(RegExp(r'/+$'), '')}/auth';

  static String _normalizeApiBase(String url) {
    var base = url.trim().replaceAll(RegExp(r'/+$'), '');
    if (!base.endsWith('/api')) {
      base = '$base/api';
    }
    return base;
  }
}
