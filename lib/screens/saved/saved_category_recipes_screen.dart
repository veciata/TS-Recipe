import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/saved_provider.dart';
import '../../widgets/recipe_card.dart';
import '../../models/recipe.dart';

class SavedCategoryRecipesScreen extends ConsumerWidget {
  final String categoryId;
  final String categoryName;

  const SavedCategoryRecipesScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recipes = ref.watch(recipesInCategoryProvider(categoryId));

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: recipes.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bookmark_border, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(l10n.noSavedRecipes),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final saved = recipes[index];
                final recipe = Recipe(
                  id: saved.id,
                  name: saved.name,
                  category: saved.category,
                  area: saved.area,
                  instructions: '',
                  imageUrl: saved.imageUrl,
                  ingredients: [],
                  measures: [],
                );
                return RecipeCard(
                  recipe: recipe,
                  onTap: () => context.push('/recipe', extra: recipe.id),
                );
              },
            ),
    );
  }
}
