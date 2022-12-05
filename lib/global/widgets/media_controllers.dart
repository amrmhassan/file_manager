// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
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

    return mpProvider.playing
        ? Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                color: kCardBackgroundColor,
                height: 50,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(mpProvider.fullSongDuration?.inSeconds)} Sec',
                      style: h2TextStyle.copyWith(
                        color: kInActiveTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                  HSpace(),
                ],
              ),
            ],
          )
        : SizedBox();
  }
}
