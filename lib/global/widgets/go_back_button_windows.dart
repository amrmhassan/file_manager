// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/custom_icon_button.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/screens/home_screen/home_screen.dart';
import 'package:explorer/screens/share_space_viewer_screen/share_space_viewer_screen.dart';
import 'package:flutter/material.dart';

class GoBackWindows extends StatelessWidget {
  const GoBackWindows({super.key});

  @override
  Widget build(BuildContext context) {
    return (Platform.isWindows &&
            (ModalRoute.of(context)?.settings.name?.toString() ?? '') !=
                HomeScreen.routeName)
        ? Container(
            width: double.infinity,
            height: largeIconSize * 1.5,
            color: kCardBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomIconButton(
                  onTap: () async {
                    bool shareViewerScreen =
                        (ModalRoute.of(context)?.settings.name?.toString() ??
                                '') ==
                            ShareSpaceVScreen.routeName;
                    if (shareViewerScreen) {
                      bool exit = await ShareSpaceVScreen.of(context)!
                          .handleScreenGoBack(context);
                      if (exit) {
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  iconData: Icons.arrow_forward_ios,
                ),
                HSpace(factor: 2),
              ],
            ),
          )
        : SizedBox();
  }
}
