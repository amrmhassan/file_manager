// ignore_for_file: prefer_const_constructors

import 'package:explorer/windows_app_code/utils/windows_provider_calls.dart';
import 'package:flutter/material.dart';

import 'normal_media_player_windows.dart';

class MediaControllersWindows extends StatelessWidget {
  const MediaControllersWindows({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mpProvider = WindowSProviders.mpP(context);

    return mpProvider.audioPlaying && !mpProvider.playerHidden
        ? NormalMediaPlayerWindows()
        : SizedBox();
  }
}
