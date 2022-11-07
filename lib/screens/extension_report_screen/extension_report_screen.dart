// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/screens/scanning_storage_screen/widgets/analyze_entity_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExtensionReportScreen extends StatefulWidget {
  static const String routeName = '/extension-report-screen';
  const ExtensionReportScreen({super.key});

  @override
  State<ExtensionReportScreen> createState() => _ExtensionReportScreenState();
}

class _ExtensionReportScreenState extends State<ExtensionReportScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var analyzeProvider = Provider.of<AnalyzerProvider>(context);
    var extFiles = analyzeProvider.getExtensionFiles(data['ext']);
    int extensionSize = data['size'];
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: extFiles
            .map(
              (e) => AnalyzeEntityItem(
                fileSystemEntity: e,
                parentSize: extensionSize,
              ),
            )
            .toList(),
      ),
    );
  }
}
