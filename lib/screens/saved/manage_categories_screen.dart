import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/constants/app_constants.dart';
import '../../models/saved_category.dart';
import '../../providers/saved_provider.dart';

class ManageCategoriesScreen extends ConsumerWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final categories = ref.watch(savedCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.manageCategories),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, ref, null),
        child: const Icon(Icons.add),
      ),
      body: categories.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(l10n.noSavedRecipes),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final color = Color(cat.colorValue);
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withValues(alpha: 0.2),
                      child: Icon(Icons.bookmark, color: color, size: 20),
                    ),
                    title: Text(cat.name),
                    subtitle: Text(l10n.recipeCount(0)),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showCategoryDialog(context, ref, cat);
                        } else if (value == 'delete') {
                          _confirmDelete(context, ref, cat);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'edit', child: Text(l10n.editCategory)),
                        PopupMenuItem(value: 'delete', child: Text(l10n.deleteCategory)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showCategoryDialog(BuildContext context, WidgetRef ref, SavedCategory? existing) {
    final l10n = AppLocalizations.of(context);
    final nameController = TextEditingController(text: existing?.name ?? '');
    var selectedColor = existing?.colorValue ?? AppColors.themeColors[0];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(existing != null ? l10n.editCategory : l10n.newCategory),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: l10n.categoryName),
              ),
              const SizedBox(height: 16),
              Text(l10n.categoryColor, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppColors.themeColors.map((c) {
                  final isSelected = c == selectedColor;
                  return GestureDetector(
                    onTap: () => setDialogState(() => selectedColor = c),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Color(c),
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                        boxShadow: isSelected
                            ? [BoxShadow(color: Color(c).withValues(alpha: 0.5), blurRadius: 8)]
                            : null,
                      ),
                      child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
            FilledButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                final uuid = const Uuid();
                if (existing != null) {
                  existing.name = nameController.text.trim();
                  existing.colorValue = selectedColor;
                  ref.read(savedCategoriesProvider.notifier).update(existing);
                } else {
                  ref.read(savedCategoriesProvider.notifier).add(SavedCategory(
                    id: uuid.v4(),
                    name: nameController.text.trim(),
                    colorValue: selectedColor,
                  ));
                }
                Navigator.pop(ctx);
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, SavedCategory category) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.areYouSure),
        content: Text(l10n.deleteCategoryWarning),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () {
              ref.read(savedCategoriesProvider.notifier).delete(category.id);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
