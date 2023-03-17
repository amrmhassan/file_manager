// ignore_for_file: prefer_const_constructors, unused_field

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final Duration animationDuration = Duration(milliseconds: 350);
final Duration reverseDuration = Duration(milliseconds: 350);

class PlayPauseOverLay extends StatefulWidget {
  // final VoidCallback toggleControllerOverLayViewed;

  const PlayPauseOverLay({
    super.key,
    // required this.toggleControllerOverLayViewed,
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
    mediaPF(context).setAnimationController(_controller);

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
    mediaPF(navigatorKey.currentContext!).disposeAnimationController();
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
            Stack(
              alignment: Alignment.center,
              children: [
                BufferingLoader(),
                ButtonWrapper(
                  backgroundColor: Colors.black.withOpacity(.4),
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
                    // if the button played the video then clear the user way from teh overlays after 3 seconds(the minimum when the video is playing)
                    // if (mpProviderFalse.isVideoPlaying && mounted) {
                    //   Future.delayed(Duration(milliseconds: 3 * 1000))
                    //       .then((value) {
                    //     widget.toggleControllerOverLayViewed();
                    //   });
                    // }
                  },
                  child: AnimatedIcon(
                    icon: AnimatedIcons.pause_play,
                    progress: _controller.view,
                    color: Colors.white,
                    size: mediumIconSize,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class BufferingLoader extends StatelessWidget {
  const BufferingLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var mpProvider = mpP(context);
    return mpProvider.isBuffering
        ? SizedBox(
            width: largeIconSize * 2 - 5,
            height: largeIconSize * 2 - 5,
            child: CircularProgressIndicator(
              color: Colors.white.withOpacity(.9),
              strokeWidth: 5,
            ),
          )
        : SizedBox();
  }
}
