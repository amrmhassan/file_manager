// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/laptop_messages_screen/laptop_messages_screen.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class FullTextViewerScreen extends StatelessWidget {
  static const String routeName = '/FullTextViewerScreen';
  const FullTextViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String text = ModalRoute.of(context)!.settings.arguments as String;
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'text-viewer'.i18n(),
              style: h2TextStyle,
            ),
            rightIcon: Row(
              children: [
                CopyButton(text: text),
                HSpace(
                  factor: .3,
                ),
              ],
            ),
          ),
          VSpace(),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    HSpace(),
                    SelectableText(
                      text,
                      style: h4TextStyleInactive,
                      // softWrap: false,
                    ),
                    HSpace(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
