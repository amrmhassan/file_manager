// ignore_for_file: prefer_const_constructors

import 'package:explorer/providers/settings_provider.dart';
import 'package:explorer/screens/explorer_screen/utils/animations_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimationWrapper extends StatelessWidget {
  final Widget child;

  const AnimationWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return animationWrapper(child, settingsProvider);
  }
}
