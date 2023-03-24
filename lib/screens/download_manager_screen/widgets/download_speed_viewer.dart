// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class DownloadSpeedViewer extends StatelessWidget {
  const DownloadSpeedViewer({
    super.key,
    required this.downloadSpeed,
  });

  final double downloadSpeed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kCardBackgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: kHPad,
        vertical: kVPad / 2,
      ),
      child: Row(
        children: [
          Text(
            'speed'.i18n(),
            style: h3InactiveTextStyle,
          ),
          Spacer(),
          Text(
            '${downloadSpeed.toStringAsFixed(2)} ${"mb-s".i18n()}',
            style: h4TextStyleInactive,
          ),
        ],
      ),
    );
  }
}
