// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ffi';

import 'package:explorer/analyzing_code/storage_analyzer/models/extension_info.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/main.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/screens/recent_screen/widget/item_title.dart';
import 'package:explorer/screens/recent_screen/widget/segment_section.dart';
import 'package:explorer/screens/recent_screen/widget/segments_drawer.dart';
import 'package:explorer/utils/screen_utils/recent_screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StorageSegments extends StatefulWidget {
  const StorageSegments({
    Key? key,
  }) : super(key: key);

  @override
  State<StorageSegments> createState() => _StorageSegmentsState();
}

class _StorageSegmentsState extends State<StorageSegments> {
  List<SectionElement> sections = [];

  @override
  Widget build(BuildContext context) {
    var analyzerProvider = Provider.of<AnalyzerProvider>(context);
    List<ExtensionInfo>? extInfo = analyzerProvider.allExtensionInfo;
    var biggest4Sections = [];
    if (sections.isEmpty) {
      calcSections(extInfo, (sec) {
        setState(() {
          sections = sec;
        });
      }, context);
    }

    if (sections.isNotEmpty) {
      biggest4Sections = sections.sublist(0, 4);
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: kHPad, vertical: kVPad / 2),
          child: SegmentsDrawer(
            sections: [...sections],
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: kHPad, vertical: kVPad / 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...biggest4Sections.map((e) => ItemTitle(
                    title: e.title ?? '',
                    color: e.color,
                  ))
            ],
          ),
        ),
        VSpace(),
      ],
    );
  }
}
