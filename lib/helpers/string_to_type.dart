import 'package:flutter/material.dart';

dynamic stringToEnum<T>(String n, List<T> e) {
  for (var name in e) {
    if (n == name.toString().split('.').last) {
      return name;
    }
  }
}

Color intToColors(int v) {
  return Color(v);
}
