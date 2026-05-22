import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/saved_category.dart';
import '../models/saved_recipe.dart';
import '../services/storage_service.dart';
import 'local_storage_provider.dart';

final savedCategoriesProvider = StateNotifierProvider<SavedCategoriesNotifier, List<SavedCategory>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return SavedCategoriesNotifier(storage);
});

class SavedCategoriesNotifier extends StateNotifier<List<SavedCategory>> {
  final StorageService _storage;

  SavedCategoriesNotifier(this._storage) : super(_storage.getCategories());

  void refresh() {
    state = _storage.getCategories();
  }

  Future<void> add(SavedCategory category) async {
    await _storage.saveCategory(category);
    refresh();
  }

  Future<void> update(SavedCategory category) async {
    await _storage.updateCategory(category);
    refresh();
  }

  Future<void> delete(String id) async {
    await _storage.deleteCategory(id);
    refresh();
  }
}

final savedRecipesProvider = StateNotifierProvider<SavedRecipesNotifier, List<SavedRecipe>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return SavedRecipesNotifier(storage);
});

class SavedRecipesNotifier extends StateNotifier<List<SavedRecipe>> {
  final StorageService _storage;

  SavedRecipesNotifier(this._storage) : super(_storage.getAllRecipes());

  void refresh() {
    state = _storage.getAllRecipes();
  }

  bool isSaved(String id) => _storage.isRecipeSaved(id);

  Future<void> save(SavedRecipe recipe) async {
    await _storage.saveRecipe(recipe);
    refresh();
  }

  Future<void> remove(String id) async {
    await _storage.removeRecipe(id);
    refresh();
  }

  List<SavedRecipe> getByCategory(String categoryId) {
    return state.where((r) => r.categoryId == categoryId).toList();
  }
}

final recipesInCategoryProvider = Provider.family<List<SavedRecipe>, String>((ref, categoryId) {
  final recipes = ref.watch(savedRecipesProvider);
  return recipes.where((r) => r.categoryId == categoryId).toList();
});

final isRecipeSavedProvider = Provider.family<bool, String>((ref, id) {
  final recipes = ref.watch(savedRecipesProvider);
  return recipes.any((r) => r.id == id);
});
