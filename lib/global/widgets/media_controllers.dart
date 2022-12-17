// ignore_for_file: prefer_const_constructors

import 'package:explorer/global/widgets/normal_media_player.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediaControllers extends StatelessWidget {
  const MediaControllers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);

    return mpProvider.playing && !mpProvider.playerHidden
        ? NormalMediaPlayer()
        : SizedBox();
  }
}
