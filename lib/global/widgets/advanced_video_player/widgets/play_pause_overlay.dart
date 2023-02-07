// ignore_for_file: prefer_const_constructors, unused_field

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final Duration animationDuration = Duration(milliseconds: 350);
final Duration reverseDuration = Duration(milliseconds: 350);

class PlayPauseOverLay extends StatefulWidget {
  const PlayPauseOverLay({
    super.key,
  });

  @override
  State<PlayPauseOverLay> createState() => _PlayPauseOverLayState();
}

class _PlayPauseOverLayState extends State<PlayPauseOverLay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: animationDuration,
      reverseDuration: reverseDuration,
    );
    var mpProviderFalse =
        Provider.of<MediaPlayerProvider>(context, listen: false);
    if (mpProviderFalse.isVideoPlaying) {
      _controller.reverseDuration = Duration.zero;
      _controller.reverse();
    } else {
      _controller.duration = Duration.zero;
      _controller.forward();
    }
    _controller.duration = animationDuration;
    _controller.reverseDuration = reverseDuration;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mpProviderFalse =
        Provider.of<MediaPlayerProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWrapper(
              backgroundColor: Colors.black.withOpacity(.8),
              borderRadius: 1000,
              width: largeIconSize * 2,
              height: largeIconSize * 2,
              onTap: () {
                if (mpProviderFalse.isVideoPlaying) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
                mpProviderFalse.toggleVideoPlay();
              },
              child: AnimatedIcon(
                icon: AnimatedIcons.pause_play,
                progress: _controller.view,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
