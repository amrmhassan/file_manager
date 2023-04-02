// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';

import 'package:explorer/screens/home_screen/widgets/app_bar_icon_button.dart';

class WindowsAppBar extends StatelessWidget {
  const WindowsAppBar({
    super.key,
    required this.buttonKey,
    required this.scfKey,
  });

  final GlobalKey<State<StatefulWidget>> buttonKey;
  final GlobalKey<ScaffoldState> scfKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBarIconButton(
          key: buttonKey,
          onTap: () {
            scfKey.currentState?.openDrawer();
          },
          iconName: 'list',
        ),
        Expanded(
          child: MouseRegion(
            cursor: SystemMouseCursors.disappearing,
            child: GestureDetector(
              onPanUpdate: (details) {
                appWindow.startDragging();
              },
              child: Container(
                height: largeIconSize / 1.3,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
            ),
          ),
        ),
        ButtonWrapper(
          borderRadius: 0,
          alignment: Alignment.center,
          width: largeIconSize * 2,
          height: largeIconSize / 1.3,
          // height: buttonKey.currentContext?.size?.height,

          onTap: () {
            // appWindow.minimize();
            // appWindow.hide();
          },
          child: Icon(
            Icons.minimize,
            color: Colors.white,
          ),
        ),
        ButtonWrapper(
          width: largeIconSize * 2,
          height: largeIconSize / 1.3,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                largeBorderRadius,
              ),
            ),
          ),
          onTap: () {
            appWindow.close();
            // appWindow.hide();
          },
          child: Icon(
            Icons.close,
            color: Colors.white,
            size: smallIconSize,
          ),
        ),
      ],
    );
  }
}
