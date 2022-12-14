import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';

enum AnimationType {
  bounce,
  flash,
  headShake,
  heartBeat,
  jello,
  pulse,
  rubberBand,
  shake,
  swing,
  tada,
  wobble,

  //? bounce types
  bounceIn,
  bounceInDown,
  bounceInLeft,
  bounceInRight,
  bounceInUp,

//? bounce exits
  bounceOut,
  bounceOutDown,
  bounceOutLeft,
  bounceOutRight,
  bounceOutUp,

//? fading entrances
  fadeIn,
  fadeInDown,
  fadeInDownBig,
}

class AnimationWrapper extends StatelessWidget {
  final Widget child;
  const AnimationWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(child: child);
  }
}
