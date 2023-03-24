import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class CustomLocale {
  static bool isRightToLeft(BuildContext context) =>
      Directionality.of(context) == TextDirection.rtl;

  static bool isLeftToRight(BuildContext context) =>
      Directionality.of(context) == TextDirection.ltr;
  static changeLocale(BuildContext context, Locale l) {
    try {
      MyApp.of(context)!.setLocale(l);
      intl.Intl.defaultLocale = l.languageCode;
    } catch (e) {
      logger.e(e);
    }
  }
}
