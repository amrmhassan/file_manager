// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/shared_pref_constants.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  //# explorer entities duration
  Duration expEntitiesAnimationDuration = Duration(milliseconds: 300);

//? to set the explorer entities duration
  Future setExpEntitiesAnimDuration(Duration d) async {
    expEntitiesAnimationDuration = d;
    notifyListeners();
    await SharedPrefHelper.setString(
        expEntitiesAnimDurationKey, d.inMilliseconds.toString());
  }

//? to load the explorer entities duration
  Future loadExpEntitiesAnimDuration() async {
    String animD =
        await SharedPrefHelper.getString(expEntitiesAnimDurationKey) ?? '';
    if (animD.isNotEmpty) {
      Duration d = Duration(milliseconds: int.parse(animD));
      expEntitiesAnimationDuration = d;
    }
  }

  //? to load all settings
  Future loadAllSettings() async {
    await loadExpEntitiesAnimDuration();
    notifyListeners();
  }
}
