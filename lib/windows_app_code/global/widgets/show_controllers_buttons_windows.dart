// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/windows_app_code/utils/windows_provider_calls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';

class ShowControllersButtonWindows extends StatelessWidget {
  const ShowControllersButtonWindows({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mpProvider = WindowSProviders.mpP(context);
    return mpProvider.playerHidden && mpProvider.audioPlaying
        ? FadeInUp(
            preferences: AnimationPreferences(
              duration: Duration(milliseconds: 200),
            ),
            child: ButtonWrapper(
              onTap: () {
                WindowSProviders.mpPF(context).togglePlayerHidden();
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
