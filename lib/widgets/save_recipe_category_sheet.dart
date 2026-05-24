import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/localization/app_localizations.dart';
import '../models/saved_category.dart';
import '../providers/saved_provider.dart';

/// Shows a bottom sheet to pick which saved section/category to store a recipe in.
/// Returns the selected category id, or null if dismissed.
Future<String?> showSaveRecipeCategorySheet(
  BuildContext context,
  WidgetRef ref,
) {
  final l10n = AppLocalizations.of(context);
  final categories = ref.read(savedCategoriesProvider);
  final savedRecipes = ref.read(savedRecipesProvider);

  final sections = [
    SavedCategory(
      id: 'uncategorized',
      name: l10n.uncategorized,
      icon: 'bookmark',
      colorValue: 0xFF9E9E9E,
    ),
    ...categories,
  ];

  int countFor(String categoryId) {
    if (categoryId == 'uncategorized') {
      return savedRecipes
          .where((r) => r.categoryId == 'uncategorized' || r.categoryId.isEmpty)
          .length;
    }
    return savedRecipes.where((r) => r.categoryId == categoryId).length;
  }

  String displayName(SavedCategory cat) {
    if (cat.id == 'uncategorized') return l10n.uncategorized;
    return l10n.translateMealCategory(cat.name);
  }

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      final maxHeight = MediaQuery.sizeOf(sheetContext).height * 0.55;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.saveToSection,
                style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.saveToSectionHint,
                style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(sheetContext).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: sections.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final cat = sections[index];
                    final color = Color(cat.colorValue);
                    final count = countFor(cat.id);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color.withValues(alpha: 0.2),
                        child: Icon(Icons.bookmark, color: color, size: 22),
                      ),
                      title: Text(displayName(cat)),
                      subtitle: Text(l10n.recipeCount(count)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.pop(sheetContext, cat.id),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
