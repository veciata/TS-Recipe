import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/settings_service.dart';
import '../core/theme/app_theme.dart';

final settingsServiceProvider = Provider<SettingsService>((ref) => SettingsService());

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final service = ref.watch(settingsServiceProvider);
  return LocaleNotifier(service);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final SettingsService _service;

  LocaleNotifier(this._service) : super(Locale(_service.getLanguageCode()));

  Future<void> setLocale(String languageCode) async {
    await _service.setLanguageCode(languageCode);
    state = Locale(languageCode);
  }
}

final themeColorProvider = StateNotifierProvider<ThemeColorNotifier, int>((ref) {
  final service = ref.watch(settingsServiceProvider);
  return ThemeColorNotifier(service);
});

class ThemeColorNotifier extends StateNotifier<int> {
  final SettingsService _service;

  ThemeColorNotifier(this._service) : super(_service.getThemeColor());

  Future<void> setColor(int color) async {
    await _service.setThemeColor(color);
    state = color;
  }
}

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref) {
  final service = ref.watch(settingsServiceProvider);
  return DarkModeNotifier(service);
});

class DarkModeNotifier extends StateNotifier<bool> {
  final SettingsService _service;

  DarkModeNotifier(this._service) : super(_service.getDarkMode());

  Future<void> toggle() async {
    final newValue = !state;
    await _service.setDarkMode(newValue);
    state = newValue;
  }
}

final themeModeProvider = Provider<ThemeMode>((ref) {
  final darkMode = ref.watch(darkModeProvider);
  return darkMode ? ThemeMode.dark : ThemeMode.light;
});

final themeDataProvider = Provider<ThemeData>((ref) {
  final color = ref.watch(themeColorProvider);
  final darkMode = ref.watch(darkModeProvider);
  return darkMode ? AppTheme.darkTheme(color) : AppTheme.lightTheme(color);
});
