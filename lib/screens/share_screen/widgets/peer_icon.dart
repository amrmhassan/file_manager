// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:flutter/material.dart';

class PeerIcon extends StatelessWidget {
  final bool large;

  const PeerIcon({
    Key? key,
    this.large = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(largePadding * 1.5),
      width: large ? largeIconSize * 3 : 60,
      height: large ? largeIconSize * 3 : 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: Colors.white.withOpacity(.2),
      ),
      child: Image.asset(
        'assets/icons/user.png',
        color: kCardBackgroundColor.withOpacity(1),
      ),
    );
  }
}
