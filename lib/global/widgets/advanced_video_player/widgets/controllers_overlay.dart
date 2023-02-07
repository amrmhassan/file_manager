// ignore_for_file: prefer_const_constructors

import 'package:explorer/global/widgets/advanced_video_player/widgets/play_pause_overlay.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/video_player_slider.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ControllersOverlay extends StatefulWidget {
  final Function(bool v) setControllersOverlayViewed;
  final VoidCallback toggleLandscape;

  const ControllersOverlay({
    super.key,
    required this.setControllersOverlayViewed,
    required this.toggleLandscape,
  });

  @override
  State<ControllersOverlay> createState() => _ControllersOverlayState();
}

class _ControllersOverlayState extends State<ControllersOverlay> {
  //! commented this just for testing
  // @overridea
  // void initState() {
  //   Future.delayed(Duration(milliseconds: 3000)).then((value) {
  //     if (mounted) {
  //       widget.setControllersOverlayViewed(false);
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);

    return Stack(
      children: [
        Column(
          children: [
            Spacer(),
            PaddingWrapper(
              child: Row(
                children: [
                  Spacer(),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: widget.toggleLandscape,
                        splashColor: Colors.white.withOpacity(.5),
                        icon: Icon(
                          MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? Icons.fullscreen_exit
                              : Icons.fullscreen,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (mpProvider.videoPlayerController != null) VideoPlayerSlider(),
            VSpace(),
          ],
        ),
        PlayPauseOverLay(),
      ],
    );
  }
}
