// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/providers/media_player_provider/media_player_provider.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:explorer/windows_app_code/utils/windows_provider_calls.dart';
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

  bool get viewSeeker {
    if (Platform.isAndroid) {
      var mpProvider = mpP(context);
      return (mpProvider.fullSongDuration != null &&
          mpProvider.currentDuration != null);
    } else {
      var mpProvider = WindowSProviders.mpP(context);
      return (mpProvider.fullSongDuration != null &&
          mpProvider.currentDuration != null);
    }
  }

  String get currentDuration {
    if (Platform.isAndroid) {
      var mpProvider = mpP(context);

      return formatDuration(
          mpProvider.currentDuration ?? Duration(seconds: 30));
    } else {
      var mpProvider = WindowSProviders.mpP(context);
      return formatDuration(
          mpProvider.currentDuration ?? Duration(seconds: 30));
    }
  }

  String get fullSongDuration {
    if (Platform.isAndroid) {
      var mpProvider = mpP(context);

      return formatDuration(
          mpProvider.fullSongDuration ?? Duration(seconds: 200));
    } else {
      var mpProvider = WindowSProviders.mpP(context);
      return formatDuration(
          mpProvider.fullSongDuration ?? Duration(seconds: 200));
    }
  }

  void onSeeking(double value) {
    if (Platform.isAndroid) {
      var mpProvider = mpPF(context);
      mpProvider.seekTo(value.toInt());
    } else {
      var mpProvider = WindowSProviders.mpPF(context);
      mpProvider.seekTo(value.toInt());
    }
  }

  double get currentSeekerValue {
    if (Platform.isAndroid) {
      var mpProvider = mpP(context);
      return mpProvider.currentDuration!.inMilliseconds.toDouble();
    } else {
      var mpProvider = WindowSProviders.mpP(context);
      return mpProvider.currentDuration!.inMilliseconds.toDouble();
    }
  }

  double get maxSeekingValue {
    if (Platform.isAndroid) {
      var mpProvider = mpP(context);
      return mpProvider.fullSongDuration!.inMilliseconds.toDouble();
    } else {
      var mpProvider = WindowSProviders.mpP(context);
      return mpProvider.fullSongDuration!.inMilliseconds.toDouble();
    }
  }

  bool get isPlaying {
    if (Platform.isAndroid) {
      var mpProvider = mpP(context);

      return mpProvider.audioPlaying;
    } else {
      var mpProvider = WindowSProviders.mpP(context);
      return mpProvider.audioPlaying;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            if (viewSeeker)
              Row(
                children: [
                  Text(
                    currentDuration,
                    style: h4TextStyleInactive,
                  ),
                  Expanded(
                    child: Slider(
                      thumbColor: kAudioColor,
                      activeColor: kAudioColor,
                      inactiveColor: kAudioColor.withOpacity(.4),
                      onChanged: onSeeking,
                      value: currentSeekerValue,
                      min: 0,
                      max: maxSeekingValue,
                    ),
                  ),
                  Text(
                    fullSongDuration,
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
                        if (Platform.isAndroid) {
                          var mpProviderFalse = mpPF(context);
                          mpProviderFalse.backward10();
                        } else {
                          var mpProviderFalse = WindowSProviders.mpPF(context);
                          mpProviderFalse.backward10();
                        }
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
                        if (Platform.isAndroid) {
                          var mpProviderFalse = mpPF(context);
                          if (mpProviderFalse.audioPlaying) {
                            mpProviderFalse.pauseAudioPlaying();
                          } else {
                            mpProviderFalse.resumeAudioPlaying();
                          }
                        } else {
                          var mpProviderFalse = WindowSProviders.mpPF(context);
                          if (mpProviderFalse.audioPlaying) {
                            mpProviderFalse.pausePlaying();
                          } else {
                            mpProviderFalse.resumePlaying();
                          }
                        }
                      },
                      child: Image.asset(
                        isPlaying
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
                        if (Platform.isAndroid) {
                          var mpProviderFalse = mpPF(context);
                          mpProviderFalse.forward10();
                        } else {
                          var mpProviderFalse = WindowSProviders.mpPF(context);
                          mpProviderFalse.forward10();
                        }
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
