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
import 'package:explorer/screens/recent_screen/widget/widgets/segment_section.dart';
import 'package:explorer/screens/recent_screen/widget/widgets/segments_drawer.dart';
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

  Future<void> calcSections(List<ExtensionInfo>? extInfo) async {
    int imageSize = 0;
    int audioSize = 0;
    int videoSize = 0;
    int apkSize = 0;
    int docSize = 0;
    int unknownSize = 0;

    if (extInfo == null) return;
    var analyzerProvider =
        Provider.of<AnalyzerProvider>(context, listen: false);
    // int freeSize = await analyzerProvider.getFreeDiskSpace();
    int totalSize = await analyzerProvider.getTotalDiskSpace();
    int appDataSize = await analyzerProvider
        .getAppsDiskSpace(analyzerProvider.reportInfo?.totalFilesSize ?? 0);

    for (var ext in extInfo) {
      FileType fileType = getFileType(ext.ext);
      totalSize += ext.size;

      if (fileType == FileType.image) {
        imageSize += ext.size;
      } else if (fileType == FileType.audio) {
        audioSize += ext.size;
      } else if (fileType == FileType.video) {
        videoSize += ext.size;
      } else if (fileType == FileType.apk) {
        apkSize += ext.size;
      } else if (fileType == FileType.docs) {
        docSize += ext.size;
      } else if (fileType == FileType.unknown) {
        unknownSize += ext.size;
      }
    }
    SectionElement imageSection = SectionElement(
      color: kImagesColor,
      title: 'Images',
      percent: imageSize / totalSize,
    );
    SectionElement audioSection = SectionElement(
      color: kAudioColor,
      percent: audioSize / totalSize,
      title: 'Music',
    );
    SectionElement videoSection = SectionElement(
      color: kVideoColor,
      percent: videoSize / totalSize,
      title: 'Videos',
    );
    SectionElement apkSection = SectionElement(
      color: kAPKsColor,
      percent: apkSize / totalSize,
      title: 'APKs',
    );
    SectionElement docSection = SectionElement(
      color: kDocsColor,
      percent: docSize / totalSize,
      title: 'Docs',
    );

    SectionElement unknownSection = SectionElement(
      color: kUnknownColor,
      percent: unknownSize / totalSize,
      title: 'Unknown',
    );
    SectionElement appsSizeSection = SectionElement(
      color: kAppsColor,
      percent: appDataSize / totalSize,
      title: 'Apps Data',
    );

    setState(() {
      sections = [
        imageSection,
        audioSection,
        videoSection,
        apkSection,
        docSection,
        unknownSection,
        appsSizeSection,
      ];
      sections.sort(
        (a, b) => b.percent.compareTo(a.percent),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var analyzerProvider = Provider.of<AnalyzerProvider>(context);
    List<ExtensionInfo>? extInfo = analyzerProvider.allExtensionInfo;
    var biggest4Sections = [];
    if (sections.isEmpty) calcSections(extInfo);
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

class ItemTitle extends StatelessWidget {
  final String title;
  final Color color;

  const ItemTitle({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: smallIconSize / 2,
          height: smallIconSize / 2,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(500),
          ),
        ),
        HSpace(factor: .2),
        Text(
          title,
          style: h4TextStyleInactive.copyWith(height: 1),
        )
      ],
    );
  }
}
