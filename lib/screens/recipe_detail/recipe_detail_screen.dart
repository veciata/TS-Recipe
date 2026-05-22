import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/url_launcher_service.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/saved_recipe.dart';
import '../../providers/recipe_provider.dart';
import '../../providers/saved_provider.dart';
import '../../models/recipe.dart';
import '../../providers/translation_provider.dart';
import '../../services/translation_service.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  List<String> _translatedIngredients = [];
  String _translatedInstructions = '';
  bool _translating = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final recipeAsync = ref.watch(recipeDetailProvider(widget.recipeId));
    final isSaved = ref.watch(isRecipeSavedProvider(widget.recipeId));
    final translationService = ref.read(translationServiceProvider);

    ref.listen(recipeDetailProvider(widget.recipeId), (_, next) {
      next.whenData((recipe) => _translateIfNeeded(recipe, translationService));
    });

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/logo.png', height: 32),
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () => _toggleSave(context, ref, recipeAsync, isSaved),
          ),
        ],
      ),
      body: recipeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('${l10n.errorOccurred}: $err')),
        data: (recipe) {
          final ingredients = _translatedIngredients.isNotEmpty
              ? _translatedIngredients
              : recipe.ingredients;
          final instructions = _translatedInstructions.isNotEmpty
              ? _translatedInstructions
              : recipe.instructions;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: recipe.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => const Center(child: CircularProgressIndicator()),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildChip(context, Icons.restaurant, l10n.translateCategory(recipe.category)),
                          const SizedBox(width: 8),
                          if (recipe.area.isNotEmpty)
                            _buildChip(context, Icons.public, l10n.translateArea(recipe.area)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Text(l10n.ingredients, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                          if (_translating)
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(ingredients.length, (i) {
                        final measure = i < recipe.measures.length ? recipe.measures[i] : '';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              const Icon(Icons.circle, size: 6),
                              const SizedBox(width: 8),
                              Expanded(child: Text('$ingredients[$i] — $measure')),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Text(l10n.instructions, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                          if (_translating)
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(instructions, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
                      const SizedBox(height: 24),
                      if (recipe.sourceUrl != null || recipe.youtubeUrl != null)
                        Row(
                          children: [
                            if (recipe.sourceUrl != null)
                              _buildLinkButton(context, l10n.source, Icons.language, () => _launchUrl(recipe.sourceUrl!)),
                            const SizedBox(width: 12),
                            if (recipe.youtubeUrl != null)
                              _buildLinkButton(context, l10n.youTube, Icons.play_circle, () => _launchUrl(recipe.youtubeUrl!)),
                          ],
                        ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _translateIfNeeded(Recipe recipe, TranslationService service) async {
    if (_translatedInstructions.isNotEmpty) return;
    setState(() => _translating = true);
    final translated = await service.translate(recipe.instructions);
    final translatedIngredients = <String>[];
    for (final ing in recipe.ingredients) {
      translatedIngredients.add(await service.translate(ing));
    }
    if (mounted) {
      setState(() {
        _translatedInstructions = translated;
        _translatedIngredients = translatedIngredients;
        _translating = false;
      });
    }
  }

  Widget _buildChip(BuildContext context, IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildLinkButton(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }

  Future<void> _launchUrl(String url) async {
    await UrlLauncherService.launch(url, external: true);
  }

  Future<void> _toggleSave(BuildContext context, WidgetRef ref, AsyncValue recipeAsync, bool isSaved) async {
    final l10n = AppLocalizations.of(context);
    if (isSaved) {
      ref.read(savedRecipesProvider.notifier).remove(widget.recipeId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.removedFromSaved)),
        );
      }
    } else {
      final recipe = recipeAsync.valueOrNull;
      if (recipe == null) return;
      final categories = ref.read(savedCategoriesProvider);
      final targetCategory = categories.isNotEmpty ? categories.first.id : 'uncategorized';
      final saved = SavedRecipe.fromRecipe(recipe, targetCategory);
      ref.read(savedRecipesProvider.notifier).save(saved);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${recipe.name} ${l10n.savedToCategory.replaceAll('{category}', categories.isNotEmpty ? categories.first.name : '')}')),
        );
      }
    }
  }
}
