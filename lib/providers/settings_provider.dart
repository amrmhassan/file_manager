// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/shared_pref_constants.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:explorer/helpers/string_to_type.dart';
import 'package:flutter/material.dart';

enum AnimationType {
  none,
  fadeInRight,
  fadeInLeft,
  bounceInRight,
  bounceInLeft,
  headShake,
  heartBeat,
  pulse, // with 5 magnitude
}

class SettingsProvider extends ChangeNotifier {
  //# explorer entities duration
  //? animation duration
  int animationDuration = 800;
  //? animation type
  AnimationType activeAnimationType = AnimationType.fadeInLeft;
  Future setAnimationType(AnimationType animationType) async {
    activeAnimationType = animationType;
    notifyListeners();
    await SharedPrefHelper.setString(
      expEntitiesAnimeTypeKey,
      animationType.name,
    );
  }

  //? animation magnitude
  double animationMagnitude = 1;
  Future setAnimationMagnitude(
    double i, [
    bool save = true,
  ]) async {
    animationMagnitude = i;
    notifyListeners();
    if (!save) return;
    await SharedPrefHelper.setString(
      expEntitiesMagnitudeKey,
      i.toString(),
    );
  }

  //? to set the explorer entities duration
  Future setExpEntitiesAnimDuration(
    int d, [
    bool save = true,
  ]) async {
    animationDuration = d;
    notifyListeners();
    if (!save) return;
    await SharedPrefHelper.setString(
      expEntitiesAnimDurationKey,
      d.toString(),
    );
  }

//# loading settings

////? to load all settings
  Future loadAllSettings() async {
    await _loadExpEntitiesAnimDuration();
    await _loadExpEntitiesAnimType();
    await _loadExpEntitiesAnimMagnitude();
    notifyListeners();
  }

  //? to load the explorer entities duration
  Future _loadExpEntitiesAnimDuration() async {
    String animD =
        await SharedPrefHelper.getString(expEntitiesAnimDurationKey) ?? '';
    if (animD.isNotEmpty) {
      int d = int.parse(animD);
      animationDuration = d;
    }
  }

  //? to load the explorer entities animation type
  Future _loadExpEntitiesAnimType() async {
    String animD =
        await SharedPrefHelper.getString(expEntitiesAnimeTypeKey) ?? '';
    if (animD.isNotEmpty) {
      AnimationType a = stringToEnum(animD, AnimationType.values);
      activeAnimationType = a;
    }
  }

  //? to load the explorer entities animation magnitude
  Future _loadExpEntitiesAnimMagnitude() async {
    String animD =
        await SharedPrefHelper.getString(expEntitiesMagnitudeKey) ?? '';
    if (animD.isNotEmpty) {
      double m = double.parse(animD);
      animationMagnitude = m;
    }
  }
}
