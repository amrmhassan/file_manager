// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/global/widgets/video_player_viewer/widgets/actual_video_player.dart';
import 'package:explorer/global/widgets/video_player_viewer/widgets/video_controllers.dart';
import 'package:explorer/global/widgets/video_player_viewer/widgets/video_gesture_detectors.dart';
import 'package:explorer/global/widgets/video_player_viewer/widgets/video_paused_button.dart';
import 'package:explorer/global/widgets/video_player_viewer/widgets/video_position_viewer.dart';
import 'package:explorer/global/widgets/video_player_viewer/widgets/volume_viewer.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoPlayerViewer extends StatelessWidget {
  const VideoPlayerViewer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);
    var mpProviderFalse =
        Provider.of<MediaPlayerProvider>(context, listen: false);

    return mpProvider.videoPlayerController != null && (!mpProvider.videoHidden)
        ? Stack(
            alignment: Alignment.center,
            children: [
              ActualVideoPlayer(mpProvider: mpProvider),
              Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        VideoPlayGestureDetector(
                            mpProviderFalse: mpProviderFalse),
                        //? volume controller
                        VolumeGestureDetector(
                            mpProviderFalse: mpProviderFalse,
                            mpProvider: mpProvider)
                      ],
                    ),
                  ),
                  //? seeker controller
                  SeekerGestureDetector(
                      mpProviderFalse: mpProviderFalse, mpProvider: mpProvider)
                ],
              ),
              VolumeViewer(),
              VideoPositionViewer(),
              BottomVideoControllers(),
              VideoPausedButton(),
            ],
          )
        : SizedBox();
  }
}
