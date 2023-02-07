// ignore_for_file: prefer_const_constructors

import 'package:explorer/global/widgets/advanced_video_player/widgets/left_fast_seeker.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:flutter/material.dart';

class BaseOverLay extends StatelessWidget {
  // this will be clicked when no other element is being clicked
  final VoidCallback toggleControllerOverLayViewed;
  const BaseOverLay({
    super.key,
    required this.toggleControllerOverLayViewed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: toggleControllerOverLayViewed,
              child: Opacity(
                opacity: 0,
                child: Container(
                  height: Responsive.getCleanHeight(context),
                  width: Responsive.getWidth(context),
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
        VideoFastSeeker(
          backward: true,
          toggleControllerOverLayViewed: toggleControllerOverLayViewed,
        ),
        VideoFastSeeker(
          backward: false,
          toggleControllerOverLayViewed: toggleControllerOverLayViewed,
        ),
      ],
    );
  }
}
