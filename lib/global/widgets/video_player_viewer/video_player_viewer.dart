// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/global/widgets/video_player_viewer/widgets/video_position_viewer.dart';
import 'package:explorer/global/widgets/video_player_viewer/widgets/volume_viewer.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerViewer extends StatelessWidget {
  const VideoPlayerViewer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);
    var mpProviderFalse =
        Provider.of<MediaPlayerProvider>(context, listen: false);

    return mpProvider.videoPlayerController == null
        ? SizedBox()
        : Stack(
            alignment: Alignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                color: Colors.black,
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: mpProvider.videoAspectRatio ?? 1,
                      child: VideoPlayer(
                        mpProvider.videoPlayerController!,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              mpProviderFalse.toggleVideoPlay();
                            },
                            child: Opacity(
                              opacity: 0,
                              child: Container(color: Colors.green),
                            ),
                          ),
                        ),
                        //? volume controller
                        GestureDetector(
                          onPanUpdate: (details) {
                            mpProviderFalse.addToVolume(
                              -(details.delta.dy / 800),
                            );
                          },
                          onPanDown: (details) {
                            mpProvider.setVolumeTouched(true);
                          },
                          onPanEnd: (details) {
                            mpProvider.setVolumeTouched(false);
                          },
                          onPanCancel: () {
                            mpProvider.setVolumeTouched(false);
                          },
                          child: Opacity(
                            opacity: 0,
                            child: Container(
                              width: 70,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  //? seeker controller
                  GestureDetector(
                    onPanUpdate: (details) {
                      mpProviderFalse.addToPosition(
                        (details.delta.dx),
                      );
                    },
                    onPanDown: (details) {
                      mpProvider.setSeekerTouched(true);
                    },
                    onPanEnd: (details) {
                      mpProvider.setSeekerTouched(false);
                    },
                    onPanCancel: () {
                      mpProvider.setSeekerTouched(false);
                    },
                    child: Opacity(
                      opacity: 0,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
              VolumeViewer(),
              VideoPositionViewer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      mpProvider.closeVideo();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ],
          );
  }
}
