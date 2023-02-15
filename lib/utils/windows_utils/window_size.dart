// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:flutter/material.dart';

Future<void> initWindowSize() async {
  if (!Platform.isWindows) return;

  doWhenWindowReady(() {
    Size initialSize =
        Size(400, MediaQuery.of(navigatorKey.currentContext!).size.height);
    const Size minSize = Size(400, 600);
    const Size maxSize = Size(600, 1000);
    appWindow.size = initialSize;
    appWindow.minSize = minSize;
    appWindow.maxSize = maxSize;
    appWindow.position = Offset.zero;

    appWindow.show();
  });
}
