// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/screens/share_screen/widgets/share_controllers_buttons.dart';

import 'package:flutter/material.dart';

class ShadingBackground extends StatelessWidget {
  const ShadingBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      // mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  end: Alignment.topCenter,
                  begin: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                ).createShader(
                  Rect.fromLTRB(
                    0,
                    0,
                    rect.width,
                    rect.height,
                  ),
                );
              },
              blendMode: BlendMode.dstIn,
              child: Container(
                width: double.infinity,
                height: 100,
                color: kBackgroundColor,
              ),
            ),
            Container(
              width: double.infinity,
              height: 40,
              color: kBackgroundColor,
            ),
          ],
        ),
        Positioned(
          bottom: 30,
          child: ShareControllersButtons(),
        ),
      ],
    );
  }
}
