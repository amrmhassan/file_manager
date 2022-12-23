// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediaPlayerButton extends StatefulWidget {
  final String mediaPath;

  const MediaPlayerButton({
    Key? key,
    required this.mediaPath,
  }) : super(key: key);

  @override
  State<MediaPlayerButton> createState() => _MediaPlayerButtonState();
}

class _MediaPlayerButtonState extends State<MediaPlayerButton> {
  //? this will check if the current path is the active path in the media player or not
  bool isMyPathActive(String? playingFilePath) {
    bool res = playingFilePath == widget.mediaPath;
    return res;
  }

  bool mePlaying(String? playingFilePath, bool isPlaying) {
    return isMyPathActive(playingFilePath) && isPlaying;
  }

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);
    var mpProviderFalse =
        Provider.of<MediaPlayerProvider>(context, listen: false);
    FileType fileType = getFileType(getFileExtension(widget.mediaPath));

    return fileType == FileType.audio
        ? ButtonWrapper(
            onTap: () async {
              //
              if (mePlaying(
                  mpProvider.playingAudioFilePath, mpProvider.audioPlaying)) {
                // here i am playing and i want to pause
                await mpProviderFalse.pausePlaying();
              } else {
                // here i want to start over
                await mpProviderFalse.setPlayingFile(widget.mediaPath);
              }
            },
            width: largeIconSize,
            height: largeIconSize,
            child: Image.asset(
              mePlaying(
                      mpProvider.playingAudioFilePath, mpProvider.audioPlaying)
                  ? 'assets/icons/pause.png'
                  : 'assets/icons/play-audio.png',
              width: largeIconSize / 2,
              color: kInactiveColor,
            ),
          )
        : fileType == FileType.video
            ? ButtonWrapper(
                onTap: () async {
                  mpProviderFalse.playVideo(widget.mediaPath);
                  mpProviderFalse.setBottomVideoControllersHidden(false);
                },
                width: largeIconSize,
                height: largeIconSize,
                child: Image.asset(
                  'assets/icons/view.png',
                  width: largeIconSize / 1.5,
                  color: kInactiveColor,
                ),
              )
            : SizedBox();
  }
}
