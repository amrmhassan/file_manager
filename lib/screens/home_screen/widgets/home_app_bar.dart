// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/screens/home_screen/widgets/app_bar_icon_button.dart';
import 'package:explorer/screens/home_screen/widgets/explorer_mode_switcher.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback goBack;
  final bool loadingFolder;
  final int activeScreenIndex;
  final Function(int index) setActiveScreen;

  const HomeAppBar({
    super.key,
    required this.goBack,
    required this.loadingFolder,
    required this.activeScreenIndex,
    required this.setActiveScreen,
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
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (ctx) {
                      return ModalWrapper(
                        color: kCardBackgroundColor,
                        showTopLine: false,
                        borderRadius: mediumBorderRadius,
                        child: Text('Text'),
                      );
                    });
              },
              iconName: 'dots',
              color: Colors.white,
            )
          ],
        ),
        ExplorerModeSwitcher(
          activeScreenIndex: activeScreenIndex,
          setActiveScreen: setActiveScreen,
        ),
      ],
    );
  }
}
