// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/recent_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyzingStarter extends StatelessWidget {
  const AnalyzingStarter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var analyzerProvider = Provider.of<AnalyzerProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
        ),
        Column(
          children: [
            if (analyzerProvider.loading)
              Column(
                children: [
                  VSpace(),
                  CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                    backgroundColor: kBlueColor,
                  ),
                  VSpace(factor: .5),
                  Text(
                    analyzerProvider.currentAnalyzedFolder,
                    style: h4TextStyleInactive,
                  ),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!analyzerProvider.loading)
                  ButtonWrapper(
                    padding: EdgeInsets.symmetric(
                        horizontal: kHPad / 2, vertical: kVPad / 3),
                    onTap: () {
                      var recentProvider =
                          Provider.of<RecentProvider>(context, listen: false);
                      Provider.of<AnalyzerProvider>(context, listen: false)
                          .handleAnalyzeEvent(recentProvider);
                    },
                    border: Border.all(color: Colors.white.withOpacity(.5)),
                    borderRadius: 1000,
                    child: Text(
                      'Start Analyze',
                      style: h4TextStyleInactive.copyWith(color: Colors.white),
                    ),
                  ),
              ],
            ),
            VSpace(),
            if (!analyzerProvider.loading)
              Text(
                'You should analyze storage first.',
                style: h4TextStyleInactive,
              ),
          ],
        ),
      ],
    );
  }
}
