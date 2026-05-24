import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/app_localizations.dart';
import '../../models/recipe.dart';
import '../../models/saved_recipe.dart';
import '../../providers/saved_provider.dart';
import '../../services/api_client.dart';
import '../../services/local_database_service.dart';
import '../../services/online_search_service.dart';
import '../../widgets/save_recipe_category_sheet.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  List<Recipe> _localResults = [];
  List<Recipe> _serverResults = [];
  List<Recipe> _onlineResults = [];
  List<Recipe> _combinedResults = [];
  bool _isLocalLoading = false;
  bool _isServerLoading = false;
  bool _isOnlineLoading = false;
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchRecipes(String query) async {
    if (query.isEmpty) {
      setState(() {
        _localResults = [];
        _serverResults = [];
        _onlineResults = [];
        _combinedResults = [];
        _isLocalLoading = false;
        _isServerLoading = false;
        _isOnlineLoading = false;
        _isSearching = false;
      });
      return;
    }

    final language = Localizations.localeOf(context).languageCode;

    setState(() {
      _isLocalLoading = true;
      _isServerLoading = true;
      _isOnlineLoading = true;
      _isSearching = true;
    });

    try {
      final localRows = await LocalDatabaseService().searchRecipes(query);
      if (mounted) {
        setState(() {
          _localResults =
              localRows.map((row) => Recipe.fromLocalRow(row)).toList();
          _isLocalLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLocalLoading = false);
    }

    try {
      final serverResults =
          await ApiClient().searchRecipes(query, language: language);
      if (mounted) {
        setState(() {
          _serverResults = serverResults;
          _isServerLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isServerLoading = false);
    }

    try {
      final onlineResults = await OnlineSearchService().searchRecipes(query);
      if (mounted) {
        setState(() {
          _onlineResults = onlineResults;
          _isOnlineLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isOnlineLoading = false);
    }

    if (mounted) {
      setState(() {
        _combinedResults = _mergeAndDeduplicate(
          [_localResults, _serverResults, _onlineResults],
        );
        _isSearching = false;
      });
    }
  }

  List<Recipe> _mergeAndDeduplicate(List<List<Recipe>> resultLists) {
    final seenIds = <String>{};
    final combined = <Recipe>[];

    for (final list in resultLists) {
      for (final recipe in list) {
        final id = recipe.id;
        if (id.isNotEmpty && !seenIds.contains(id)) {
          seenIds.add(id);
          combined.add(recipe);
        }
      }
    }

    return combined;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final savedRecipes = ref.watch(savedRecipesProvider);

    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/logo.png', height: 32)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchRecipes,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchRecipes('');
                        },
                      )
                    : null,
              ),
              onChanged: _searchRecipes,
            ),
          ),
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: _isLocalLoading ? Colors.blue : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: _isServerLoading ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: _isOnlineLoading ? Colors.orange : Colors.grey,
                  ),
                ],
              ),
            ),
          Expanded(
            child: _isSearching && _combinedResults.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _combinedResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(l10n.noResults),
                            Text(l10n.tryDifferentSearch,
                                style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _combinedResults.length,
                        itemBuilder: (context, index) {
                          final recipe = _combinedResults[index];
                          final isSaved =
                              savedRecipes.any((r) => r.id == recipe.id);
                          return _SearchRecipeCard(
                            recipe: recipe,
                            isSaved: isSaved,
                            onSave: () => _saveRecipe(recipe),
                            onTap: () =>
                                context.push('/recipe', extra: recipe.id),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveRecipe(Recipe recipe) async {
    final l10n = AppLocalizations.of(context);
    final categoryId = await showSaveRecipeCategorySheet(context, ref);
    if (categoryId == null || !mounted) return;

    final categories = ref.read(savedCategoriesProvider);
    final saved = SavedRecipe.fromRecipe(recipe, categoryId);
    ref.read(savedRecipesProvider.notifier).save(saved);

    final categoryName = categoryId == 'uncategorized'
        ? l10n.uncategorized
        : categories
            .where((c) => c.id == categoryId)
            .map((c) => l10n.translateMealCategory(c.name))
            .firstOrNull ?? l10n.uncategorized;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.savedToCategory.replaceAll('{category}', categoryName),
          ),
        ),
      );
    }
  }
}

class _SearchRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isSaved;
  final VoidCallback onSave;
  final VoidCallback onTap;

  const _SearchRecipeCard({
    required this.recipe,
    required this.isSaved,
    required this.onSave,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: recipe.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (_, _, _) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Icon(Icons.restaurant, color: Colors.grey[400]),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (recipe.area.isNotEmpty) ...[
                          Icon(Icons.flag, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            l10n.translateArea(recipe.area),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (recipe.category.isNotEmpty) ...[
                          Icon(Icons.category,
                              size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            l10n.translateCategory(recipe.category),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: isSaved ? Theme.of(context).colorScheme.primary : null,
                ),
                onPressed: onSave,
                tooltip: isSaved ? 'Kaydedildi' : 'Kaydet',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
