# Graph Report - .  (2026-05-24)

## Corpus Check
- Corpus is ~43,062 words - fits in a single context window. You may not need a graph.

## Summary
- 416 nodes · 517 edges · 51 communities (40 shown, 11 thin omitted)
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 46 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Linux Build System|Linux Build System]]
- [[_COMMUNITY_App Icon Assets|App Icon Assets]]
- [[_COMMUNITY_State Management & Theme|State Management & Theme]]
- [[_COMMUNITY_Dependencies & Services|Dependencies & Services]]
- [[_COMMUNITY_UI Navigation & Shell|UI Navigation & Shell]]
- [[_COMMUNITY_Data API Layer|Data API Layer]]
- [[_COMMUNITY_Plugin Registration|Plugin Registration]]
- [[_COMMUNITY_Windows Platform Shell|Windows Platform Shell]]
- [[_COMMUNITY_Localization System|Localization System]]
- [[_COMMUNITY_App Initialization|App Initialization]]
- [[_COMMUNITY_Recipe Detail UI|Recipe Detail UI]]
- [[_COMMUNITY_Search Screen|Search Screen]]
- [[_COMMUNITY_Category Recipes|Category Recipes]]
- [[_COMMUNITY_World Cuisines|World Cuisines]]
- [[_COMMUNITY_Saved Category Card|Saved Category Card]]
- [[_COMMUNITY_Saved Screen|Saved Screen]]
- [[_COMMUNITY_Home Screen|Home Screen]]
- [[_COMMUNITY_iOS App Delegate|iOS App Delegate]]
- [[_COMMUNITY_Saved Category Recipes|Saved Category Recipes]]
- [[_COMMUNITY_Windows Entry Point|Windows Entry Point]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 33|Community 33]]
- [[_COMMUNITY_Community 34|Community 34]]
- [[_COMMUNITY_Community 35|Community 35]]

## God Nodes (most connected - your core abstractions)
1. `TSResepy App Icon Design` - 33 edges
2. `package:flutter/material.dart` - 18 edges
3. `TS Recipe` - 17 edges
4. `package:flutter_riverpod/flutter_riverpod.dart` - 16 edges
5. `linux/CMakeLists.txt (Top-Level)` - 16 edges
6. `windows/CMakeLists.txt (Top-Level)` - 14 edges
7. `flutter (INTERFACE Library Target)` - 13 edges
8. `../core/localization/app_localizations.dart` - 11 edges
9. `linux/flutter/CMakeLists.txt` - 10 edges
10. `flutter_assemble (Custom Build Target)` - 9 edges

## Surprising Connections (you probably didn't know these)
- `TS Recipe` --references--> `App Logo`  [EXTRACTED]
  README.md → assets/logo.png
- `Web Favicon (PNG)` --conceptually_related_to--> `TSResepy App Icon Design`  [INFERRED]
  web/favicon.png → assets/logo.png
- `Web App Icon 192px` --conceptually_related_to--> `TSResepy App Icon Design`  [INFERRED]
  web/icons/Icon-192.png → assets/logo.png
- `Web App Icon 512px` --conceptually_related_to--> `TSResepy App Icon Design`  [INFERRED]
  web/icons/Icon-512.png → assets/logo.png
- `Web Maskable App Icon 192px` --conceptually_related_to--> `TSResepy App Icon Design`  [INFERRED]
  web/icons/Icon-maskable-192.png → assets/logo.png

