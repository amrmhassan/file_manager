// ignore_for_file: prefer_const_constructors

import 'package:explorer/global/custom_app_drawer/widgets/app_drawer_item.dart';
import 'package:explorer/screens/language_screen/language_screen.dart';
import 'package:explorer/screens/logs_screen/logs_screen.dart';
import 'package:explorer/screens/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class MainSettings extends StatelessWidget {
  final Function(SettingMode s) setSettingMode;
  const MainSettings({
    Key? key,
    required this.setSettingMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDrawerItem(
          iconPath: 'animation',
          title: 'animations'.i18n(),
          onTap: () => setSettingMode(SettingMode.animations),
          onlyDebug: true,
        ),
        AppDrawerItem(
          iconPath: 'language',
          title: 'language'.i18n(),
          onTap: () {
            Navigator.pushNamed(context, LanguageScreen.routeName);
          },
          onlyDebug: true,
        ),
        AppDrawerItem(
          iconPath: 'log',
          title: 'logs'.i18n(),
          onTap: () {
            Navigator.pushNamed(context, LogsScreen.routeName);
          },
          onlyDebug: true,
        ),
      ],
    );
  }
}
