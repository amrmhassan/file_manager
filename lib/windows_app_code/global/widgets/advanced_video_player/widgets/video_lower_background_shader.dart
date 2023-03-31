import 'package:flutter/material.dart';
import 'package:explorer/helpers/responsive.dart';

class VideoLowerBackgroundShader extends StatelessWidget {
  final bool reverse;
  const VideoLowerBackgroundShader({
    super.key,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Responsive.getHeight(context) / 4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: reverse
              ? [
                  Colors.transparent,
                  Colors.black.withOpacity(.4),
                ]
              : [
                  Colors.black.withOpacity(.4),
                  Colors.transparent,
                ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    );
  }
}
