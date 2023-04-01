import 'package:explorer/providers/media_player_provider/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoPlayGestureDetector extends StatelessWidget {
  const VideoPlayGestureDetector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mpProviderFalse =
        Provider.of<MediaPlayerProvider>(context, listen: false);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          mpProviderFalse.toggleVideoPlay();
        },
        child: Opacity(
          opacity: 0,
          child: Container(color: Colors.green),
        ),
      ),
    );
  }
}

class VolumeGestureDetector extends StatelessWidget {
  const VolumeGestureDetector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mpProviderFalse =
        Provider.of<MediaPlayerProvider>(context, listen: false);
    return Listener(
      onPointerMove: (details) {
        mpProviderFalse.addToDeviceVolume(
          -(details.delta.dy / 500),
        );
      },
      onPointerDown: (details) {
        mpProviderFalse.setVolumeTouched(true);
      },
      onPointerUp: (position) {
        mpProviderFalse.setVolumeTouched(false);
      },
      child: Opacity(
        opacity: 0,
        child: Container(
          width: 100,
          color: Colors.blue,
        ),
      ),
    );
  }
}

class SeekerGestureDetector extends StatelessWidget {
  const SeekerGestureDetector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mpProviderFalse =
        Provider.of<MediaPlayerProvider>(context, listen: false);
    return GestureDetector(
      onPanUpdate: (details) {
        mpProviderFalse.addToPosition(
          (details.delta.dx),
        );
      },
      onPanDown: (details) {
        mpProviderFalse.setSeekerTouched(true);
      },
      onPanEnd: (details) {
        mpProviderFalse.setSeekerTouched(false);
      },
      onPanCancel: () {
        mpProviderFalse.setSeekerTouched(false);
      },
      child: Opacity(
        opacity: 0,
        child: Container(
          width: double.infinity,
          height: 150,
          color: Colors.red,
        ),
      ),
    );
  }
}
