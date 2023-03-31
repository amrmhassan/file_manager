import 'package:flutter/material.dart';

class AnimationProvider extends ChangeNotifier {
  AnimationController? pausePlayAnimation;

  void setAnimationController(AnimationController a) {
    pausePlayAnimation = a;
  }
}
