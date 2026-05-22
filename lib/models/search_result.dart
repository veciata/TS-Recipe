class SearchResult {
  final String title;
  final String snippet;
  final String url;
  final String? imageUrl;

  const SearchResult({
    required this.title,
    required this.snippet,
    required this.url,
    this.imageUrl,
  });
}
