// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediaControllers extends StatelessWidget {
  const MediaControllers({
    Key? key,
  }) : super(key: key);

  String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours}h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}m');
    }
    tokens.add('${seconds}s');

    return tokens.join(':');
  }

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);

    return
        //  mpProvider.playing
        //     ?
        Container(
      color: kCardBackgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: kHPad / 2,
        vertical: kVPad / 2,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                formatDuration(
                    mpProvider.currentDuration ?? Duration(seconds: 30)),
                style: h4TextStyleInactive,
              ),
              Expanded(
                child: Slider(
                  onChanged: (double value) {
                    mpProvider.seekTo(value.toInt());
                  },
                  value: (mpProvider.currentDuration?.inMilliseconds ?? 0) * 1,
                  min: 0,
                  max: (mpProvider.fullSongDuration?.inMilliseconds ?? 100000) *
                      1,
                ),
              ),
              Text(
                formatDuration(
                    mpProvider.fullSongDuration ?? Duration(seconds: 200)),
                style: h4TextStyleInactive,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWrapper(
                width: largeIconSize,
                height: largeIconSize,
                onTap: () {
                  mpProvider.backward10();
                },
                child: Image.asset(
                  'assets/icons/back_ten.png',
                  color: kMainIconColor,
                  width: largeIconSize / 2,
                ),
              ),
              ButtonWrapper(
                width: largeIconSize,
                height: largeIconSize,
                onTap: () {
                  mpProvider.pausePlaying();
                },
                child: Image.asset(
                  'assets/icons/pause.png',
                  color: kMainIconColor,
                  width: largeIconSize / 2,
                ),
              ),
              ButtonWrapper(
                width: largeIconSize,
                height: largeIconSize,
                onTap: () {
                  mpProvider.forward10();
                },
                child: Image.asset(
                  'assets/icons/ten.png',
                  color: kMainIconColor,
                  width: largeIconSize / 2,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        // : SizedBox()
        ;
  }
}
