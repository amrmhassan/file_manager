import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale? locale;

  void setLocale(Locale l) {
    locale = l;
    notifyListeners();
  }
}
