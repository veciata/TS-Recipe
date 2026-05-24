import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseService {
  static final LocalDatabaseService _instance = LocalDatabaseService._internal();
  factory LocalDatabaseService() => _instance;
  LocalDatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tsresepy.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Categories table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    // Recipes table
    await db.execute('''
      CREATE TABLE recipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        ingredients TEXT,
        instructions TEXT,
        imageUrl TEXT,
        categoryId INTEGER,
        isMyRecipe INTEGER DEFAULT 0,
        isPending INTEGER DEFAULT 0,
        likes INTEGER DEFAULT 0,
        createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (categoryId) REFERENCES categories (id)
      )
    ''');

    // FTS5 virtual table for search
    await db.execute('''
      CREATE VIRTUAL TABLE recipes_fts USING fts5(
        title,
        description,
        ingredients,
        instructions,
        content='recipes',
        content_rowid='id'
      )
    ''');

    // Triggers to keep FTS5 in sync
    await db.execute('''
      CREATE TRIGGER recipes_ai AFTER INSERT ON recipes BEGIN
        INSERT INTO recipes_fts(rowid, title, description, ingredients, instructions)
        VALUES (new.id, new.title, new.description, new.ingredients, new.instructions);
      END;
    ''');

    await db.execute('''
      CREATE TRIGGER recipes_ad AFTER DELETE ON recipes BEGIN
        INSERT INTO recipes_fts(recipes_fts, rowid, title, description, ingredients, instructions)
        VALUES('delete', old.id, old.title, old.description, old.ingredients, old.instructions);
      END;
    ''');

    await db.execute('''
      CREATE TRIGGER recipes_au AFTER UPDATE ON recipes BEGIN
        INSERT INTO recipes_fts(recipes_fts, rowid, title, description, ingredients, instructions)
        VALUES('delete', old.id, old.title, old.description, old.ingredients, old.instructions);
        INSERT INTO recipes_fts(rowid, title, description, ingredients, instructions)
        VALUES (new.id, new.title, new.description, new.ingredients, new.instructions);
      END;
    ''');
  }

  // Categories
  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db.query('categories');
  }

  Future<int> createCategory(Map<String, dynamic> category) async {
    final db = await database;
    return await db.insert('categories', category);
  }

  Future<void> updateCategory(Map<String, dynamic> category) async {
    final db = await database;
    await db.update(
      'categories',
      category,
      where: 'id = ?',
      whereArgs: [category['id']],
    );
  }

  Future<void> deleteCategory(int id) async {
    final db = await database;
    await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Recipes
  Future<List<Map<String, dynamic>>> getRecipes() async {
    final db = await database;
    return await db.query('recipes');
  }

  Future<Map<String, dynamic>?> getRecipeById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> getMyRecipes() async {
    final db = await database;
    return await db.query(
      'recipes',
      where: 'isMyRecipe = ?',
      whereArgs: [1],
    );
  }

  Future<List<Map<String, dynamic>>> getPendingRecipes() async {
    final db = await database;
    return await db.query(
      'recipes',
      where: 'isPending = ?',
      whereArgs: [1],
    );
  }

  Future<int> createRecipe(Map<String, dynamic> recipe) async {
    final db = await database;
    return await db.insert('recipes', recipe);
  }

  Future<void> updateRecipe(Map<String, dynamic> recipe) async {
    final db = await database;
    await db.update(
      'recipes',
      recipe,
      where: 'id = ?',
      whereArgs: [recipe['id']],
    );
  }

  Future<void> deleteRecipe(int id) async {
    final db = await database;
    await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> likeRecipe(int id) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE recipes SET likes = likes + 1 WHERE id = ?',
      [id],
    );
  }

  Future<void> saveRecipeFromJson(Map<String, dynamic> data) async {
    final existingId = data['id'];
    if (existingId != null) {
      final existing = await getRecipeById(int.tryParse(existingId.toString()) ?? -1);
      if (existing != null) {
        await updateRecipe({
          ...existing,
          ..._recipeRowFromJson(data),
          'id': existing['id'],
        });
        return;
      }
    }
    await createRecipe(_recipeRowFromJson(data));
  }

  Map<String, dynamic> _recipeRowFromJson(Map<String, dynamic> data) => {
        if (data.containsKey('title') || data.containsKey('name'))
          'title': data['title'] ?? data['name'],
        'description': data['description'],
        'ingredients': data['ingredients'] is String
            ? data['ingredients']
            : (data['ingredients'] as List?)?.join('\n'),
        'instructions': data['instructions'],
        'imageUrl': data['imageUrl'] ?? data['image_url'],
        'categoryId': data['categoryId'] ?? data['category_id'],
        'isMyRecipe': data['isMyRecipe'] ?? data['is_my_recipe'] ?? 1,
        'isPending': data['isPending'] ?? data['is_pending'] ?? 0,
        'likes': data['likes'] ?? 0,
      };

  Future<List<Map<String, dynamic>>> searchRecipes(String query) async {
    final db = await database;
    // Use FTS5 for search
    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT recipes.* FROM recipes
      JOIN recipes_fts ON recipes.id = recipes_fts.rowid
      WHERE recipes_fts MATCH ?
    ''', [query]);
    return results;
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}