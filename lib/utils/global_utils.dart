import 'package:explorer/constants/global_constants.dart';
import 'package:flutter/material.dart';

class CustomLocale {
  static bool isRightToLeft(BuildContext context) =>
      Localizations.localeOf(context).languageCode == arabicLocal.languageCode;

  static bool isLeftToRight(BuildContext context) =>
      Localizations.localeOf(context).languageCode == englishLocal.languageCode;

  static bool isArabic(BuildContext context) => isRightToLeft(context);

  static bool isEnglish(BuildContext context) => isLeftToRight(context);
}
