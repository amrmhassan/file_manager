// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:flutter/material.dart';

class BeaconServerScanBox extends StatelessWidget {
  const BeaconServerScanBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: largeIconSize,
      child: Row(
        children: [
          HSpace(factor: .8),
          Text(
            'Scanning...',
            style: h4TextStyleInactive,
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(mediumPadding),
            width: mediumIconSize,
            height: mediumIconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          HSpace(factor: .5),
        ],
      ),
    );
  }
}
