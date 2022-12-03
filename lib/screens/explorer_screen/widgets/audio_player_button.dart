// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  //? this will check if the current path is the active path in the media player or not
  bool isMyPathActive(String? playingFilePath) {
    bool res = playingFilePath == widget.audioPath;
    return res;
  }

  bool mePlaying(String? playingFilePath, bool isPlaying) {
    return isMyPathActive(playingFilePath) && isPlaying;
  }

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);
    return (getFileType(getFileExtension(widget.audioPath)) == FileType.audio)
        ? ButtonWrapper(
            onTap: () async {
              //
              if (mePlaying(widget.audioPath, mpProvider.playing)) {
                // here i am playing and i want to pause
                await mpProvider.pausePlaying();
              }
              // else if (myPathActive(mpProvider.playingFilePath) &&
              //     !mpProvider.playing) {
              //   //! here i my path is active and i want to resume playing
              //   await mpProvider.setPlayingFile(widget.audioPath);
              // }
              else {
                // here i want to start over
                await mpProvider.setPlayingFile(widget.audioPath);
              }
            },
            width: largeIconSize,
            height: largeIconSize,
            child: Image.asset(
              mePlaying(widget.audioPath, mpProvider.playing)
                  ? 'assets/icons/pause.png'
                  : 'assets/icons/play-audio.png',
              width: largeIconSize / 2,
              color: kInactiveColor,
            ),
          )
        : SizedBox();
  }
}
