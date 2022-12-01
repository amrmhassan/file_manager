// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:flutter/material.dart';

class WhatsAppFolderCard extends StatelessWidget {
  final String? iconName;
  final String title;
  final VoidCallback onTap;

  const WhatsAppFolderCard({
    Key? key,
    this.iconName,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      onTap: onTap,
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(mediumBorderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (iconName != null)
            Image.asset(
              'assets/icons/whatsapp/w-$iconName.png',
              width: largeIconSize * 2,
            ),
          VSpace(factor: .5),
          Text(
            title,
            style: h3LiteTextStyle.copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }
}
