// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/settings_screen/widgets/animations_settings.dart';
import 'package:explorer/screens/settings_screen/widgets/main_setting.dart';
import 'package:flutter/material.dart';

enum SettingMode {
  main,
  animations,
}

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/SettingsScreen';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  //? the setting mode
  SettingMode settingMode = SettingMode.main;
  void setSettingMode(SettingMode s) {
    setState(() {
      settingMode = s;
    });
  }

  //? to return the settings screen title
  String get title {
    if (settingMode == SettingMode.main) {
      return 'Settings';
    } else if (settingMode == SettingMode.animations) {
      return 'Animations';
    } else {
      return '';
    }
  }

//? to return the settings screen widget
  Widget get settingScreenBody {
    if (settingMode == SettingMode.main) {
      return MainSettings(
        setSettingMode: setSettingMode,
      );
    } else {
      return AnimationsSettings();
    }
  }

  //? to view the back icon
  bool get viewBackIcon => settingMode != SettingMode.main;

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              title,
              style: h2TextStyle,
            ),
            rightIcon: !viewBackIcon
                ? null
                : ButtonWrapper(
                    onTap: () {
                      setSettingMode(SettingMode.main);
                    },
                    borderRadius: 0,
                    padding: EdgeInsets.all(largePadding * 1.5),
                    child: Image.asset(
                      'assets/icons/forward.png',
                      color: kMainIconColor,
                    ),
                  ),
          ),
          VSpace(),
          settingScreenBody,
        ],
      ),
    );
  }
}
