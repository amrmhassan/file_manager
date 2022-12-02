// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/recent_screen/widget/widgets/segment_section.dart';
import 'package:explorer/screens/recent_screen/widget/widgets/segments_drawer.dart';
import 'package:flutter/material.dart';

class StorageSegments extends StatelessWidget {
  const StorageSegments({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: kHPad, vertical: kVPad / 2),
          child: SegmentsDrawer(sections: [
            SectionElement(color: Colors.blue, percent: .4, title: 'Blue'),
            SectionElement(color: Colors.green, percent: .2, title: 'Green'),
            SectionElement(color: Colors.red, percent: .2, title: 'Red'),
            SectionElement(color: Colors.yellow, percent: .1, title: 'Yellow'),
          ]),
        ),
        VSpace(),
      ],
    );
  }
}
