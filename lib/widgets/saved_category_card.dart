import 'package:flutter/material.dart';
import '../models/saved_category.dart';

class SavedCategoryCard extends StatelessWidget {
  final SavedCategory category;
  final int recipeCount;
  final VoidCallback onTap;

  const SavedCategoryCard({
    super.key,
    required this.category,
    required this.recipeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(category.colorValue);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.2),
                child: Icon(_getIcon(category.icon), color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '$recipeCount tarif',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'bookmark': return Icons.bookmark;
      case 'favorite': return Icons.favorite;
      case 'star': return Icons.star;
      case 'restaurant': return Icons.restaurant;
      case 'menu_book': return Icons.menu_book;
      case 'local_pizza': return Icons.local_pizza;
      case 'bakery_dining': return Icons.bakery_dining;
      case 'ramen_dining': return Icons.ramen_dining;
      case 'lunch_dining': return Icons.lunch_dining;
      case 'brunch_dining': return Icons.brunch_dining;
      default: return Icons.bookmark;
    }
  }
}
