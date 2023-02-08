// ignore_for_file: prefer_const_constructors

import 'package:explorer/global/widgets/custom_slider/custom_slider.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoPlayerSlider extends StatelessWidget {
  const VideoPlayerSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);
    var mpProviderFalse =
        Provider.of<MediaPlayerProvider>(context, listen: false);

    return mpProvider.videoDuration == null
        ? SizedBox()
        : CustomSlider(
            circleRadius: 7,
            activeThickness: 3,
            inactiveThickness: 2,
            inactiveColor: Colors.grey.withOpacity(.5),
            activeColor: Colors.red,
            circleColor: Colors.red,
            min: 0,
            max: mpProvider.videoDuration!.inMilliseconds.toDouble(),
            value: mpProvider.videoPosition.inMilliseconds.toDouble(),
            onChanged: (value) {
              mpProviderFalse.seekVideo(value);
            },
          );
  }
}

// data: SliderTheme.of(context).copyWith(
//               thumbShape: RoundSliderThumbShape(
//                 disabledThumbRadius: 20,
//                 enabledThumbRadius: 7,
//               ),
//               trackHeight: 4,
//               activeTrackColor: Colors.red,
//               inactiveTrackColor: Colors.grey.withOpacity(.5),
//               secondaryActiveTrackColor: Colors.grey.withOpacity(.8),
//               thumbColor: Colors.red,
//             ),
 // secondaryTrackValue: mpProvider.bufferedParts.isEmpty
              //     ? null
              //     : (mpProvider.videoPosition.inMilliseconds +
              //                 mpProvider
              //                     .bufferedParts.last.end.inMilliseconds) >
              //             mpProvider.videoDuration!.inMilliseconds
              //         ? mpProvider.videoDuration!.inMilliseconds.toDouble()
              //         : (mpProvider.videoPosition.inMilliseconds +
              //                 mpProvider.bufferedParts.last.end.inMilliseconds)
              //             .toDouble()
              //             .toDouble(),