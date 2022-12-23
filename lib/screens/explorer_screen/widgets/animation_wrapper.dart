// ignore_for_file: prefer_const_constructors

import 'package:explorer/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_animator/flutter_animator.dart';

// enum AnimationType {
//   bounce,
//   flash,
//   headShake,
//   heartBeat,
//   jello,
//   pulse,
//   rubberBand,
//   shake,
//   swing,
//   tada,
//   wobble,

//   //? bounce types
//   bounceIn,
//   bounceInDown,
//   bounceInLeft,
//   bounceInRight,
//   bounceInUp,

// //? bounce exits
//   bounceOut,
//   bounceOutDown,
//   bounceOutLeft,
//   bounceOutRight,
//   bounceOutUp,

// //? fading entrances
//   fadeIn,
//   fadeInDown,
//   fadeInDownBig,
// }

class AnimationWrapper extends StatelessWidget {
  final Widget child;
  const AnimationWrapper({
    super.key,
    required this.child,
  });

  Widget animationWrapper(Widget child, SettingsProvider settingsProvider) {
    //? fade in left
    if (settingsProvider.activeAnimationType == AnimationType.fadeInLeft) {
      return FadeInLeft(
        preferences: AnimationPreferences(
          magnitude: settingsProvider.animationMagnitude,
          duration: settingsProvider.animationDuration,
        ),
        child: child,
      );
    }
    //? fade in right
    else if (settingsProvider.activeAnimationType ==
        AnimationType.fadeInRight) {
      return FadeInRight(
        preferences: AnimationPreferences(
          magnitude: settingsProvider.animationMagnitude,
          duration: settingsProvider.animationDuration,
        ),
        child: child,
      );
    }
    //? bounce in left
    else if (settingsProvider.activeAnimationType ==
        AnimationType.bounceInLeft) {
      return BounceInLeft(
        preferences: AnimationPreferences(
          magnitude: settingsProvider.animationMagnitude,
          duration: settingsProvider.animationDuration,
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
          duration: settingsProvider.animationDuration,
        ),
        child: child,
      );
    }
    //? head shake
    else if (settingsProvider.activeAnimationType == AnimationType.headShake) {
      return HeadShake(
        preferences: AnimationPreferences(
          magnitude: settingsProvider.animationMagnitude,
          duration: settingsProvider.animationDuration,
        ),
        child: child,
      );
    }
    //? pulse
    else if (settingsProvider.activeAnimationType == AnimationType.pulse) {
      return Pulse(
        preferences: AnimationPreferences(
          magnitude: settingsProvider.animationMagnitude,
          duration: settingsProvider.animationDuration,
        ),
        child: child,
      );
    }
    //? heart beat
    else if (settingsProvider.activeAnimationType == AnimationType.heartBeat) {
      return HeartBeat(
        preferences: AnimationPreferences(
          magnitude: settingsProvider.animationMagnitude,
          duration: settingsProvider.animationDuration,
        ),
        child: child,
      );
    } else {
      return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return animationWrapper(child, settingsProvider);
  }
}
