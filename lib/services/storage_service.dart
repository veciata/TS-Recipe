import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/saved_category.dart';
import '../models/saved_recipe.dart';

class StorageService {
  static const _categoriesBoxName = 'saved_categories';
  static const _recipesBoxName = 'saved_recipes';

  late Box<String> _categoriesBox;
  late Box<String> _recipesBox;

  Future<void> init() async {
    _categoriesBox = await Hive.openBox<String>(_categoriesBoxName);
    _recipesBox = await Hive.openBox<String>(_recipesBoxName);
  }

  Future<void> initDefaults() async {
    if (_categoriesBox.isNotEmpty) return;
    final uuid = const Uuid();
    final defaults = [
      SavedCategory(id: uuid.v4(), name: 'Kahvaltı', icon: 'brunch_dining', colorValue: 0xFFFFB300),
      SavedCategory(id: uuid.v4(), name: 'Öğle Yemeği', icon: 'lunch_dining', colorValue: 0xFF43A047),
      SavedCategory(id: uuid.v4(), name: 'Akşam Yemeği', icon: 'restaurant', colorValue: 0xFFE53935),
      SavedCategory(id: uuid.v4(), name: 'Çay', icon: 'local_pizza', colorValue: 0xFF5E35B1),
      SavedCategory(id: uuid.v4(), name: 'Ara Öğün', icon: 'bakery_dining', colorValue: 0xFF1E88E5),
    ];
    for (final cat in defaults) {
      await saveCategory(cat);
    }
  }

  List<SavedCategory> getCategories() {
    return _categoriesBox.values.map((v) {
      return SavedCategory.fromJson(jsonDecode(v) as Map<String, dynamic>);
    }).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> saveCategory(SavedCategory category) async {
    await _categoriesBox.put(category.id, jsonEncode(category.toJson()));
  }

  Future<void> deleteCategory(String id) async {
    final recipes = getRecipesByCategory(id);
    for (final r in recipes) {
      r.categoryId = 'uncategorized';
      await saveRecipe(r);
    }
    await _categoriesBox.delete(id);
  }

  Future<void> updateCategory(SavedCategory category) async {
    await _categoriesBox.put(category.id, jsonEncode(category.toJson()));
  }

  List<SavedRecipe> getRecipesByCategory(String categoryId) {
    return _recipesBox.values.map((v) {
      return SavedRecipe.fromJson(jsonDecode(v) as Map<String, dynamic>);
    }).where((r) => r.categoryId == categoryId).toList()
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  List<SavedRecipe> getAllRecipes() {
    return _recipesBox.values.map((v) {
      return SavedRecipe.fromJson(jsonDecode(v) as Map<String, dynamic>);
    }).toList()..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  bool isRecipeSaved(String id) {
    return _recipesBox.containsKey(id);
  }

  Future<void> saveRecipe(SavedRecipe recipe) async {
    await _recipesBox.put(recipe.id, jsonEncode(recipe.toJson()));
  }

  Future<void> removeRecipe(String id) async {
    await _recipesBox.delete(id);
  }

  Future<void> moveRecipeToCategory(String id, String newCategoryId) async {
    final json = _recipesBox.get(id);
    if (json != null) {
      final recipe = SavedRecipe.fromJson(jsonDecode(json) as Map<String, dynamic>);
      recipe.categoryId = newCategoryId;
      await saveRecipe(recipe);
    }
  }
}
