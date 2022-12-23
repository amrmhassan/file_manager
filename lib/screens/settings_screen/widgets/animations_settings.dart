// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/settings_screen/widgets/animation_duration_setter.dart';
import 'package:explorer/screens/settings_screen/widgets/animation_magnitude_setter.dart';
import 'package:explorer/screens/settings_screen/widgets/animation_type_chooser.dart';
import 'package:flutter/material.dart';

class AnimationsSettings extends StatelessWidget {
  const AnimationsSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimationTypeChooser(),
        VSpace(),
        AnimationDurationSetter(),
        VSpace(),
        AnimationMagnitudeSetter(),
      ],
    );
  }
}
