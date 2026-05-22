import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'string_en.dart';
import 'string_tr.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    _AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const supportedLocales = [
    Locale('tr', 'TR'),
    Locale('en', 'US'),
  ];

  String get home => _t(() => EnStrings.home, () => TrStrings.home);
  String get search => _t(() => EnStrings.search, () => TrStrings.search);
  String get saved => _t(() => EnStrings.saved, () => TrStrings.saved);
  String get settings => _t(() => EnStrings.settings, () => TrStrings.settings);
  String get categories => _t(() => EnStrings.categories, () => TrStrings.categories);
  String get allCategories => _t(() => EnStrings.allCategories, () => TrStrings.allCategories);
  String get worldCuisines => _t(() => EnStrings.worldCuisines, () => TrStrings.worldCuisines);
  String get recipeDetail => _t(() => EnStrings.recipeDetail, () => TrStrings.recipeDetail);
  String get ingredients => _t(() => EnStrings.ingredients, () => TrStrings.ingredients);
  String get instructions => _t(() => EnStrings.instructions, () => TrStrings.instructions);
  String get saveRecipe => _t(() => EnStrings.saveRecipe, () => TrStrings.saveRecipe);
  String get unsaveRecipe => _t(() => EnStrings.unsaveRecipe, () => TrStrings.unsaveRecipe);
  String get savedRecipes => _t(() => EnStrings.savedRecipes, () => TrStrings.savedRecipes);
  String get noSavedRecipes => _t(() => EnStrings.noSavedRecipes, () => TrStrings.noSavedRecipes);
  String get noSavedRecipesHint => _t(() => EnStrings.noSavedRecipesHint, () => TrStrings.noSavedRecipesHint);
  String get manageCategories => _t(() => EnStrings.manageCategories, () => TrStrings.manageCategories);
  String get newCategory => _t(() => EnStrings.newCategory, () => TrStrings.newCategory);
  String get editCategory => _t(() => EnStrings.editCategory, () => TrStrings.editCategory);
  String get deleteCategory => _t(() => EnStrings.deleteCategory, () => TrStrings.deleteCategory);
  String get categoryName => _t(() => EnStrings.categoryName, () => TrStrings.categoryName);
  String get categoryColor => _t(() => EnStrings.categoryColor, () => TrStrings.categoryColor);
  String get save => _t(() => EnStrings.save, () => TrStrings.save);
  String get cancel => _t(() => EnStrings.cancel, () => TrStrings.cancel);
  String get delete => _t(() => EnStrings.delete, () => TrStrings.delete);
  String get areYouSure => _t(() => EnStrings.areYouSure, () => TrStrings.areYouSure);
  String get deleteCategoryWarning => _t(() => EnStrings.deleteCategoryWarning, () => TrStrings.deleteCategoryWarning);
  String get searchRecipes => _t(() => EnStrings.searchRecipes, () => TrStrings.searchRecipes);
  String get noResults => _t(() => EnStrings.noResults, () => TrStrings.noResults);
  String get tryDifferentSearch => _t(() => EnStrings.tryDifferentSearch, () => TrStrings.tryDifferentSearch);
  String get language => _t(() => EnStrings.language, () => TrStrings.language);
  String get theme => _t(() => EnStrings.theme, () => TrStrings.theme);
  String get themeColor => _t(() => EnStrings.themeColor, () => TrStrings.themeColor);
  String get darkMode => _t(() => EnStrings.darkMode, () => TrStrings.darkMode);
  String get lightMode => _t(() => EnStrings.lightMode, () => TrStrings.lightMode);
  String get systemMode => _t(() => EnStrings.systemMode, () => TrStrings.systemMode);
  String get turkish => _t(() => EnStrings.turkish, () => TrStrings.turkish);
  String get english => _t(() => EnStrings.english, () => TrStrings.english);
  String get uncategorized => _t(() => EnStrings.uncategorized, () => TrStrings.uncategorized);
  String get loading => _t(() => EnStrings.loading, () => TrStrings.loading);
  String get errorOccurred => _t(() => EnStrings.errorOccurred, () => TrStrings.errorOccurred);
  String get retry => _t(() => EnStrings.retry, () => TrStrings.retry);
  String get from => _t(() => EnStrings.from, () => TrStrings.from);
  String get source => _t(() => EnStrings.source, () => TrStrings.source);
  String get youTube => _t(() => EnStrings.youTube, () => TrStrings.youTube);

  String get savedToCategory => _t(() => EnStrings.savedToCategory, () => TrStrings.savedToCategory);
  String get removedFromSaved => _t(() => EnStrings.removedFromSaved, () => TrStrings.removedFromSaved);

  static const _categoryTranslations = <String, Map<String, String>>{
    'Beef': {'tr': 'Et', 'en': 'Beef'},
    'Breakfast': {'tr': 'Kahvaltı', 'en': 'Breakfast'},
    'Chicken': {'tr': 'Tavuk', 'en': 'Chicken'},
    'Dessert': {'tr': 'Tatlı', 'en': 'Dessert'},
    'Goat': {'tr': 'Keçi Eti', 'en': 'Goat'},
    'Lamb': {'tr': 'Kuzu', 'en': 'Lamb'},
    'Miscellaneous': {'tr': 'Çeşitli', 'en': 'Miscellaneous'},
    'Pasta': {'tr': 'Makarna', 'en': 'Pasta'},
    'Pork': {'tr': 'Domuz Eti', 'en': 'Pork'},
    'Seafood': {'tr': 'Deniz Ürünleri', 'en': 'Seafood'},
    'Side': {'tr': 'Garnitür', 'en': 'Side'},
    'Starter': {'tr': 'Başlangıç', 'en': 'Starter'},
    'Vegan': {'tr': 'Vegan', 'en': 'Vegan'},
    'Vegetarian': {'tr': 'Vejetaryen', 'en': 'Vegetarian'},
  };

  static const _areaTranslations = <String, Map<String, String>>{
    'American': {'tr': 'Amerikan', 'en': 'American'},
    'British': {'tr': 'İngiliz', 'en': 'British'},
    'Canadian': {'tr': 'Kanada', 'en': 'Canadian'},
    'Chinese': {'tr': 'Çin', 'en': 'Chinese'},
    'Croatian': {'tr': 'Hırvat', 'en': 'Croatian'},
    'Dutch': {'tr': 'Hollanda', 'en': 'Dutch'},
    'Egyptian': {'tr': 'Mısır', 'en': 'Egyptian'},
    'French': {'tr': 'Fransız', 'en': 'French'},
    'Greek': {'tr': 'Yunan', 'en': 'Greek'},
    'Indian': {'tr': 'Hint', 'en': 'Indian'},
    'Irish': {'tr': 'İrlanda', 'en': 'Irish'},
    'Italian': {'tr': 'İtalyan', 'en': 'Italian'},
    'Jamaican': {'tr': 'Jamaika', 'en': 'Jamaican'},
    'Japanese': {'tr': 'Japon', 'en': 'Japanese'},
    'Kenyan': {'tr': 'Kenya', 'en': 'Kenyan'},
    'Malaysian': {'tr': 'Malezya', 'en': 'Malaysian'},
    'Mexican': {'tr': 'Meksika', 'en': 'Mexican'},
    'Moroccan': {'tr': 'Fas', 'en': 'Moroccan'},
    'Polish': {'tr': 'Polonya', 'en': 'Polish'},
    'Portuguese': {'tr': 'Portekiz', 'en': 'Portuguese'},
    'Russian': {'tr': 'Rus', 'en': 'Russian'},
    'Spanish': {'tr': 'İspanyol', 'en': 'Spanish'},
    'Thai': {'tr': 'Tay', 'en': 'Thai'},
    'Tunisian': {'tr': 'Tunus', 'en': 'Tunisian'},
    'Turkish': {'tr': 'Türk', 'en': 'Turkish'},
    'Vietnamese': {'tr': 'Vietnam', 'en': 'Vietnamese'},
  };

  String translateCategory(String category) {
    final lang = locale.languageCode;
    return _categoryTranslations[category]?[lang] ?? category;
  }

  String translateArea(String area) {
    final lang = locale.languageCode;
    return _areaTranslations[area]?[lang] ?? area;
  }

  String recipeCount(int count) {
    if (locale.languageCode == 'tr') {
      return count == 1 ? '$count tarif' : '$count tarif';
    }
    return count == 1 ? '$count recipe' : '$count recipes';
  }

  String _t(String Function() en, String Function() tr) {
    return locale.languageCode == 'tr' ? tr() : en();
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'tr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
