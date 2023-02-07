// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/custom_icon_button.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/play_pause_overlay.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/settings_button.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/video_player_slider.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:explorer/utils/duration_utils.dart';
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
  //! commented this just for testing
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 3000)).then((value) {
      if (mounted) {
        widget.toggleControllerOverLayViewed();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);
    var mpProviderFalse =
        Provider.of<MediaPlayerProvider>(context, listen: false);

    return Stack(
      children: [
        Column(
          children: [
            FadeInRight(
              preferences: AnimationPreferences(
                duration: Duration(milliseconds: 500),
              ),
              child: SettingsButton(),
            ),
            Spacer(),
            FadeInRight(
              preferences: AnimationPreferences(
                duration: Duration(milliseconds: 500),
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
                  duration: Duration(milliseconds: 300),
                ),
                child: Column(
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
              ),
          ],
        ),
        PlayPauseOverLay(),
      ],
    );
  }
}
