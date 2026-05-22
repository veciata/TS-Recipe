import 'package:hive_flutter/hive_flutter.dart';

class SettingsService {
  static const _boxName = 'settings';
  late Box<String> _box;

  Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  String getLanguageCode() => _box.get('language', defaultValue: 'tr')!;
  Future<void> setLanguageCode(String code) => _box.put('language', code);

  int getThemeColor() => int.parse(_box.get('themeColor', defaultValue: '0xFF6750A4')!);
  Future<void> setThemeColor(int color) => _box.put('themeColor', color.toString());

  bool getDarkMode() => _box.get('darkMode', defaultValue: 'false') == 'true';
  Future<void> setDarkMode(bool value) => _box.put('darkMode', value.toString());

  bool get hasDefaults => _box.get('defaultsCreated', defaultValue: '') == 'true';
  Future<void> markDefaultsCreated() => _box.put('defaultsCreated', 'true');
}
