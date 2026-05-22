import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/translation_service.dart';

final translationServiceProvider = Provider<TranslationService>((ref) => TranslationService());
