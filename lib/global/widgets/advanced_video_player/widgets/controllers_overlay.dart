// ignore_for_file: prefer_const_constructors

import 'package:explorer/global/widgets/advanced_video_player/widgets/play_pause_overlay.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/video_player_slider.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ControllersOverlay extends StatelessWidget {
  const ControllersOverlay({
    super.key,
  });

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
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.fullscreen),
                    color: Colors.white,
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
