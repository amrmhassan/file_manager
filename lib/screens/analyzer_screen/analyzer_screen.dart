// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/screens/analyzer_screen/widgets/analyzing_report.dart';
import 'package:explorer/screens/analyzer_screen/widgets/analyzing_starter.dart';
import 'package:explorer/screens/home_screen/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyzerScreen extends StatefulWidget {
  static const String routeName = '/analyzer-screen';
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

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          HomeAppBar(
            activeScreenIndex: 0,
            setActiveScreen: (a) {},
            sizesExplorer: true,
          ),
          HLine(
            width: 1,
            color: Colors.white.withOpacity(.1),
          ),
          Container(
            color: kBackgroundColor,
            child: analyzerProvider.lastAnalyzingReportDate != null
                ? AnalyzingReport()
                : AnalyzingStarter(),
          ),
        ],
      ),
    );
  }
}
