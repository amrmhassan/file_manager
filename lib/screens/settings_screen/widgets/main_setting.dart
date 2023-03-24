// ignore_for_file: prefer_const_constructors

import 'package:explorer/global/custom_app_drawer/widgets/app_drawer_item.dart';
import 'package:explorer/global/modals/language_modal.dart';
import 'package:explorer/screens/settings_screen/settings_screen.dart';
import 'package:flutter/foundation.dart';
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
          title: 'animations'.i18n(),
          onTap: () => setSettingMode(SettingMode.animations),
          onlyDebug: true,
        ),
        if (kDebugMode)
          AppDrawerItem(
            title: 'language'.i18n(),
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => LanguageModal(),
              );
            },
            onlyDebug: true,
          ),
      ],
    );
  }
}
