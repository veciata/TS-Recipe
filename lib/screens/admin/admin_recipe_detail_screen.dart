import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_client.dart';
import '../../models/recipe.dart';

class AdminRecipeDetailScreen extends ConsumerStatefulWidget {
  final String recipeId;

  const AdminRecipeDetailScreen({super.key, required this.recipeId});

  @override
  ConsumerState<AdminRecipeDetailScreen> createState() => _AdminRecipeDetailScreenState();
}

class _AdminRecipeDetailScreenState extends ConsumerState<AdminRecipeDetailScreen> {
  Recipe? _recipe;
  bool _loading = true;
  bool _actionLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRecipe();
  }

  Future<void> _fetchRecipe() async {
    try {
      final response = await ApiClient().get('/admin/recipes/${widget.recipeId}');
      setState(() {
        _recipe = Recipe.fromJson(response.data as Map<String, dynamic>);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load recipe: $e')),
        );
      }
    }
  }

  Future<void> _approve() async {
    setState(() => _actionLoading = true);
    try {
      await ApiClient().put('/admin/recipes/${widget.recipeId}/approve');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe approved')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to approve: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _reject() async {
    setState(() => _actionLoading = true);
    try {
      await ApiClient().put('/admin/recipes/${widget.recipeId}/reject');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe rejected')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reject: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_recipe?.name ?? 'Recipe Detail')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _recipe == null
              ? const Center(child: Text('Recipe not found'))
              : _buildContent(),
      bottomNavigationBar: _recipe != null && !_loading
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _actionLoading ? null : _approve,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: _actionLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.check),
                        label: const Text('Approve'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _actionLoading ? null : _reject,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: _actionLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.close),
                        label: const Text('Reject'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildContent() {
    final recipe = _recipe!;
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
            errorWidget: (_, _, _) => const Center(child: Icon(Icons.broken_image, size: 64)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildChip(Icons.restaurant, recipe.category),
                    const SizedBox(width: 8),
                    if (recipe.area.isNotEmpty)
                      _buildChip(Icons.public, recipe.area),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Ingredients',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...List.generate(recipe.ingredients.length, (i) {
                  final measure = i < recipe.measures.length ? recipe.measures[i] : '';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 6),
                        const SizedBox(width: 8),
                        Expanded(child: Text('${recipe.ingredients[i]} — $measure')),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),
                Text(
                  'Instructions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(recipe.instructions, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      visualDensity: VisualDensity.compact,
    );
  }
}
