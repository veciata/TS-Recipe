import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/localization/app_localizations.dart';
import 'providers/settings_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/category_recipes_screen.dart';
import 'screens/home/world_cuisines_screen.dart';
import 'screens/recipe_detail/recipe_detail_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/saved/saved_screen.dart';
import 'screens/saved/saved_category_recipes_screen.dart';
import 'screens/saved/manage_categories_screen.dart';
import 'screens/settings/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/search',
            pageBuilder: (context, state) => const NoTransitionPage(child: SearchScreen()),
          ),
          GoRoute(
            path: '/saved',
            pageBuilder: (context, state) => const NoTransitionPage(child: SavedScreen()),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(child: SettingsScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/category',
        builder: (context, state) => CategoryRecipesScreen(category: state.extra as String),
      ),
      GoRoute(
        path: '/recipe',
        builder: (context, state) => RecipeDetailScreen(recipeId: state.extra as String),
      ),
      GoRoute(
        path: '/saved-category',
        builder: (context, state) {
          final args = state.extra as Map<String, String>;
          return SavedCategoryRecipesScreen(
            categoryId: args['id']!,
            categoryName: args['name']!,
          );
        },
      ),
      GoRoute(
        path: '/world-cuisines',
        builder: (context, state) => const WorldCuisinesScreen(),
      ),
      GoRoute(
        path: '/manage-categories',
        builder: (context, state) => const ManageCategoriesScreen(),
      ),
    ],
  );
});

class RecipesyApp extends ConsumerWidget {
  const RecipesyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final theme = ref.watch(themeDataProvider);

    return MaterialApp.router(
      title: 'recipesy',
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: theme,
      routerConfig: router,
    );
  }
}

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;
    if (location.startsWith('/search')) currentIndex = 1;
    if (location.startsWith('/saved')) currentIndex = 2;
    if (location.startsWith('/settings')) currentIndex = 3;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) {
          switch (i) {
            case 0: context.go('/');
            case 1: context.go('/search');
            case 2: context.go('/saved');
            case 3: context.go('/settings');
          }
        },
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: l10n.home),
          NavigationDestination(icon: const Icon(Icons.search_outlined), selectedIcon: const Icon(Icons.search), label: l10n.search),
          NavigationDestination(icon: const Icon(Icons.bookmark_outline), selectedIcon: const Icon(Icons.bookmark), label: l10n.saved),
          NavigationDestination(icon: const Icon(Icons.settings_outlined), selectedIcon: const Icon(Icons.settings), label: l10n.settings),
        ],
      ),
    );
  }
}
