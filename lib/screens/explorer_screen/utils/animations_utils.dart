import 'package:explorer/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';

//? to return the animation type in the form of string( title )
String animationTypeToTitle(AnimationType a) {
  switch (a) {
    case AnimationType.none:
      return 'None';
    case AnimationType.fadeInRight:
      return 'Fade In Right';
    case AnimationType.fadeInLeft:
      return 'Fade In Left';
    case AnimationType.bounceInRight:
      return 'Bounce In Right';
    case AnimationType.bounceInLeft:
      return 'Bounce In Left';
    case AnimationType.headShake:
      return 'Head Shake';
    case AnimationType.heartBeat:
      return 'Heart Beat';
    case AnimationType.pulse:
      return 'Pulse';
  }
}

//? to return the corresponding animation wrapper
Widget animationWrapper(Widget child, SettingsProvider settingsProvider) {
  //? fade in left
  if (settingsProvider.activeAnimationType == AnimationType.fadeInLeft) {
    return FadeInLeft(
      preferences: AnimationPreferences(
        magnitude: settingsProvider.animationMagnitude,
        duration: Duration(milliseconds: settingsProvider.animationDuration),
      ),
      child: child,
    );
  }
  //? fade in right
  else if (settingsProvider.activeAnimationType == AnimationType.fadeInRight) {
    return FadeInRight(
      preferences: AnimationPreferences(
        magnitude: settingsProvider.animationMagnitude,
        duration: Duration(milliseconds: settingsProvider.animationDuration),
      ),
      child: child,
    );
  }
  //? bounce in left
  else if (settingsProvider.activeAnimationType == AnimationType.bounceInLeft) {
    return BounceInLeft(
      preferences: AnimationPreferences(
        magnitude: settingsProvider.animationMagnitude,
        duration: Duration(milliseconds: settingsProvider.animationDuration),
      ),
      child: child,
    );
  }
  //? bounce in right
  else if (settingsProvider.activeAnimationType ==
      AnimationType.bounceInRight) {
    return BounceInRight(
      preferences: AnimationPreferences(
        magnitude: settingsProvider.animationMagnitude,
        duration: Duration(milliseconds: settingsProvider.animationDuration),
      ),
      child: child,
    );
  }
  //? head shake
  else if (settingsProvider.activeAnimationType == AnimationType.headShake) {
    return HeadShake(
      preferences: AnimationPreferences(
        magnitude: settingsProvider.animationMagnitude,
        duration: Duration(milliseconds: settingsProvider.animationDuration),
      ),
      child: child,
    );
  }
  //? pulse
  else if (settingsProvider.activeAnimationType == AnimationType.pulse) {
    return Pulse(
      preferences: AnimationPreferences(
        magnitude: settingsProvider.animationMagnitude,
        duration: Duration(milliseconds: settingsProvider.animationDuration),
      ),
      child: child,
    );
  }
  //? heart beat
  else if (settingsProvider.activeAnimationType == AnimationType.heartBeat) {
    return HeartBeat(
      preferences: AnimationPreferences(
        magnitude: settingsProvider.animationMagnitude,
        duration: Duration(milliseconds: settingsProvider.animationDuration),
      ),
      child: child,
    );
  } else {
    return child;
  }
}
