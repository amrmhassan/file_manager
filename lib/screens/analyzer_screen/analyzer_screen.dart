// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/screens/analyzer_screen/recents_widget/recents_widget.dart';
import 'package:explorer/screens/analyzer_screen/widgets/analyzing_report.dart';
import 'package:explorer/screens/analyzer_screen/widgets/analyzing_starter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyzerScreen extends StatefulWidget {
  const AnalyzerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AnalyzerScreen> createState() => _AnalyzerScreenState();
}

class _AnalyzerScreenState extends State<AnalyzerScreen> {
  @override
  Widget build(BuildContext context) {
    var analyzerProvider = Provider.of<AnalyzerProvider>(context);

    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Container(
          color: kBackgroundColor,
          child: analyzerProvider.lastAnalyzingReportDate != null
              ? AnalyzingReport()
              : AnalyzingStarter(),
        ),
        VSpace(),
        RecentsWidget(),
      ],
    );
  }
}
