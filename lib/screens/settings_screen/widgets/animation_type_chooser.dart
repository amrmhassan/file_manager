// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/providers/settings_provider.dart';
import 'package:explorer/screens/explorer_screen/utils/animations_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimationTypeChooser extends StatelessWidget {
  const AnimationTypeChooser({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);

    return PaddingWrapper(
      child: Row(
        children: [
          Text(
            'Animation Type',
            style: h3TextStyle,
          ),
          Spacer(),
          DropdownButton(
            enableFeedback: true,
            underline: SizedBox(),
            elevation: 1,
            alignment: AlignmentDirectional.centerEnd,
            value: settingsProvider.activeAnimationType,
            dropdownColor: kCardBackgroundColor,
            items: [
              ...AnimationType.values.map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    animationTypeToTitle(e),
                    style: h4LightTextStyle,
                  ),
                ),
              ),
            ],
            onChanged: (v) {
              settingsProvider.setAnimationType(v ?? AnimationType.none);
            },
          )
        ],
      ),
    );
  }
}
