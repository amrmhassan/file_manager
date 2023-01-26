// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:flutter/material.dart';

class PeerIcon extends StatelessWidget {
  const PeerIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(largePadding),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: Colors.white.withOpacity(.6),
      ),
      child: Image.asset(
        'assets/icons/user.png',
        color: kCardBackgroundColor.withOpacity(.5),
      ),
    );
  }
}
