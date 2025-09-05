import 'package:flutter/material.dart';

class AppLanguageProvider extends ChangeNotifier {
  Locale? applanguage;

  AppLanguageProvider() {
    applanguage = null;
  }

  void changeLanguage(String newLanguage) {
    if (applanguage != null && applanguage!.languageCode == newLanguage) {
      return;
    } else {
      applanguage = Locale(newLanguage);
      notifyListeners();
    }
  }
}
