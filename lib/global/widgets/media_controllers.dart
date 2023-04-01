// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/global/widgets/normal_media_player.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:explorer/windows_app_code/utils/windows_provider_calls.dart';
import 'package:flutter/material.dart';

class MediaControllers extends StatelessWidget {
  const MediaControllers({
    Key? key,
  }) : super(key: key);

  bool isShown(BuildContext context) {
    if (Platform.isAndroid) {
      var mpProvider = mpP(context);
      return !mpProvider.playerHidden;
    } else {
      var mpProvider = WindowSProviders.mpP(context);
      return !mpProvider.playerHidden;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isShown(context) ? NormalMediaPlayer() : SizedBox();
  }
}
