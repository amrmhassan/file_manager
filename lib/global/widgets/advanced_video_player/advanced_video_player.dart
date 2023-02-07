// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/global/widgets/advanced_video_player/widgets/base_over_lay.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/controllers_overlay.dart';
import 'package:explorer/global/widgets/video_player_viewer/widgets/actual_video_player.dart';
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

class _AdvancedVideoPlayerState extends State<AdvancedVideoPlayer>
    with WidgetsBindingObserver {
  bool controllerOverLayViewed = true;
  //? to activate the landscape mode
  Future<void> activateLandScapeMode() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft]);
  }

//? to activate the portrait mode
  Future<void> activatePortraitMode() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await SystemChrome.restoreSystemUIOverlays();
  }

//? to toggle between them
  void toggleLandScape() async {
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    if (currentOrientation == Orientation.landscape) {
      await activatePortraitMode();
    } else {
      await activateLandScapeMode();
    }
  }

//?
  void setControllersOverlayViewed(bool v) {
    setState(() {
      controllerOverLayViewed = v;
    });
  }

//?
  void toggleControllerOverLayViewed() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    setState(() {
      controllerOverLayViewed = !controllerOverLayViewed;
    });
  }

  @override
  void initState() {
    super.initState();

    var mediaProvider =
        Provider.of<MediaPlayerProvider>(context, listen: false);
    if (mediaProvider.videoPlayerController == null) return;
  }

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);

    return mpProvider.videoPlayerController != null && (!mpProvider.videoHidden)
        ? WillPopScope(
            onWillPop: () async {
              Provider.of<MediaPlayerProvider>(context, listen: false)
                  .toggleHideVideo();
              await activatePortraitMode();
              setControllersOverlayViewed(true);

              return false;
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ActualVideoPlayer(
                  mpProvider: mpProvider,
                ),
                BaseOverLay(
                  toggleControllerOverLayViewed: toggleControllerOverLayViewed,
                ),
                if (controllerOverLayViewed)
                  ControllersOverlay(
                    setControllersOverlayViewed: setControllersOverlayViewed,
                    toggleLandscape: toggleLandScape,
                  ),
              ],
            ),
          )
        : SizedBox();
  }
}
