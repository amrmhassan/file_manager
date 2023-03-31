// ignore_for_file: prefer_const_constructors

import 'package:explorer/global/widgets/custom_slider/custom_circle.dart';
import 'package:explorer/global/widgets/custom_slider/custom_slider.dart';
import 'package:explorer/utils/futures_utils.dart';
import 'package:explorer/windows_app_code/utils/windows_provider_calls.dart';
import 'package:flutter/material.dart';

class VideoPlayerSlider extends StatefulWidget {
  const VideoPlayerSlider({
    super.key,
  });

  @override
  State<VideoPlayerSlider> createState() => _VideoPlayerSliderState();
}

class _VideoPlayerSliderState extends State<VideoPlayerSlider> {
  bool touched = true;
  late CustomFuture customFuture;

  void seekerTouched() {
    setState(() {
      touched = true;
    });
  }

  void seekerLeft() {
    try {
      customFuture.cancel();
    } catch (e) {
      //
    }
    customFuture = CustomFuture()
      ..delayedAction(Duration(seconds: 2), () {
        setState(() {
          touched = false;
        });
      });
  }

  @override
  void initState() {
    seekerLeft();
    super.initState();
  }

  @override
  void dispose() {
    customFuture.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mpProvider = WindowSProviders.mpP(context);
    var mpProviderFalse = WindowSProviders.mpPF(context);

    return mpProvider.videoDuration == null
        ? SizedBox()
        : Listener(
            onPointerDown: (event) {
              seekerTouched();
            },
            onPointerUp: (event) {
              seekerLeft();
            },
            child: CustomSlider(
              thumbs: [
                CustomCircle(
                  color: Colors.red,
                  radius: touched ? 7 : 0,
                ),
              ],
              activeThickness: touched ? 3 : 2,
              inactiveThickness: 2,
              inactiveColor: Colors.grey.withOpacity(.5),
              activeColor: Colors.red,
              min: 0,
              max: mpProvider.videoDuration!.inMilliseconds.toDouble(),
              value: mpProvider.videoPosition.inMilliseconds.toDouble(),
              onChanged: (value) {
                mpProviderFalse.seekVideo(value);
              },
              // subRanges: mpProvider.bufferedTransformer,
            ),
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