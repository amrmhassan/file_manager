import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:flutter/material.dart';

class DownloadingOverLay extends StatelessWidget {
  const DownloadingOverLay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: mediumIconSize / 1.4,
      height: mediumIconSize / 1.4,
      decoration: BoxDecoration(
        color: kBlueColor,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Text(
        '2',
        style: h4TextStyle.copyWith(height: 1),
        textAlign: TextAlign.center,
      ),
    );
  }
}
