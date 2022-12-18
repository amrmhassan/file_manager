import 'package:explorer/providers/media_player_provider.dart';
import 'package:flutter/material.dart';

class VideoPlayGestureDetector extends StatelessWidget {
  const VideoPlayGestureDetector({
    Key? key,
    required this.mpProviderFalse,
  }) : super(key: key);

  final MediaPlayerProvider mpProviderFalse;

  @override
  Widget build(BuildContext context) {
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
    required this.mpProviderFalse,
    required this.mpProvider,
  }) : super(key: key);

  final MediaPlayerProvider mpProviderFalse;
  final MediaPlayerProvider mpProvider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        mpProviderFalse.addToVolume(
          -(details.delta.dy / 800),
        );
      },
      onPanDown: (details) {
        mpProvider.setVolumeTouched(true);
      },
      onPanEnd: (details) {
        mpProvider.setVolumeTouched(false);
      },
      onPanCancel: () {
        mpProvider.setVolumeTouched(false);
      },
      child: Opacity(
        opacity: 0,
        child: Container(
          width: 70,
          color: Colors.blue,
        ),
      ),
    );
  }
}

class SeekerGestureDetector extends StatelessWidget {
  const SeekerGestureDetector({
    Key? key,
    required this.mpProviderFalse,
    required this.mpProvider,
  }) : super(key: key);

  final MediaPlayerProvider mpProviderFalse;
  final MediaPlayerProvider mpProvider;

  @override
  Widget build(BuildContext context) {
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
