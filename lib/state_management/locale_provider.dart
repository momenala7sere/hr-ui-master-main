import 'package:flutter/material.dart';
import 'package:hr/state_management/localization_service.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en', 'US'); // Default language is English

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await LocalizationService.load(locale); // Load the selected language
    notifyListeners(); // Notify widgets to rebuild
  }
}
