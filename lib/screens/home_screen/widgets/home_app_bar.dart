// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/screens/home_screen/widgets/app_bar_icon_button.dart';
import 'package:explorer/screens/home_screen/widgets/explorer_mode_switcher.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback goBack;
  final bool loadingFolder;
  const HomeAppBar({
    super.key,
    required this.goBack,
    required this.loadingFolder,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: [
            AppBarIconButton(onTap: goBack, iconName: 'back'),
            Spacer(),
            Spacer(),
            if (loadingFolder)
              SizedBox(
                width: smallIconSize,
                height: smallIconSize,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            AppBarIconButton(
              onTap: () {
                //? Add a new folder after showing a modal
              },
              iconName: 'plus',
              color: Colors.white,
            )
          ],
        ),
        ExplorerModeSwitcher(),
      ],
    );
  }
}
