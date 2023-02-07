// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/base_over_lay.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/controllers_overlay.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/play_pause_overlay.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/video_player_slider.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/global/widgets/video_player_viewer/widgets/actual_video_player.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AdvancedVideoPlayer extends StatefulWidget {
  const AdvancedVideoPlayer({
    Key? key,
  }) : super(key: key);

  @override
  State<AdvancedVideoPlayer> createState() => _AdvancedVideoPlayerState();
}

class _AdvancedVideoPlayerState extends State<AdvancedVideoPlayer> {
  bool controllerOverLayViewed = true;
  void setControllersOverlayViewed(bool v) {
    setState(() {
      controllerOverLayViewed = v;
    });
  }

  void toggleControllerOverLayViewed() {
    setState(() {
      controllerOverLayViewed = !controllerOverLayViewed;
    });
  }

  void toggleStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
    );

    var mediaProvider =
        Provider.of<MediaPlayerProvider>(context, listen: false);
    if (mediaProvider.videoPlayerController == null) return;
  }

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);
    // var mpProviderFalse =
    //     Provider.of<MediaPlayerProvider>(context, listen: false);

    return mpProvider.videoPlayerController != null && (!mpProvider.videoHidden)
        ? WillPopScope(
            onWillPop: () async {
              Provider.of<MediaPlayerProvider>(context, listen: false)
                  .toggleHideVideo();

              return false;
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ActualVideoPlayer(mpProvider: mpProvider),
                BaseOverLay(
                  toggleControllerOverLayViewed: toggleControllerOverLayViewed,
                ),
                if (controllerOverLayViewed) ControllersOverlay(),
              ],
            ),
          )
        : SizedBox();
  }
}
