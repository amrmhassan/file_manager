import 'package:explorer/constants/shared_pref_constants.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:flutter/material.dart';

Future<void> loadCurrentLang() async {
  String? loaded = await SharedPrefHelper.getString(languageKey);
  if (loaded == null) return;
  loadedCurrentLocale = Locale.fromSubtags(languageCode: loaded);
}