## Hyperedges (group relationships)
- **Recipe Discovery, Save and Translate Flow** — browse_world_cuisines, web_recipe_search, save_to_meal_categories, on_device_translation [INFERRED 0.80]
- **Windows Flutter Desktop Build System** — cmake_windows_top, cmake_windows_flutter, cmake_windows_runner, flutter_windows_dll, flutter_wrapper_plugin, flutter_wrapper_app, tool_backend_bat, flutter_assemble, binary_tsresepy [EXTRACTED 1.00]
- **Linux Flutter Desktop Build System** — cmake_linux_top, cmake_linux_flutter, cmake_linux_runner, flutter_linux_so, gtk_dep, glib_dep, gio_dep, tool_backend_sh, flutter_assemble, binary_tsresepy [EXTRACTED 1.00]
- **Shared Flutter Build Artifacts (Both Platforms)** — flutter_icu_data, aot_library, flutter_assets, native_assets, plugin_bundled_libraries, generated_plugins_cmake, generated_config_cmake, generated_plugin_registrant, ephemeral_dir [EXTRACTED 1.00]
- **Build Configurations: Debug/Profile/Release** — build_config_debug, build_config_profile, build_config_release [EXTRACTED 1.00]
- **Web App Icon Variants** — web_favicon, web_icon_192, web_icon_512, web_icon_maskable_192, web_icon_maskable_512 [EXTRACTED 1.00]
- **Android Launcher Icon Density Variants** — android_ic_launcher_mdpi, android_ic_launcher_hdpi, android_ic_launcher_xhdpi, android_ic_launcher_xxhdpi, android_ic_launcher_xxxhdpi [EXTRACTED 1.00]
- **iOS App Icon Size Variants** — ios_app_icon_20_1x, ios_app_icon_20_2x, ios_app_icon_20_3x, ios_app_icon_29_1x, ios_app_icon_29_2x, ios_app_icon_29_3x, ios_app_icon_40_1x, ios_app_icon_40_2x, ios_app_icon_40_3x, ios_app_icon_60_2x, ios_app_icon_60_3x, ios_app_icon_76_1x, ios_app_icon_76_2x, ios_app_icon_83_5_2x, ios_app_icon_1024 [EXTRACTED 1.00]

## Communities (51 total, 11 thin omitted)

### Community 0 - "Linux Build System"
Cohesion: 0.12
Nodes (37): AOT_LIBRARY (AOT Compiled App), APPLICATION_ID: com.example.tsresepy, APPLY_STANDARD_SETTINGS (CMake Function), BINARY_NAME: tsresepy (Executable), Build Configuration: Debug, Build Configuration: Profile, Build Configuration: Release, linux/flutter/CMakeLists.txt (+29 more)

### Community 1 - "App Icon Assets"
Cohesion: 0.05
Nodes (37): Android Launcher Icon hdpi, Android Launcher Icon mdpi, Android Launcher Icon xhdpi, Android Launcher Icon xxhdpi, Android Launcher Icon xxxhdpi, iOS App Store Icon 1024px, iOS App Icon 20pt@1x, iOS App Icon 20pt@2x (+29 more)

### Community 2 - "State Management & Theme"
Cohesion: 0.07
Nodes (28): ../core/theme/app_theme.dart, dart:convert, isSaved, refresh, SavedCategoriesNotifier, SavedRecipesNotifier, DarkModeNotifier, LocaleNotifier (+20 more)

### Community 3 - "Dependencies & Services"
Cohesion: 0.1
Nodes (22): Turkish/English Language Toggle, Browse World Cuisines, cached_network_image, Dio, DuckDuckGo Instant Answer API, Flutter, Flutter Localizations, FlutterSceneDelegate (+14 more)

### Community 4 - "UI Navigation & Shell"
Cohesion: 0.08
Nodes (24): AppShell, build, GoRouter, RecipesyApp, SavedCategoryRecipesScreen, Scaffold, build, Divider (+16 more)

### Community 5 - "Data API Layer"
Cohesion: 0.09
Nodes (18): ../core/constants/app_constants.dart, ApiService, Recipe, DuckDuckGoService, _stripHtml, build, Card, CategoryCard (+10 more)

### Community 6 - "Plugin Registration"
Cohesion: 0.1
Nodes (7): fl_register_plugins(), RegisterPlugins(), generated_plugin_registrant.cc (Plugin Registration), FlutterWindow(), main(), my_application_activate(), my_application_new()

### Community 7 - "Windows Platform Shell"
Cohesion: 0.16
Nodes (17): OnCreate(), Create(), Destroy(), EnableFullDpiSupportIfAvailable(), GetClientArea(), GetThisFromHandle(), GetWindowClass(), MessageHandler() (+9 more)

### Community 8 - "Localization System"
Cohesion: 0.11
Nodes (17): dart:io, AppLocalizations, _AppLocalizationsDelegate, isSupported, of, recipeCount, shouldReload, _t (+9 more)

### Community 9 - "App Initialization"
Cohesion: 0.11
Nodes (17): app.dart, build, CircularProgressIndicator, initState, main, MaterialApp, _RecipesyInitializer, _RecipesyInitializerState (+9 more)

### Community 10 - "Recipe Detail UI"
Cohesion: 0.13
Nodes (13): build, _buildChip, _buildLinkButton, Chip, Icon, Padding, RecipeDetailScreen, _RecipeDetailScreenState (+5 more)

