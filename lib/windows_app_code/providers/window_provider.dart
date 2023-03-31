import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowProvider extends ChangeNotifier {
  bool isFullScreen = false;

  Future<void> toggleFullScreen() async {
    isFullScreen = !isFullScreen;
    notifyListeners();
    await windowManager.setFullScreen(isFullScreen);
  }

  Future<void> setFullScreen(bool f, [bool notify = true]) async {
    isFullScreen = f;
    if (notify) notifyListeners();
    await windowManager.setFullScreen(f);
  }
}
