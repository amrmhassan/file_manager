// ignore_for_file: prefer_const_constructors, unused_field

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/windows_app_code/utils/windows_provider_calls.dart';
import 'package:flutter/material.dart';

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
  late bool isVideoPlayingLocal;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    isVideoPlayingLocal = WindowSProviders.mpPF(context).isVideoPlaying;

    _controller = AnimationController(
      vsync: this,
      duration: animationDuration,
      reverseDuration: reverseDuration,
    );
    WindowSProviders.animationPF(context).setAnimationController(_controller);

    var mpProviderFalse = WindowSProviders.mpPF(context);
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
    var mpProviderFalse = WindowSProviders.mpPF(context);

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
    var mpProvider = WindowSProviders.mpP(context);
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
