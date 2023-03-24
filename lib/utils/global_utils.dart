import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/main.dart';
import 'package:flutter/material.dart';

class CustomLocale {
  static bool isRightToLeft(BuildContext context) =>
      Directionality.of(context) == TextDirection.rtl;

  static bool isLeftToRight(BuildContext context) =>
      Directionality.of(context) == TextDirection.ltr;
  static changeLocale(BuildContext context, Locale l) {
    try {
      MyApp.of(context)!.setLocale(l);
    } catch (e) {
      logger.e(e);
    }
  }
}