### Community 11 - "Search Screen"
Cohesion: 0.2
Nodes (9): build, Card, Center, dispose, Scaffold, _SearchRecipeCard, SearchScreen, _SearchScreenState (+1 more)

### Community 12 - "Category Recipes"
Cohesion: 0.25
Nodes (7): build, CategoryRecipesScreen, Center, RecipeCard, Scaffold, SizedBox, ../../providers/recipe_provider.dart

### Community 13 - "World Cuisines"
Cohesion: 0.25
Nodes (7): build, CategoryCard, Scaffold, SizedBox, WorldCuisinesScreen, package:go_router/go_router.dart, ../../widgets/category_card.dart

### Community 14 - "Saved Category Card"
Cohesion: 0.25
Nodes (7): ../core/localization/app_localizations.dart, build, Card, _getIcon, Icon, SavedCategoryCard, SizedBox

### Community 15 - "Saved Screen"
Cohesion: 0.25
Nodes (7): build, Padding, SavedScreen, Scaffold, SizedBox, ../../providers/saved_provider.dart, ../../widgets/saved_category_card.dart

### Community 16 - "Home Screen"
Cohesion: 0.25
Nodes (7): build, _buildSuggestions, HomeScreen, Icon, Padding, Scaffold, SizedBox

### Community 17 - "iOS App Delegate"
Cohesion: 0.25
Nodes (3): FlutterAppDelegate, FlutterImplicitEngineDelegate, AppDelegate

### Community 18 - "Saved Category Recipes"
Cohesion: 0.29
Nodes (6): build, RecipeCard, SavedCategoryRecipesScreen, Scaffold, SizedBox, ../../widgets/recipe_card.dart

### Community 19 - "Windows Entry Point"
Cohesion: 0.47
Nodes (4): wWinMain(), CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16()

### Community 20 - "Community 20"
Cohesion: 0.33
Nodes (3): RegisterGeneratedPlugins(), NSWindow, MainFlutterWindow

### Community 21 - "Community 21"
Cohesion: 0.4
Nodes (4): AppTheme, darkTheme, lightTheme, ThemeData

### Community 22 - "Community 22"
Cohesion: 0.5
Nodes (3): SavedRecipe, recipe.dart, search_result.dart

### Community 23 - "Community 23"
Cohesion: 0.5
Nodes (3): main, package:flutter/material.dart, package:flutter_test/flutter_test.dart

### Community 24 - "Community 24"
Cohesion: 0.5
Nodes (3): dispose, TranslationService, package:google_mlkit_translation/google_mlkit_translation.dart

## Knowledge Gaps
- **212 isolated node(s):** `RecipesyApp`, `AppShell`, `GoRouter`, `SavedCategoryRecipesScreen`, `build` (+207 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **11 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `package:flutter/material.dart` connect `Community 23` to `State Management & Theme`, `UI Navigation & Shell`, `Data API Layer`, `Localization System`, `App Initialization`, `Recipe Detail UI`, `Search Screen`, `Category Recipes`, `World Cuisines`, `Saved Category Card`, `Saved Screen`, `Home Screen`, `Saved Category Recipes`, `Community 21`?**
  _High betweenness centrality (0.105) - this node is a cross-community bridge._
- **Why does `package:flutter_riverpod/flutter_riverpod.dart` connect `State Management & Theme` to `UI Navigation & Shell`, `Data API Layer`, `App Initialization`, `Recipe Detail UI`, `Search Screen`, `Category Recipes`, `World Cuisines`, `Saved Screen`, `Home Screen`, `Saved Category Recipes`?**
  _High betweenness centrality (0.056) - this node is a cross-community bridge._
- **Why does `generated_plugin_registrant.cc (Plugin Registration)` connect `Plugin Registration` to `Linux Build System`?**
  _High betweenness centrality (0.023) - this node is a cross-community bridge._
- **Are the 32 inferred relationships involving `TSResepy App Icon Design` (e.g. with `Web Favicon (PNG)` and `Web App Icon 192px`) actually correct?**
  _`TSResepy App Icon Design` has 32 INFERRED edges - model-reasoned connections that need verification._
- **What connects `RecipesyApp`, `AppShell`, `GoRouter` to the rest of the system?**
  _212 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Linux Build System` be split into smaller, more focused modules?**
  _Cohesion score 0.12 - nodes in this community are weakly interconnected._
- **Should `App Icon Assets` be split into smaller, more focused modules?**
  _Cohesion score 0.05 - nodes in this community are weakly interconnected._