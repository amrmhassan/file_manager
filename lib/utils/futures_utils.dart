// ignore_for_file: prefer_const_constructors

import 'dart:async';

class CustomFuture {
  bool _isCancelled = false;

  void cancel() {
    _isCancelled = true;
  }

  Future<void> delayedAction(Duration duration, Function callback) async {
    await Future.delayed(duration);
    if (_isCancelled) return;
    await callback();
  }
}
