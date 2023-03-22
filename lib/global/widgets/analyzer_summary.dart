// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyzerSummary extends StatelessWidget {
  const AnalyzerSummary({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var analyzerProvider = Provider.of<AnalyzerProvider>(context);
    return showAnalyzerStuff && kDebugMode
        ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kHPad / 3,
                  vertical: kVPad / 3,
                ),
                width: Responsive.getWidthPercentage(context, .5),
                color: Colors.white,
                child: Column(
                  children: [
                    SummaryItem(
                      title: 'Extensions',
                      value: (analyzerProvider.allExtensionInfo?.length)
                          .toString(),
                    ),
                    SummaryItem(
                      title: 'Folders',
                      value: (analyzerProvider.foldersInfo?.length).toString(),
                    ),
                    SummaryItem(
                      title: 'Files',
                      value: (analyzerProvider
                              .advancedStorageAnalyzer?.filesInfo.length)
                          .toString(),
                    ),
                  ],
                ),
              ),
            ],
          )
        : SizedBox();
  }
}

class SummaryItem extends StatelessWidget {
  final String title;
  final String value;

  const SummaryItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title : ',
          style: h4TextStyleInactive.copyWith(color: Colors.black),
        ),
        Text(
          value,
          style: h4TextStyleInactive.copyWith(color: Colors.black),
        ),
      ],
    );
  }
}
