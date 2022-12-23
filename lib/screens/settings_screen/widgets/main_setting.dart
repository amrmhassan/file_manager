import 'package:explorer/global/custom_app_drawer/widgets/app_drawer_item.dart';
import 'package:explorer/screens/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';

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
          title: 'Animations',
          onTap: () => setSettingMode(SettingMode.animations),
          onlyDebug: true,
        ),
      ],
    );
  }
}
