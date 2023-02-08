// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/close_video_button.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/custom_icon_button.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/play_pause_overlay.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/settings_button.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/video_player_slider.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:explorer/utils/duration_utils.dart';
import 'package:explorer/utils/futures_utils.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ControllersOverlay extends StatefulWidget {
  final VoidCallback toggleControllerOverLayViewed;
  final VoidCallback toggleLandscape;

  const ControllersOverlay({
    super.key,
    required this.toggleControllerOverLayViewed,
    required this.toggleLandscape,
  });

  @override
  State<ControllersOverlay> createState() => _ControllersOverlayState();
}

class _ControllersOverlayState extends State<ControllersOverlay> {
  late CustomFuture customFuture;
  late Duration hideMeAfterDuration;

  Duration get defaultDuration {
    var mpProvider = mpPF(context);
    return Duration(
        milliseconds: mpProvider.isVideoPlaying ? 3 * 1000 : 20 * 1000);
  }

  void cancelHidingFuture() {
    // print('cancelling hiding');
    try {
      customFuture.cancel();
    } catch (e) {
      printOnDebug('First time to open controller overlay');
    }
  }

  hideMeAfter() {
    // print('running hiding future');
    cancelHidingFuture();

    hideMeAfterDuration = defaultDuration;
    customFuture = CustomFuture()
      ..delayedAction(
        hideMeAfterDuration,
        widget.toggleControllerOverLayViewed,
      );
  }

  @override
  void initState() {
    //! activate this
    // hideMeAfter();
    super.initState();
  }

  @override
  void dispose() {
    cancelHidingFuture();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);
    var mpProviderFalse =
        Provider.of<MediaPlayerProvider>(context, listen: false);

    return Listener(
      onPointerDown: (details) {
        cancelHidingFuture();
      },
      onPointerUp: (event) {
        hideMeAfter();
      },
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  CloseVideoButton(),
                  Spacer(),
                  FadeInRight(
                    preferences: AnimationPreferences(
                      duration: Duration(milliseconds: 350),
                    ),
                    child: SettingsButton(),
                  ),
                ],
              ),
              Spacer(),
              FadeInRight(
                preferences: AnimationPreferences(
                  duration: Duration(milliseconds: 350),
                ),
                child: PaddingWrapper(
                  child: Row(
                    children: [
                      Spacer(),
                      CustomIconButton(
                        color: Colors.white.withOpacity(.8),
                        onTap: () {
                          mpProviderFalse.toggleMuteVideo();
                        },
                        iconData: mpProvider.videoMuted
                            ? FontAwesomeIcons.volumeXmark
                            : FontAwesomeIcons.volumeLow,
                      ),
                      CustomIconButton(
                        onTap: widget.toggleLandscape,
                        iconData: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                      ),
                    ],
                  ),
                ),
              ),
              if (mpProvider.videoPlayerController != null)
                FadeInUp(
                  preferences: AnimationPreferences(
                    duration: Duration(milliseconds: 250),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: double.infinity,
                        height: Responsive.getHeight(context) / 4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(.4),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          VideoPlayerSlider(),
                          PaddingWrapper(
                            child: Row(
                              children: [
                                Text(
                                  '${durationToString(mpProvider.videoPosition)} / ${durationToString(mpProvider.videoDuration)}',
                                  style: h5TextStyle.copyWith(
                                    color: Colors.white.withOpacity(.8),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          VSpace(),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
          PlayPauseOverLay(
              // toggleControllerOverLayViewed: widget.toggleControllerOverLayViewed,
              ),
        ],
      ),
    );
  }
}
