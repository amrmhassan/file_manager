// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/settings_provider.dart';
import 'package:explorer/screens/settings_screen/widgets/animation_type_chooser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimationsSettings extends StatelessWidget {
  const AnimationsSettings({super.key});

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var settingsProviderFalse =
        Provider.of<SettingsProvider>(context, listen: false);
    return Column(
      children: [
        AnimationTypeChooser(settingsProvider: settingsProvider),
        VSpace(),
        PaddingWrapper(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                min: 100,
                max: 5000,
                divisions: 50,
                value: settingsProvider.animationDuration.toDouble(),
                onChanged: (v) {
                  settingsProviderFalse.setExpEntitiesAnimDuration(v.toInt());
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
