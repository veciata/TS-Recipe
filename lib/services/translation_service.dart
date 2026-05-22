import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationService {
  OnDeviceTranslator? _translator;
  final Map<String, String> _cache = {};

  Future<void> init() async {
    _translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.turkish,
    );
    try {
      final manager = OnDeviceTranslatorModelManager();
      await manager.downloadModel('en_tr', isWifiRequired: false);
    } catch (_) {}
  }

  Future<String> translate(String text) async {
    if (_cache.containsKey(text)) return _cache[text]!;
    if (_translator == null) return text;
    try {
      final result = await _translator!.translateText(text);
      _cache[text] = result;
      return result;
    } catch (_) {
      return text;
    }
  }

  void dispose() {
    _translator?.close();
    _translator = null;
  }
}
