// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimationDurationSetter extends StatelessWidget {
  const AnimationDurationSetter({
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
                'Animation Duration',
                style: h3TextStyle,
              ),
              Spacer(),
              Text(
                '${settingsProvider.animationDuration} ms',
                style: h4TextStyleInactive,
              ),
            ],
          ),
          Slider(
            min: 0,
            max: 2000,
            value: settingsProvider.animationDuration.toDouble(),
            onChanged: (v) {
              settingsProviderFalse.setExpEntitiesAnimDuration(
                v.toInt(),
                false,
              );
            },
            onChangeEnd: (value) {
              settingsProviderFalse.setExpEntitiesAnimDuration(
                value.toInt(),
                true,
              );
            },
          )
        ],
      ),
    );
  }
}
