import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/screens/analyzer_screen/analyzer_screen.dart';
import 'package:flutter/material.dart';

class StorageAnalyzerButton extends StatelessWidget {
  const StorageAnalyzerButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      borderRadius: 0,
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, AnalyzerScreen.routeName);
      },
      child: ListTile(
        leading: Image.asset(
          'assets/icons/analyze.png',
          width: mediumIconSize,
          color: kInactiveColor,
        ),
        title: Text(
          'Storage Analyzer',
          style: h4TextStyle.copyWith(color: kInactiveColor),
        ),
      ),
    );
  }
}
