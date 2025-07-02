import 'package:core_package/core/utility/export.dart';

///
/// Preferences related
///
const String _storageKey = "MyApplication_";
const List<String> _supportedLanguages = ['en', 'ar'];

class GlobalTranslations {
  Locale? _locale;
  Map<dynamic, dynamic>? _localizedValues;
  VoidCallback? _onLocaleChangedCallback;

  ///
  /// Returns the list of supported Locales
  ///
  Iterable<Locale> supportedLocales() =>
      _supportedLanguages.map<Locale>((lang) => Locale(lang, ''));

  ///
  /// Returns the translation that corresponds to the [key]
  ///
  String text(String key) {
    // Return the requested string
    return (_localizedValues == null || _localizedValues![key] == null)
        ? '** $key not found'
        : _localizedValues![key];
  }

  ///
  /// Returns the current language code
  ///
  get currentLanguage => _locale == null ? 'ar' : _locale!.languageCode;

  ///
  /// Returns the current Locale
  ///
  get locale => _locale;

  ///
  /// One-time initialization
  ///
  Future<void> init([String? language]) async {
    if (_locale == null) {
      await setNewLanguage(language, false);
    }
    return;
  }

  /// ----------------------------------------------------------
  /// Method that saves/restores the preferred language
  /// ----------------------------------------------------------
  getPreferredLanguage() async {
    return _getApplicationSavedInformation('language');
  }

  setPreferredLanguage(String lang) async {
    return _setApplicationSavedInformation('language', lang);
  }

  ///
  /// Routine to change the language
  ///
  Future<void> setNewLanguage(
      [String? newLanguage,
      bool saveInPrefs = true,
      BuildContext? context]) async {
    String? language = newLanguage;
    language ??= await getPreferredLanguage();
    bool isLogin =
        await SharedHelper.sharedHelper!.readBoolean(CachingKey.IS_LOGIN);
    if (language == "") {
      language = "en";
    }
    _locale = Locale(language!, "");
    // App.setLocale(context, _locale);
    String jsonContent = await rootBundle
        .loadString("assets/langs/${_locale!.languageCode}.json");
    _localizedValues = json.decode(jsonContent);

    // If we are asked to save the new language in the application preferences
    if (saveInPrefs && isLogin) {
      await setPreferredLanguage(language);
      mainAppBloc.updateLang(language);
    }

    // If there is a callback to invoke to notify that a language has changed
    if (_onLocaleChangedCallback != null) {
      _onLocaleChangedCallback!();
    }

    return;
  }

  ///
  /// Callback to be invoked when the user changes the language
  ///
  set onLocaleChangedCallback(VoidCallback callback) {
    _onLocaleChangedCallback = callback;
  }

  ///
  /// Application.kt Preferences related
  ///
  /// ----------------------------------------------------------
  /// Generic routine to fetch an application preference
  /// ----------------------------------------------------------
  Future<String> _getApplicationSavedInformation(String name) async {
    return SharedHelper.box!.get(_storageKey + name) ?? 'ar';
  }

  /// ----------------------------------------------------------
  /// Generic routine to saves an application preference
  /// ----------------------------------------------------------
  _setApplicationSavedInformation(String name, String value) async {
    return SharedHelper.box!.put(_storageKey + name, value);
  }

  ///
  /// Singleton Factory
  ///
  static final GlobalTranslations? _translations =
      new GlobalTranslations._internal();

  factory GlobalTranslations() {
    return _translations!;
  }

  GlobalTranslations._internal();
}

GlobalTranslations allTranslations = new GlobalTranslations();
