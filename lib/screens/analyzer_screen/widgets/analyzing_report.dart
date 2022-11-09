// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/analyzer_screen/widgets/analyze_report.dart';
import 'package:explorer/screens/analyzer_screen/widgets/analyzer_options_item.dart';
import 'package:explorer/screens/home_screen/home_screen.dart';
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
        AnalyzeReport(),
        VSpace(),
        AnalyzerOptionsItem(
          logoName: 'sizes_explorer',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  sizesExplorer: true,
                ),
              ),
            );
          },
          title: 'Sizes Explorer',
        ),
        VSpace(),
        AnalyzerOptionsItem(
          logoName: 'txt',
          onTap: () {},
          title: 'Extensions',
        ),
      ],
    );
  }
}
