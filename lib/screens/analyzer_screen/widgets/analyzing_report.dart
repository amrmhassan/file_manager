// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/analyzer_screen/widgets/analyze_report.dart';
import 'package:explorer/screens/analyzer_screen/widgets/analyzer_options_item.dart';
import 'package:explorer/screens/ext_report_screen/ext_report_screen.dart';
import 'package:explorer/screens/sizes_exp_screen/sizes_exp_screen.dart';
import 'package:flutter/material.dart';

class AnalyzingReport extends StatefulWidget {
  const AnalyzingReport({
    Key? key,
  }) : super(key: key);

  @override
  State<AnalyzingReport> createState() => _AnalyzingReportState();
}

class _AnalyzingReportState extends State<AnalyzingReport> {
  // this will handle show the report or not
  // bool showAnalyzeTotalinfo(BuildContext context) {
  //   var analyzerProvider =
  //       Provider.of<AnalyzerProvider>(context, listen: false);
  //   return analyzerProvider.advancedStorageAnalyzer == null &&
  //       analyzerProvider.lastAnalyzingReportDate != null;
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VSpace(),
        AnalyzerOptionsItem(
          logoName: 'sizes_explorer',
          onTap: () {
            Navigator.pushNamed(context, SizesExpScreen.routeName);
          },
          title: 'Sizes Explorer',
        ),
        VSpace(),
        AnalyzerOptionsItem(
          logoName: 'txt',
          onTap: () {
            Navigator.pushNamed(context, ExtReportScreen.routeName);
          },
          title: 'Extensions',
        ),
        VSpace(),
        AnalyzeReport(),
        VSpace(),
      ],
    );
  }
}
