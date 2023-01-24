// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';

class ShareScreenTabButton extends StatelessWidget {
  final String title;
  final String iconName;
  final VoidCallback onTap;
  final bool active;

  const ShareScreenTabButton({
    Key? key,
    required this.title,
    required this.iconName,
    required this.onTap,
    this.active = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      borderRadius: 0,
      padding: EdgeInsets.symmetric(
        horizontal: kHPad / 2,
        vertical: kVPad / 2,
      ),
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            'assets/icons/$iconName.png',
            width: mediumIconSize,
            color: active ? kMainIconColor : kMainIconColor.withOpacity(.4),
          ),
          Text(
            title,
            style: h4TextStyleInactive.copyWith(
                color:
                    active ? kMainIconColor : kMainIconColor.withOpacity(.4)),
          ),
        ],
      ),
    );
  }
}
