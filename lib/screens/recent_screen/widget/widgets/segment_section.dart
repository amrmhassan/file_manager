// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/global_constants.dart';
import 'package:flutter/material.dart';

class SectionElement {
  final double percent;
  final Color color;
  final bool animate;
  final String? title;

  const SectionElement({
    required this.color,
    required this.percent,
    this.animate = true,
    this.title,
  });
}

class SegmentSection extends StatefulWidget {
  final SectionElement sectionElement;

  const SegmentSection({
    Key? key,
    required this.sectionElement,
  }) : super(key: key);

  @override
  State<SegmentSection> createState() => _SegmentSectionState();
}

class _SegmentSectionState extends State<SegmentSection> {
  double percent = 0;
  @override
  void initState() {
    if (!widget.sectionElement.animate) percent = widget.sectionElement.percent;
    Future.delayed(Duration.zero).then((value) {
      setState(() {
        percent = widget.sectionElement.percent;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedFractionallySizedBox(
      duration: segmentsDuration,
      curve: Curves.easeOut,
      widthFactor: percent,
      child: Container(
        width: double.infinity,
        height: 50,
        color: widget.sectionElement.color,
      ),
    );
  }
}
