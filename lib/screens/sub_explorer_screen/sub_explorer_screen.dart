import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:flutter/material.dart';

class SubExplorerScreen extends StatelessWidget {
  static const String routeName = '/SubExplorerScreen';
  const SubExplorerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
        backgroundColor: kBackgroundColor,
        child: Column(
          children: [
            CustomAppBar(
              title: Text(
                'Item Viewer',
                style: h2TextStyle.copyWith(
                  color: kActiveTextColor,
                ),
              ),
            ),
          ],
        ));
  }
}
