// ignore_for_file: prefer_const_constructors

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

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: RoundSliderThumbShape(
          disabledThumbRadius: 20,
          enabledThumbRadius: 7,
        ),
        trackHeight: 4,
        activeTrackColor: Colors.red,
        inactiveTrackColor: Colors.grey.withOpacity(.5),
        secondaryActiveTrackColor: Colors.grey.withOpacity(.8),
        thumbColor: Colors.red,
      ),
      child: mpProvider.videoDuration == null
          ? SizedBox()
          : Slider(
              min: 0,
              max: mpProvider.videoDuration!.inMilliseconds.toDouble(),
              value: mpProvider.videoPosition.inMilliseconds.toDouble(),
              onChanged: (value) {
                mpProviderFalse.seekVideo(value);
              },
              // secondaryTrackValue: (mpProvider.videoPosition.inMilliseconds +
              //             mpProvider.videoPlayerController!.value.buffered.last
              //                 .end.inMilliseconds) >
              //         mpProvider.videoDuration!.inMilliseconds
              //     ? mpProvider.videoDuration!.inMilliseconds.toDouble()
              //     : (mpProvider.videoPosition.inMilliseconds +
              //             mpProvider.videoPlayerController!.value.buffered.last
              //                 .end.inMilliseconds)
              //         .toDouble()
              //         .toDouble(),
            ),
    );
  }
}

// class CustomTrackShape extends SliderTrackShape {
//   @override
//   Rect getPreferredRect({
//     required RenderBox parentBox,
//     Offset offset = Offset.zero,
//     required SliderThemeData sliderTheme,
//     bool isEnabled = false,
//     bool isDiscrete = false,
//   }) {
//     final double thumbWidth =
//         sliderTheme.thumbShape!.getPreferredSize(isEnabled, isDiscrete).width;
//     const double trackHeight = 8.0;
//     final double trackLeft = offset.dx + thumbWidth / 2;
//     final double trackTop =
//         offset.dy + (sliderTheme.trackHeight! - trackHeight) / 2;
//     final double trackWidth = parentBox.size.width - thumbWidth;
//     return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
//   }

//   @override
//   void paint(PaintingContext context, Offset offset,
//       {required RenderBox parentBox,
//       required SliderThemeData sliderTheme,
//       required Animation<double> enableAnimation,
//       required Offset thumbCenter,
//       Offset? secondaryOffset,
//       bool isEnabled = true,
//       bool isDiscrete = true,
//       required TextDirection textDirection}) {
//     final Rect trackRect = getPreferredRect(
//       parentBox: parentBox,
//       offset: offset,
//       sliderTheme: sliderTheme,
//       isEnabled: isEnabled,
//       isDiscrete: isDiscrete,
//     );

//     final Paint activeTrackPaint = Paint()
//       ..color = sliderTheme.activeTrackColor!
//       ..style = PaintingStyle.fill;
//     context.canvas.drawRect(trackRect, activeTrackPaint);

//     final Paint inactiveTrackPaint = Paint()
//       ..color = sliderTheme.inactiveTrackColor!
//       ..style = PaintingStyle.fill;
//     final double thumbWidth =
//         sliderTheme.thumbShape!.getPreferredSize(isEnabled, isDiscrete).width;
//     final double inactiveTrackWidth = parentBox.size.width - thumbWidth;
//     final Rect inactiveTrackRect = Rect.fromLTWH(
//       trackRect.left,
//       trackRect.top,
//       inactiveTrackWidth,
//       trackRect.height,
//     );
//     context.canvas.drawRect(inactiveTrackRect, inactiveTrackPaint);
//   }
// }
