// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/analyzing_code/storage_analyzer/extensions/file_size.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/screens/analyzer_screen/widgets/report_count_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AnalyzeReport extends StatefulWidget {
  const AnalyzeReport({
    Key? key,
  }) : super(key: key);

  @override
  State<AnalyzeReport> createState() => _AnalyzeReportState();
}

class _AnalyzeReportState extends State<AnalyzeReport> {
  int totalStorageSize = 0;
  int freeStorageSize = 0;
  int appsDataSize = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      var analyzerProvider =
          Provider.of<AnalyzerProvider>(context, listen: false);
      int totalSpace = await analyzerProvider.getTotalDiskSpace();
      int freeSpace = await analyzerProvider.getFreeDiskSpace();
      int appsSpace = await analyzerProvider
          .getAppsDiskSpace(analyzerProvider.reportInfo?.totalFilesSize ?? 0);
      if (mounted) {
        setState(() {
          totalStorageSize = totalSpace;
          freeStorageSize = freeSpace;
          appsDataSize = appsSpace;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var analyzerProvider = Provider.of<AnalyzerProvider>(context);

    return PaddingWrapper(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: kCardBackgroundColor,
          borderRadius: BorderRadius.circular(mediumBorderRadius),
        ),
        child: PaddingWrapper(
          padding: EdgeInsets.symmetric(horizontal: kHPad, vertical: kVPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/icons/report.png',
                    width: mediumIconSize,
                  ),
                  HSpace(factor: .5),
                  Text(
                    'Last Analyze Report',
                    style: h3TextStyle,
                  ),
                  Spacer(),
                  Text(
                    getLastAnalyzingData(
                        analyzerProvider.lastAnalyzingReportDate!),
                    style: h4TextStyleInactive,
                  ),
                ],
              ),
              VSpace(
                factor: .5,
              ),
              ReportCountItem(
                title: 'Total Storage Size ',
                count: totalStorageSize.toGB,
                trailing: ' GB',
              ),
              ReportCountItem(
                title: 'Free Storage Size ',
                count: freeStorageSize.toGB,
                trailing: ' GB',
              ),
              ReportCountItem(
                title: 'Total Files Size ',
                count: analyzerProvider.reportInfo?.totalFilesSize.toGB ?? 0,
                trailing: ' GB',
              ),
              ReportCountItem(
                title: 'Apps Data Size ',
                count: appsDataSize.toGB,
                trailing: ' GB',
              ),
              ReportCountItem(
                title: 'Total Folders Count  ',
                count: (analyzerProvider.reportInfo?.folderCount ?? 0) * 1,
              ),
              ReportCountItem(
                title: 'Total Files Count  ',
                count: (analyzerProvider.reportInfo?.filesCount ?? 0) * 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getLastAnalyzingData(DateTime lastDate) {
    DateTime now = DateTime.now();
    int diff = now.difference(lastDate).inMinutes;
    const int oneDayMinutes = 24 * 60;
    if (diff > oneDayMinutes) {
      //? this means it is lager than a day
      return DateFormat('yyyy-MM-dd').format(lastDate);
    } else {
      //? less than a day
      return DateFormat('hh:mm aa').format(lastDate);
    }
  }
}
