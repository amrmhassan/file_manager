// ignore_for_file: prefer_const_constructors

import 'package:explorer/screens/home_screen/widgets/app_bar_icon_button.dart';
import 'package:explorer/screens/home_screen/widgets/explorer_mode_switcher.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback goBack;
  const HomeAppBar({
    super.key,
    required this.goBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppBarIconButton(onTap: goBack, iconName: 'back'),
        Spacer(),
        ExplorerModeSwitcher(),
        Spacer(),
        AppBarIconButton(
          onTap: () {
            //? Add a new folder
          },
          iconName: 'plus',
          color: Colors.white,
        )
      ],
    );
  }
}
