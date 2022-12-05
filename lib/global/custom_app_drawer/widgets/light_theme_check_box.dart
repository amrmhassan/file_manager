// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/screens/analyzer_screen/analyzer_screen.dart';
import 'package:explorer/screens/home_screen/widgets/custom_check_box.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/theme_utils.dart';
import 'package:flutter/material.dart';

class LightThemeCheckBox extends StatelessWidget {
  const LightThemeCheckBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      borderRadius: 0,
      onTap: () {
        toggleLightTheme();
        showSnackBar(
            context: context,
            message: 'You must restart the app to apply theme');
        Navigator.pop(context);
      },
      child: ListTile(
        leading: Image.asset(
          'assets/icons/analyze.png',
          width: mediumIconSize,
          color: kInactiveColor,
        ),
        title: Text(
          'Light Theme',
          style: h4TextStyle.copyWith(color: kInactiveColor),
        ),
        trailing: CustomCheckBox(checked: true),
      ),
    );
  }
}
