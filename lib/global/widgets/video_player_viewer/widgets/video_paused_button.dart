// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoPausedButton extends StatelessWidget {
  const VideoPausedButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);
    return mpProvider.videoPlayerController != null &&
            !mpProvider.isVideoPlaying
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Provider.of<MediaPlayerProvider>(context, listen: false)
                      .toggleVideoPlay();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: largeIconSize * 2,
                  height: largeIconSize * 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                    color: Colors.white.withOpacity(.8),
                  ),
                  child: Image.asset(
                    'assets/icons/play-button-arrowhead.png',
                    width: mediumIconSize,
                    color: Colors.black.withOpacity(.9),
                  ),
                ),
              )
            ],
          )
        : SizedBox();
  }
}
