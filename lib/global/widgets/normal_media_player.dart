// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:provider/provider.dart';

class NormalMediaPlayer extends StatefulWidget {
  const NormalMediaPlayer({super.key});

  @override
  State<NormalMediaPlayer> createState() => _NormalMediaPlayerState();
}

class _NormalMediaPlayerState extends State<NormalMediaPlayer> {
  final GlobalKey<AnimatorWidgetState> mediaAnimationController =
      GlobalKey<AnimatorWidgetState>();
  @override
  Widget build(BuildContext context) {
    var mpProvider = mpP(context);
    var mpProviderFalse = mpPF(context);

    return FadeInUpBig(
      key: mediaAnimationController,
      preferences: AnimationPreferences(
        duration: Duration(milliseconds: 200),
        animationStatusListener: (status) {
          if (status == AnimationStatus.reverse) {
            printOnDebug(status);
            Provider.of<MediaPlayerProvider>(context, listen: false)
                .togglePlayerHidden();
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
            if (mpProvider.fullSongDuration != null &&
                mpProvider.currentDuration != null)
              Row(
                children: [
                  Text(
                    formatDuration(
                        mpProvider.currentDuration ?? Duration(seconds: 30)),
                    style: h4TextStyleInactive,
                  ),
                  Expanded(
                    child: Slider(
                      thumbColor: kAudioColor,
                      activeColor: kAudioColor,
                      inactiveColor: kAudioColor.withOpacity(.4),
                      onChanged: (double value) {
                        mpProvider.seekTo(value.toInt());
                      },
                      value:
                          mpProvider.currentDuration!.inMilliseconds.toDouble(),
                      min: 0,
                      max: mpProvider.fullSongDuration!.inMilliseconds
                          .toDouble(),
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
                        mpProviderFalse.backward10();
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
                        if (mpProviderFalse.audioPlaying) {
                          mpProviderFalse.pauseAudioPlaying();
                        } else {
                          mpProviderFalse.resumeAudioPlaying();
                        }
                      },
                      child: Image.asset(
                        mpProvider.audioPlaying
                            ? 'assets/icons/pause.png'
                            : 'assets/icons/play-button-arrowhead.png',
                        color: kMainIconColor,
                        width: largeIconSize / 2,
                      ),
                    ),
                    ButtonWrapper(
                      width: largeIconSize,
                      height: largeIconSize,
                      onTap: () {
                        mpProviderFalse.forward10();
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
                Positioned(
                  left: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      HSpace(),
                      ButtonWrapper(
                        padding: EdgeInsets.all(largePadding),
                        onTap: () {
                          mpPF(context).stopAudioPlaying();
                        },
                        child: Image.asset(
                          'assets/icons/close.png',
                          color: kMainIconColor,
                          width: smallIconSize,
                          height: smallIconSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
