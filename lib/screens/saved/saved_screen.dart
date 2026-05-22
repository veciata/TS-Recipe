import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/saved_category.dart';
import '../../providers/saved_provider.dart';
import '../../widgets/saved_category_card.dart';

class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final categories = ref.watch(savedCategoriesProvider);
    final savedRecipes = ref.watch(savedRecipesProvider);

    if (savedRecipes.isEmpty && categories.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.savedRecipes)),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bookmark_border, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(l10n.noSavedRecipes, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(l10n.noSavedRecipesHint, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      );
    }

    final allCategories = [
      SavedCategory(
        id: 'uncategorized',
        name: l10n.uncategorized,
        icon: 'bookmark',
        colorValue: 0xFF9E9E9E,
      ),
      ...categories,
    ];

    return Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/logo.png', height: 32),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: l10n.manageCategories,
            onPressed: () => context.push('/manage-categories'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ...allCategories.map((cat) {
            final count = cat.id == 'uncategorized'
                ? savedRecipes.where((r) => r.categoryId == 'uncategorized' || r.categoryId.isEmpty).length
                : savedRecipes.where((r) => r.categoryId == cat.id).length;
            if (count == 0 && cat.id == 'uncategorized') {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SavedCategoryCard(
                category: cat,
                recipeCount: count,
                onTap: () => context.push('/saved-category', extra: {'id': cat.id, 'name': cat.name}),
              ),
            );
          }),
        ],
      ),
    );
  }
}
