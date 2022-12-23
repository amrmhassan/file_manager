// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VolumeViewer extends StatelessWidget {
  const VolumeViewer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);

    return mpProvider.volumeTouched
        ? Container(
            padding: EdgeInsets.all(largePadding),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.6),
              borderRadius: BorderRadius.circular(mediumBorderRadius),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/volume.png',
                  color: Colors.white.withOpacity(.8),
                  width: largeIconSize,
                ),
                VSpace(factor: .5),
                Text(
                  ((mpProvider.deviceVolume) * 100).ceil().toString(),
                  style: h2TextStyle.copyWith(height: 1, color: Colors.white),
                )
              ],
            ),
          )
        : SizedBox();
  }
}
