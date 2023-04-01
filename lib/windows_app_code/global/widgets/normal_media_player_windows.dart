// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/windows_app_code/utils/windows_provider_calls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';

class NormalMediaPlayerWindows extends StatefulWidget {
  const NormalMediaPlayerWindows({super.key});

  @override
  State<NormalMediaPlayerWindows> createState() =>
      _NormalMediaPlayerWindowsState();
}

class _NormalMediaPlayerWindowsState extends State<NormalMediaPlayerWindows> {
  final GlobalKey<AnimatorWidgetState> mediaAnimationController =
      GlobalKey<AnimatorWidgetState>();
  @override
  Widget build(BuildContext context) {
    var mpProvider = WindowSProviders.mpP(context);

    return FadeInUpBig(
      key: mediaAnimationController,
      preferences: AnimationPreferences(
        duration: Duration(milliseconds: 200),
        animationStatusListener: (status) {
          if (status == AnimationStatus.reverse) {
            printOnDebug(status);
            WindowSProviders.mpPF(context).togglePlayerHidden();
          }
        },
      ),
      child: Container(
        color: kCardBackgroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: kHPad / 2,
          vertical: kVPad / 2,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  formatDuration(
                      mpProvider.currentDuration ?? Duration(seconds: 30)),
                  style: h4TextStyleInactive,
                ),
                Expanded(
                  child: Slider(
                    // thumbs: [
                    //   CustomCircle(color: kAudioColor, radius: 8),
                    // ],
                    activeColor: kAudioColor,
                    inactiveColor: kAudioColor.withOpacity(.4),
                    onChanged: (double value) {
                      mpProvider.seekTo(value.toInt());
                    },
                    value:
                        (mpProvider.currentDuration?.inMilliseconds ?? 0) * 1,
                    min: 0,
                    max: (mpProvider.fullSongDuration?.inMilliseconds ??
                            100000) *
                        1,
                  ),
                ),
                Text(
                  formatDuration(
                      mpProvider.fullSongDuration ?? Duration(seconds: 200)),
                  style: h4TextStyleInactive,
                ),
              ],
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonWrapper(
                      width: largeIconSize,
                      height: largeIconSize,
                      onTap: () {
                        mpProvider.backward10();
                      },
                      child: Image.asset(
                        'assets/icons/back_ten.png',
                        color: kMainIconColor,
                        width: largeIconSize / 2,
                      ),
                    ),
                    ButtonWrapper(
                      width: largeIconSize,
                      height: largeIconSize,
                      onTap: () {
                        mpProvider.pausePlaying();
                      },
                      child: Image.asset(
                        'assets/icons/pause.png',
                        color: kMainIconColor,
                        width: largeIconSize / 2,
                      ),
                    ),
                    ButtonWrapper(
                      width: largeIconSize,
                      height: largeIconSize,
                      onTap: () {
                        mpProvider.forward10();
                      },
                      child: Image.asset(
                        'assets/icons/ten.png',
                        color: kMainIconColor,
                        width: largeIconSize / 2,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ButtonWrapper(
                      padding: EdgeInsets.all(mediumPadding),
                      onTap: () {
                        mediaAnimationController.currentState?.reverse();
                      },
                      child: Image.asset(
                        'assets/icons/arrow-down2.png',
                        color: kMainIconColor,
                        width: mediumIconSize,
                        height: mediumIconSize,
                      ),
                    ),
                    HSpace(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
