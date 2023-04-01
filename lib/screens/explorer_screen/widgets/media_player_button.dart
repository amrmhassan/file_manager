// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:explorer/windows_app_code/utils/windows_provider_calls.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class MediaPlayerButton extends StatefulWidget {
  final String mediaPath;
  final bool network;

  const MediaPlayerButton({
    Key? key,
    required this.mediaPath,
    required this.network,
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

  bool get mePlaying {
    if (Platform.isAndroid) {
      var mpProviderAndroid = mediaPF(context);

      return isMyPathActive(mpProviderAndroid.playingAudioFilePath) &&
          mpProviderAndroid.audioPlaying;
    } else {
      var mpProviderWindows = WindowSProviders.mpPF(context);
      return isMyPathActive(mpProviderWindows.playingAudioFilePath) &&
          mpProviderWindows.audioPlaying;
    }
  }

  @override
  Widget build(BuildContext context) {
    FileType fileType = getFileType(getFileExtension(widget.mediaPath));

    return fileType == FileType.audio
        ? ButtonWrapper(
            onTap: () async {
              //
              if (mePlaying) {
                // here i am playing and i want to pause
                if (Platform.isAndroid) {
                  var mpProviderFalseAndroid = mediaPF(context);

                  await mpProviderFalseAndroid.stopAudioPlaying();
                } else {
                  var mpProviderFalseWindows = WindowSProviders.mpPF(context);

                  await mpProviderFalseWindows.pausePlaying();
                }
              } else {
                var sharedExpProvider = shareExpPF(context);
                String? connLink;
                // sharedExpProvider.viewedUserSessionId != null &&

                if (widget.network) {
                  if (shareExpPF(context).laptopExploring) {
                    connLink = connectLaptopPF(context)
                        .getPhoneConnLink(EndPoints.streamAudio);
                  } else {
                    var serverProvider = serverPF(context);
                    connLink = serverProvider
                            .peerModelWithSessionID(
                                sharedExpProvider.viewedUserSessionId!)
                            .connLink +
                        EndPoints.streamAudio;
                  }
                }

                // here i want to start over
                if (Platform.isAndroid) {
                  var mpProviderFalseAndroid = mediaPF(context);

                  await mpProviderFalseAndroid.setPlayingFile(
                    widget.network ? '$connLink' : widget.mediaPath,
                    widget.network,
                    widget.mediaPath,
                  );
                } else {
                  var mpProviderFalseWindows = WindowSProviders.mpPF(context);

                  await mpProviderFalseWindows.setPlayingFile(
                    widget.network ? '$connLink' : widget.mediaPath,
                    widget.network,
                    widget.mediaPath,
                  );
                }
              }
            },
            width: largeIconSize,
            height: largeIconSize,
            child: Image.asset(
              mePlaying
                  ? 'assets/icons/pause.png'
                  : 'assets/icons/play-audio.png',
              width: largeIconSize / 2,
              color: kInactiveColor,
            ),
          )
        : fileType == FileType.video
            ? ButtonWrapper(
                onTap: () async {
                  if (widget.network) {
                    showSnackBar(
                        context: context, message: '${"loading".i18n()}...');
                    String? connLink;
                    if (shareExpPF(context).laptopExploring) {
                      connLink = connectLaptopPF(context)
                          .getPhoneConnLink(EndPoints.streamVideo);
                    } else {
                      var sharedExpProvider = shareExpPF(context);
                      var serverProvider = serverPF(context);
                      connLink = serverProvider
                              .peerModelWithSessionID(
                                  sharedExpProvider.viewedUserSessionId!)
                              .connLink +
                          EndPoints.streamVideo;
                    }
                    if (Platform.isAndroid) {
                      var mpProviderFalseAndroid = mediaPF(context);

                      mpProviderFalseAndroid.playVideo(
                        connLink,
                        widget.network,
                        widget.mediaPath,
                      );
                      mpProviderFalseAndroid
                          .setBottomVideoControllersHidden(false);
                    } else {
                      var mpProviderFalseWindows =
                          WindowSProviders.mpPF(context);

                      mpProviderFalseWindows.playVideo(
                        connLink,
                        widget.network,
                        widget.mediaPath,
                      );
                      mpProviderFalseWindows
                          .setBottomVideoControllersHidden(false);
                    }
                  } else {
                    if (Platform.isAndroid) {
                      var mpProviderFalseAndroid = mediaPF(context);

                      mpProviderFalseAndroid.playVideo(
                          widget.mediaPath, widget.network);
                    } else {
                      var mpProviderFalseWindows =
                          WindowSProviders.mpPF(context);

                      mpProviderFalseWindows.playVideo(
                          widget.mediaPath, widget.network);
                    }
                  }
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
