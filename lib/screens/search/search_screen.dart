import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/recipe.dart';
import '../../models/saved_recipe.dart';
import '../../providers/recipe_provider.dart';
import '../../providers/saved_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = _searchController.text.trim();
    final resultsAsync = query.isNotEmpty ? ref.watch(searchResultsProvider(query)) : null;
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
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: resultsAsync == null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(l10n.searchRecipes),
                      ],
                    ),
                  )
                : resultsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(child: Text('${l10n.errorOccurred}: $err')),
                    data: (results) {
                      if (results.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(l10n.noResults),
                              Text(l10n.tryDifferentSearch, style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final recipe = results[index];
                          final isSaved = savedRecipes.any((r) => r.id == recipe.id);
                          return _SearchRecipeCard(
                            recipe: recipe,
                            isSaved: isSaved,
                            onSave: () => _saveRecipe(recipe),
                            onTap: () => context.push('/recipe', extra: recipe.id),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveRecipe(Recipe recipe) async {
    final categories = ref.read(savedCategoriesProvider);
    final targetId = categories.isNotEmpty ? categories.first.id : 'uncategorized';
    final saved = SavedRecipe.fromRecipe(recipe, targetId);
    ref.read(savedRecipesProvider.notifier).save(saved);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${recipe.name}" kaydedildi')),
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
                    width: 80, height: 80,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (_, _, _) => Container(
                    width: 80, height: 80,
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
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (recipe.area.isNotEmpty) ...[
                          Icon(Icons.flag, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            l10n.translateArea(recipe.area),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (recipe.category.isNotEmpty) ...[
                          Icon(Icons.category, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            l10n.translateCategory(recipe.category),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
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
