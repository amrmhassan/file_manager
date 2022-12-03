// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerButton extends StatefulWidget {
  final String audioPath;

  const AudioPlayerButton({
    Key? key,
    required this.audioPath,
  }) : super(key: key);

  @override
  State<AudioPlayerButton> createState() => _AudioPlayerButtonState();
}

class _AudioPlayerButtonState extends State<AudioPlayerButton> {
  bool playing = false;
  void togglePlaying() {
    setState(() {
      playing = !playing;
    });
  }

  AudioPlayer audioPlayer = AudioPlayer();
  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (getFileExtension(widget.audioPath) == 'opus')
        ? ButtonWrapper(
            onTap: () async {
              try {
                Duration? duration =
                    await audioPlayer.setFilePath(widget.audioPath);
                if (playing) {
                  audioPlayer.stop();
                } else {
                  audioPlayer.play();
                }
                togglePlaying();
              } catch (e) {
                //
              }
            },
            width: largeIconSize,
            height: largeIconSize,
            child: Image.asset(
              playing
                  ? 'assets/icons/pause.png'
                  : 'assets/icons/play-audio.png',
              width: largeIconSize / 2,
              color: kInactiveColor,
            ),
          )
        : SizedBox();
  }
}
