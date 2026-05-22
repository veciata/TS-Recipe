import 'package:dio/dio.dart';
import '../models/search_result.dart';

class DuckDuckGoService {
  final Dio _dio;

  DuckDuckGoService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://api.duckduckgo.com',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  Future<List<SearchResult>> searchRecipes(String query) async {
    final response = await _dio.get('/', queryParameters: {
      'q': '$query recipe',
      'format': 'json',
      'no_html': '1',
      'skip_disambig': '1',
    });

    final data = response.data as Map<String, dynamic>;
    final results = <SearchResult>[];

    final abstractText = data['Abstract'] as String?;
    final abstractUrl = data['AbstractURL'] as String?;
    final abstractSrc = data['AbstractSource'] as String?;
    final image = data['Image'] as String?;

    if (abstractText != null && abstractText.isNotEmpty && abstractUrl != null) {
      final cleanImage = (image != null && image.isNotEmpty && !image.endsWith('/'))
          ? image
          : null;
      results.add(SearchResult(
        title: abstractSrc ?? 'Recipe',
        snippet: abstractText,
        url: abstractUrl,
        imageUrl: cleanImage,
      ));
    }

    final apiResults = data['Results'] as List<dynamic>? ?? [];
    for (final item in apiResults) {
      final map = item as Map<String, dynamic>;
      final icon = map['Icon'] as Map<String, dynamic>?;
      final iconUrl = icon?['URL'] as String?;
      results.add(SearchResult(
        title: _stripHtml(map['Text'] as String? ?? ''),
        snippet: '',
        url: map['FirstURL'] as String? ?? '',
        imageUrl: (iconUrl != null && iconUrl.isNotEmpty) ? 'https:$iconUrl' : null,
      ));
    }

    final topics = data['RelatedTopics'] as List<dynamic>? ?? [];
    for (final item in topics) {
      final map = item as Map<String, dynamic>;
      if (map.containsKey('Topics')) {
        final subTopics = map['Topics'] as List<dynamic>;
        for (final sub in subTopics) {
          final subMap = sub as Map<String, dynamic>;
          final icon = subMap['Icon'] as Map<String, dynamic>?;
          final iconUrl = icon?['URL'] as String?;
          results.add(SearchResult(
            title: _stripHtml(subMap['Text'] as String? ?? ''),
            snippet: '',
            url: subMap['FirstURL'] as String? ?? '',
            imageUrl: (iconUrl != null && iconUrl.isNotEmpty) ? 'https:$iconUrl' : null,
          ));
        }
      } else {
        final icon = map['Icon'] as Map<String, dynamic>?;
        final iconUrl = icon?['URL'] as String?;
        results.add(SearchResult(
          title: _stripHtml(map['Text'] as String? ?? ''),
          snippet: '',
          url: map['FirstURL'] as String? ?? '',
          imageUrl: (iconUrl != null && iconUrl.isNotEmpty) ? 'https:$iconUrl' : null,
        ));
      }
    }

    return results;
  }

  String _stripHtml(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }
}
