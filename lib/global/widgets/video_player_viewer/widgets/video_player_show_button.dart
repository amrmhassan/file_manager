// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:provider/provider.dart';

class VideoPlayerShowButton extends StatelessWidget {
  const VideoPlayerShowButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);

    return mpProvider.videoPlayerController != null && mpProvider.videoHidden
        ? FadeInUp(
            preferences: AnimationPreferences(
              duration: Duration(milliseconds: 200),
            ),
            child: ButtonWrapper(
              onTap: () {
                mpPF(context).toggleHideVideo();
                mpPF(context).resumeVideo();
              },
              width: largeIconSize * 1.3,
              height: largeIconSize * 1.3,
              padding: EdgeInsets.all(largePadding),
              decoration: BoxDecoration(
                color: kCardBackgroundColor,
                border: Border.all(color: kInverseColor.withOpacity(.5)),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(mediumBorderRadius),
                  topLeft: Radius.circular(mediumBorderRadius),
                ),
              ),
              child: Image.asset(
                'assets/icons/play.png',
                color: kMainIconColor,
              ),
            ),
          )
        : SizedBox();
  }
}
