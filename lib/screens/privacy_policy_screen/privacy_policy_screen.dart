// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'html_content.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const String routeName = '/PrivacyPolicyScreen';
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            VSpace(),
            Html(data: htmlContent),
          ],
        ),
      ),
    );
  }
}
