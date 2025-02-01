import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class LocalizationService {
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ar', 'EG'),
  ];

  static Locale? localeResolutionCallback(
      Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale == null) return supportedLocales.first;

    for (final supportedLocale in supportedLocales) {
      if (locale.languageCode == supportedLocale.languageCode) {
        return supportedLocale;
      }
    }

    return supportedLocales.first;
  }

  static final Map<String, Map<String, String>> _cachedLocales = {};
  static Map<String, String> _localizedStrings = {};

  /// Loads the JSON file for the given locale
  static Future<void> load(Locale locale) async {
    final String languageCode = locale.languageCode;

    if (_cachedLocales.containsKey(languageCode)) {
      // Load from cache if already loaded
      _localizedStrings = _cachedLocales[languageCode]!;
      return;
    }

    try {
      final String jsonString =
          await rootBundle.loadString('assets/lang/$languageCode.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedStrings =
          jsonMap.map((key, value) => MapEntry(key, value.toString()));

      // Cache the loaded locale
      _cachedLocales[languageCode] = _localizedStrings;
    } catch (e) {
      print('Error loading localization file for $languageCode: $e');
      _localizedStrings = {}; // Fallback to an empty map
    }
  }

  /// Retrieves the translated string for the given key
  /// Falls back to English if key is not found in the current language
  static String translate(String key) {
    if (_localizedStrings.containsKey(key)) {
      return _localizedStrings[key]!;
    }

    // Attempt fallback to English if current locale does not have the key
    if (_cachedLocales.containsKey('en') &&
        _cachedLocales['en']!.containsKey(key)) {
      return _cachedLocales['en']![key]!;
    }

    // Return the key itself if no translation is found
    return key;
  }
}
