// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimationMagnitudeSetter extends StatelessWidget {
  const AnimationMagnitudeSetter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var settingsProviderFalse =
        Provider.of<SettingsProvider>(context, listen: false);
    return PaddingWrapper(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: double.infinity),
          Row(
            children: [
              Text(
                'Animation Magnitude',
                style: h3TextStyle,
              ),
              Spacer(),
              Text(
                '${settingsProvider.animationMagnitude.toStringAsFixed(2)} Times',
                style: h4TextStyleInactive,
              ),
            ],
          ),
          Slider(
            min: 0,
            max: 3,
            value: settingsProvider.animationMagnitude,
            onChanged: (v) {
              settingsProviderFalse.setAnimationMagnitude(v, false);
            },
            onChangeEnd: (value) {
              settingsProviderFalse.setAnimationMagnitude(value, true);
            },
          )
        ],
      ),
    );
  }
}
