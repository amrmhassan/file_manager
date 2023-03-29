// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:flutter/material.dart';

class BeaconServerTitle extends StatelessWidget {
  const BeaconServerTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HSpace(factor: .8),
        Container(
          alignment: Alignment.centerLeft,
          height: largeIconSize,
          child: Text(
            'Hosting Devices',
            style: h4TextStyleInactive,
          ),
        ),
        Spacer(),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.replay_outlined,
            color: kMainIconColor,
          ),
        ),
        HSpace(),
      ],
    );
  }
}
