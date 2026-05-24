import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/localization/app_localizations.dart';
import 'providers/settings_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/category_recipes_screen.dart';
import 'screens/home/world_cuisines_screen.dart';
import 'screens/recipe_detail/recipe_detail_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/saved/saved_screen.dart';
import 'screens/saved/saved_category_recipes_screen.dart';
import 'screens/saved/manage_categories_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_recipe_detail_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.onDispose(refresh.dispose);
  ref.listen(authStateProvider, (previous, next) => refresh.value++);

  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    refreshListenable: refresh,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final canUseApp =
          authState is AuthAuthenticated || authState is AuthGuest;
      final isAuthRoute = state.matchedLocation == '/auth';
      final isLoading = authState is AuthLoading;
      final isAdminRoute = state.matchedLocation.startsWith('/admin');
      final isAdmin = authState is AuthAuthenticated && authState.user.isAdmin;

      if (isLoading) return null;
      if (!canUseApp && !isAuthRoute) return '/auth';
      // Guests may open /auth from Settings; only skip auth when logged in.
      if (authState is AuthAuthenticated && isAuthRoute) return '/';
      if (isAdminRoute && !isAdmin) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AuthScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/search',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SearchScreen()),
          ),
          GoRoute(
            path: '/saved',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SavedScreen()),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SettingsScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/category',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            CategoryRecipesScreen(category: state.extra as String),
      ),
      GoRoute(
        path: '/recipe',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            RecipeDetailScreen(recipeId: state.extra as String),
      ),
      GoRoute(
        path: '/saved-category',
        parentNavigatorKey: _rootNavigatorKey,
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
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const WorldCuisinesScreen(),
      ),
      GoRoute(
        path: '/manage-categories',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ManageCategoriesScreen(),
      ),
      GoRoute(
        path: '/admin-dashboard',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin-recipe',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            AdminRecipeDetailScreen(recipeId: state.extra as String),
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
      title: 'TS Recipe',
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: theme,
      routerConfig: router,
    );
  }
}

class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final location = GoRouterState.of(context).uri.path;
    final authState = ref.watch(authStateProvider);
    final isAdmin =
        authState is AuthAuthenticated && authState.user.isAdmin;

    int currentIndex = 0;
    if (location.startsWith('/search')) currentIndex = 1;
    if (location.startsWith('/saved')) currentIndex = 2;
    if (location.startsWith('/settings')) currentIndex = 3;

    final destinations = <NavigationDestination>[
      NavigationDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home),
        label: l10n.home,
      ),
      NavigationDestination(
        icon: const Icon(Icons.search_outlined),
        selectedIcon: const Icon(Icons.search),
        label: l10n.search,
      ),
      NavigationDestination(
        icon: const Icon(Icons.bookmark_outline),
        selectedIcon: const Icon(Icons.bookmark),
        label: l10n.saved,
      ),
      NavigationDestination(
        icon: const Icon(Icons.settings_outlined),
        selectedIcon: const Icon(Icons.settings),
        label: l10n.settings,
      ),
    ];

    if (isAdmin) {
      destinations.add(
        const NavigationDestination(
          icon: Icon(Icons.admin_panel_settings_outlined),
          selectedIcon: Icon(Icons.admin_panel_settings),
          label: 'Admin',
        ),
      );
      if (location.startsWith('/admin-dashboard')) {
        currentIndex = destinations.length - 1;
      }
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex.clamp(0, destinations.length - 1),
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.go('/');
            case 1:
              context.go('/search');
            case 2:
              context.go('/saved');
            case 3:
              context.go('/settings');
            case 4:
              context.go('/admin-dashboard');
          }
        },
        destinations: destinations,
      ),
    );
  }
}
