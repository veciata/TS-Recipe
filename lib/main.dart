import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'providers/settings_provider.dart';
import 'providers/local_storage_provider.dart';
import 'providers/translation_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(
    ProviderScope(
      child: _RecipesyInitializer(child: const RecipesyApp()),
    ),
  );
}

class _RecipesyInitializer extends ConsumerStatefulWidget {
  final Widget child;
  const _RecipesyInitializer({required this.child});

  @override
  ConsumerState<_RecipesyInitializer> createState() => _RecipesyInitializerState();
}

class _RecipesyInitializerState extends ConsumerState<_RecipesyInitializer> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final settingsService = ref.read(settingsServiceProvider);
    final storageService = ref.read(storageServiceProvider);
    await settingsService.init();
    await storageService.init();
    if (!settingsService.hasDefaults) {
      await storageService.initDefaults();
      await settingsService.markDefaultsCreated();
    }
    final translationService = ref.read(translationServiceProvider);
    await translationService.init();
    setState(() => _initialized = true);
  }

  @override
  Widget build(BuildContext context) {
    return _initialized ? widget.child : const SplashScreen();
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TS Recipe',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/logo.png', width: 200, height: 109),
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
