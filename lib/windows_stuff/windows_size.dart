// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

Future<void> initWindowSize() async {
  if (!Platform.isWindows) return;
  appWindow.show();

  doWhenWindowReady(() {
    Size initialSize = Size(400, 800);
    const Size minSize = Size(400, 600);
    // const Size maxSize = Size(600, 1000);
    appWindow.size = initialSize;
    appWindow.minSize = minSize;
    // appWindow.maxSize = maxSize;
    // appWindow.position = Offset(100, 100);
    appWindow.position = Offset.zero;

    appWindow.show();
  });
}
