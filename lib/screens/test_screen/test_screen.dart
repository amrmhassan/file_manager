// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:audio_service/audio_service.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  static const String routeName = '/TestScreen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  MediaItem mediaItem = MediaItem(
      id: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      title: 'Media Playing',
      extras: {
        'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      });
  @override
  void initState() {
    myTestMediaHandler.addQueueItem(mediaItem);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          ElevatedButton(
            onPressed: () {
              myTestMediaHandler.play();
            },
            child: Text('Play'),
          ),
          ElevatedButton(
            onPressed: () {
              myTestMediaHandler.pause();
            },
            child: Text('Pause'),
          ),
        ],
      ),
    );
  }
}
