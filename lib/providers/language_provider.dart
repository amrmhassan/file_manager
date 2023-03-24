// ignore_for_file: use_build_context_synchronously

import 'package:explorer/constants/shared_pref_constants.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:explorer/utils/global_utils.dart';
import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale? locale;

  void setLocale(BuildContext context, Locale locale) async {
    this.locale = locale;
    notifyListeners();
    await SharedPrefHelper.setString(languageKey, locale.languageCode);
    CustomLocale.changeLocale(context, locale);
  }

  Future<void> loadLocale(BuildContext context) async {
    String? langCode = await SharedPrefHelper.getString(languageKey);
    if (langCode == null) return;
    Locale currentLocale = Locale.fromSubtags(languageCode: langCode);
    CustomLocale.changeLocale(context, currentLocale);
    locale = currentLocale;
    notifyListeners();
  }
}
