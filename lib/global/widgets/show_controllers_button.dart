// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/providers/media_player_provider/media_player_provider.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:explorer/windows_app_code/utils/windows_provider_calls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:provider/provider.dart';

class ShowControllersButton extends StatelessWidget {
  const ShowControllersButton({
    Key? key,
  }) : super(key: key);

  bool show(BuildContext context) {
    if (Platform.isAndroid) {
      var mpProvider = mpP(context);
      return mpProvider.playerHidden && mpProvider.fullSongDuration != null;
    } else {
      var mpProvider = WindowSProviders.mpP(context);
      return mpProvider.playerHidden && mpProvider.fullSongDuration != null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return show(context)
        ? FadeInUp(
            preferences: AnimationPreferences(
              duration: Duration(milliseconds: 200),
            ),
            child: ButtonWrapper(
              onTap: () {
                Provider.of<MediaPlayerProvider>(context, listen: false)
                    .togglePlayerHidden();
              },
              width: largeIconSize,
              height: largeIconSize,
              decoration: BoxDecoration(
                color: kCardBackgroundColor,
                border: Border.all(color: kInverseColor.withOpacity(.5)),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(mediumBorderRadius),
                  topLeft: Radius.circular(mediumBorderRadius),
                ),
              ),
              child: Image.asset(
                'assets/icons/arrow-up2.png',
                color: kMainIconColor,
              ),
            ),
          )
        : SizedBox();
  }
}
