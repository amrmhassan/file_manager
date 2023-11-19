// // ignore_for_file: prefer_const_constructors

// import 'dart:io';

// import 'package:bitsdojo_window/bitsdojo_window.dart';
// import 'package:desktop_window/desktop_window.dart';
// import 'package:flutter/material.dart';
// import 'dart:ui';

// Future<void> initWindowSize() async {
//   Size size = await DesktopWindow.getWindowSize();
//   print(size);

//   if (!Platform.isWindows) return;
//   appWindow.show();

//   doWhenWindowReady(() {
//     Size initialSize = Size(400, 800);
//     const Size minSize = Size(400, 600);
//     appWindow.size = initialSize;
//     appWindow.minSize = minSize;
//     appWindow.position = Offset.zero;

//     appWindow.show();
//   });
// }
