// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/screens/recent_screen/widget/widgets/segment_section.dart';
import 'package:flutter/material.dart';

class SegmentsDrawer extends StatelessWidget {
  final List<SectionElement> sections;
  const SegmentsDrawer({
    Key? key,
    required this.sections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cumulative = 0;
    List<SectionElement> parsedSections = sections;
    parsedSections.sort(
      (a, b) => b.percent.compareTo(a.percent),
    );
    List<Widget> widgetSections = parsedSections.map((e) {
      SectionElement newSectionElement = SectionElement(
          color: e.color, percent: e.percent + cumulative, title: e.title);
      cumulative += e.percent;
      return SegmentSection(sectionElement: newSectionElement);
    }).toList();
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mediumBorderRadius),
      ),
      child: Stack(
        children: [
          SegmentSection(
            sectionElement: SectionElement(
              percent: 1,
              color: Colors.white,
              animate: false,
            ),
          ),
          ...widgetSections.reversed,
        ],
      ),
    );
  }
}
