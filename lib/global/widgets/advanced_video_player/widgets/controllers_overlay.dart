// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/close_video_button.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/custom_icon_button.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/play_pause_overlay.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/settings_button.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/video_player_slider.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/providers/media_player_provider/media_player_provider.dart';
import 'package:explorer/utils/duration_utils.dart';
import 'package:explorer/utils/futures_utils.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/foundation.dart';
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
    if (!kDebugMode) {
      hideMeAfter();
    }
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
              VideoUpperControllers(
                toggleControllerOverLayViewed:
                    widget.toggleControllerOverLayViewed,
              ),
              Spacer(),
              if (mpProvider.videoPlayerController != null)
                FadeInUp(
                  preferences: AnimationPreferences(
                    duration: Duration(milliseconds: 250),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoLowerBackgroundShader(
                          toggleControllerOverLayViewed:
                              widget.toggleControllerOverLayViewed),
                      Column(
                        children: [
                          VideoMuteFullScreenControllers(
                            toggleLandscape: widget.toggleLandscape,
                          ),
                          VideoPlayerSlider(),
                          VideoDurationViewer(),
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

class VideoDurationViewer extends StatelessWidget {
  const VideoDurationViewer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);

    return PaddingWrapper(
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
    );
  }
}

class VideoLowerBackgroundShader extends StatelessWidget {
  final bool reverse;
  final VoidCallback toggleControllerOverLayViewed;

  const VideoLowerBackgroundShader({
    super.key,
    this.reverse = false,
    required this.toggleControllerOverLayViewed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleControllerOverLayViewed,
      child: Container(
        width: double.infinity,
        height: Responsive.getHeight(context) / 3,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: reverse
                ? [
                    Colors.transparent,
                    Colors.black.withOpacity(.6),
                  ]
                : [
                    Colors.black.withOpacity(1),
                    Colors.transparent,
                  ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0, .9],
          ),
        ),
      ),
    );
  }
}

class VideoMuteFullScreenControllers extends StatelessWidget {
  final VoidCallback toggleLandscape;

  const VideoMuteFullScreenControllers({
    super.key,
    required this.toggleLandscape,
  });

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);
    var mpProviderFalse =
        Provider.of<MediaPlayerProvider>(context, listen: false);
    return FadeInRight(
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
                mpProviderFalse.toggleHideVideo();
              },
              iconData: FontAwesomeIcons.eyeSlash,
            ),
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
              onTap: toggleLandscape,
              iconData:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? Icons.fullscreen_exit
                      : Icons.fullscreen,
            ),
          ],
        ),
      ),
    );
  }
}

class VideoUpperControllers extends StatelessWidget {
  final VoidCallback toggleControllerOverLayViewed;

  const VideoUpperControllers({
    super.key,
    required this.toggleControllerOverLayViewed,
  });

  @override
  Widget build(BuildContext context) {
    var mpProvider = mpP(context);

    return Stack(
      children: [
        VideoLowerBackgroundShader(
          reverse: true,
          toggleControllerOverLayViewed: toggleControllerOverLayViewed,
        ),
        Row(
          children: [
            CloseVideoButton(),
            Expanded(
              child: SafeArea(
                child: Text(
                  getFileName(mpProvider.playingVideoPath ?? ''),
                  style: h4TextStyle.copyWith(height: 5),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            FadeInRight(
              preferences: AnimationPreferences(
                duration: Duration(milliseconds: 350),
              ),
              child: SettingsButton(),
            ),
          ],
        ),
      ],
    );
  }
}
