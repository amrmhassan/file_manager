// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/screens/recent_screen/recent_screen.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ConnLaptopComingSoon extends StatelessWidget {
  static const String routeName = '/ConnLaptopComingSoon';
  const ConnLaptopComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    bool firstTime =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: SizedBox(
        height: Responsive.getHeight(context),
        child: Column(
          children: [
            SizedBox(width: double.infinity),
            CustomAppBar(
              title: Text(
                'laptop-windows'.i18n(),
                style: h2liteTextStyle,
              ),
            ),
            VSpace(factor: 2),
            Image.asset(
              'assets/icons/connection.png',
              width: largeIconSize * 4,
            ),
            VSpace(factor: 2),
            PaddingWrapper(
              child: Text(
                'laptop-windows-note-1'.i18n(),
                style: h4TextStyleInactive,
                textAlign: TextAlign.center,
              ),
            ),
            VSpace(),
            Spacer(),
            PaddingWrapper(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: double.infinity),
                    Text(
                      'laptop-windows-note-2'.i18n(),
                      style: h3TextStyle,
                      textAlign: TextAlign.center,
                    ),
                    VSpace(),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    launchUrlString(
                      laptopClientDownloadLink,
                      mode: LaunchMode.externalApplication,
                    );
                    if (firstTime) {
                      handleConnectToLaptopButton(context, true);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'download'.i18n(),
                  ),
                ),
                HSpace(),
                ElevatedButton(
                  onPressed: () {
                    copyToClipboard(
                      context,
                      laptopClientDownloadLink,
                    );
                    if (firstTime) {
                      handleConnectToLaptopButton(context, true);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'copy-link'.i18n(),
                  ),
                ),
              ],
            ),
            VSpace(factor: .1),
            Text(
              '70-mb'.i18n(),
              style: h3InactiveTextStyle,
              textAlign: TextAlign.center,
            ),
            VSpace(),
          ],
        ),
      ),
    );
  }
}
