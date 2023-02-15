// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';

Future<void> initWindowSize() async {
  if (!Platform.isWindows) return;
  await DesktopWindow.setWindowSize(Size(500, 1040));
  await DesktopWindow.setMinWindowSize(Size(400, 1000));
  await DesktopWindow.setMaxWindowSize(Size(600, 1080));
  Size size = await DesktopWindow.getWindowSize();
  print(size);
}
