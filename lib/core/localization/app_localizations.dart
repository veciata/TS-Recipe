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

  String get myMeals => _t(() => EnStrings.myMeals, () => TrStrings.myMeals);
  String get suggestions => _t(() => EnStrings.suggestions, () => TrStrings.suggestions);
  String get savedToCategory => _t(() => EnStrings.savedToCategory, () => TrStrings.savedToCategory);
  String get saveToSection =>
      _t(() => EnStrings.saveToSection, () => TrStrings.saveToSection);
  String get saveToSectionHint =>
      _t(() => EnStrings.saveToSectionHint, () => TrStrings.saveToSectionHint);
  String get removedFromSaved => _t(() => EnStrings.removedFromSaved, () => TrStrings.removedFromSaved);
  String get login => _t(() => EnStrings.login, () => TrStrings.login);
  String get register => _t(() => EnStrings.register, () => TrStrings.register);
  String get email => _t(() => EnStrings.email, () => TrStrings.email);
  String get password => _t(() => EnStrings.password, () => TrStrings.password);
  String get confirmPassword => _t(() => EnStrings.confirmPassword, () => TrStrings.confirmPassword);
  String get username => _t(() => EnStrings.username, () => TrStrings.username);
  String get dontHaveAccount => _t(() => EnStrings.dontHaveAccount, () => TrStrings.dontHaveAccount);
  String get alreadyHaveAccount => _t(() => EnStrings.alreadyHaveAccount, () => TrStrings.alreadyHaveAccount);
  String get passwordsDoNotMatch => _t(() => EnStrings.passwordsDoNotMatch, () => TrStrings.passwordsDoNotMatch);
  String get loginSuccess => _t(() => EnStrings.loginSuccess, () => TrStrings.loginSuccess);
  String get registerSuccess => _t(() => EnStrings.registerSuccess, () => TrStrings.registerSuccess);
  String get continueWithoutAccount =>
      _t(() => EnStrings.continueWithoutAccount, () => TrStrings.continueWithoutAccount);
  String get browsingWithoutAccount =>
      _t(() => EnStrings.browsingWithoutAccount, () => TrStrings.browsingWithoutAccount);
  String get signIn => _t(() => EnStrings.signIn, () => TrStrings.signIn);
  String get signOut => _t(() => EnStrings.signOut, () => TrStrings.signOut);
  String get account => _t(() => EnStrings.account, () => TrStrings.account);
  String get syncRequiresAccount =>
      _t(() => EnStrings.syncRequiresAccount, () => TrStrings.syncRequiresAccount);

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

  static const _mealCategoryTranslations = <String, Map<String, String>>{
    'Kahvaltı': {'tr': 'Kahvaltı', 'en': 'Breakfast'},
    'Öğle Yemeği': {'tr': 'Öğle Yemeği', 'en': 'Lunch'},
    'Akşam Yemeği': {'tr': 'Akşam Yemeği', 'en': 'Dinner'},
    'Çay': {'tr': 'Çay', 'en': 'Tea'},
    'Ara Öğün': {'tr': 'Ara Öğün', 'en': 'Snack'},
  };

  String translateMealCategory(String name) {
    final lang = locale.languageCode;
    return _mealCategoryTranslations[name]?[lang] ?? name;
  }

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
