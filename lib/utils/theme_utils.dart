//? material colors
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/shared_pref_constants.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:flutter/material.dart';

//! light theme checker
bool isLight = false;

//? colors
const Color kLBackgroundColor = Colors.white;
const Color kLCardBackgroundColor = Color.fromARGB(255, 243, 243, 243);
const Color kLLightCardBackgroundColor = Color.fromARGB(255, 213, 213, 213);
const Color kLInactiveColor = Color(0xff9A9CA3);
const Color kLBlueColor = Colors.blue;
const Color kLInverseColor = Colors.white;
//? text colors
const Color kLActiveTextColor = Color(0xFF362B4B);
const Color kLInActiveTextColor = Color.fromARGB(255, 115, 122, 130);
//? icons colors
const Color kLDangerColor = Colors.red;
const Color kLGreenColor = Colors.green;
const Color kLMainIconColor = Colors.grey;

//? toggle light theme
Future<void> toggleLightTheme() async {
  isLight = !isLight;
  await setLightTheme(isLight);
}

//? to set the theme type
Future<void> setLightTheme(bool b) async {
  await SharedPrefHelper.setBool(appThemeKey, b);
}

//? to set the theme colors
Future<void> setThemeVariables() async {
  isLight = await SharedPrefHelper.getBool(appThemeKey) ?? false;
  if (!isLight) return;
  kBackgroundColor = kLBackgroundColor;
  kCardBackgroundColor = kLCardBackgroundColor;
  kLightCardBackgroundColor = kLLightCardBackgroundColor;
  kInactiveColor = kLInactiveColor;
  kBlueColor = kLBlueColor;
  kInverseColor = kLInverseColor;

  //? text colors
  kActiveTextColor = kLActiveTextColor;
  kInActiveTextColor = kLInActiveTextColor;

  //? icons colors
  kDangerColor = kLDangerColor;
  kGreenColor = kLGreenColor;
  kMainIconColor = kLMainIconColor;
}
