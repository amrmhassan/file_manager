// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/providers/util/analyzer_provider.dart';
import 'package:explorer/providers/recent_provider.dart';
import 'package:explorer/screens/home_screen/widgets/app_bar_icon_button.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RescanButton extends StatelessWidget {
  const RescanButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isWindows
        ? SizedBox()
        : AppBarIconButton(
            onTap: () {
              showSnackBar(context: context, message: 'Rescanning');
              var recentProvider =
                  Provider.of<RecentProvider>(context, listen: false);
              Provider.of<AnalyzerProvider>(context, listen: false)
                  .clearAllData();
              Provider.of<AnalyzerProvider>(context, listen: false)
                  .handleAnalyzeEvent(recentProvider);
            },
            iconName: 'reload',
          );
  }
}
