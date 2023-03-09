// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/screens/recent_screen/recent_screen.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ConnLaptopComingSoon extends StatelessWidget {
  static const String routeName = '/ConnLaptopComingSoon';
  const ConnLaptopComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    bool firstTime =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;
    print(firstTime);
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: SizedBox(
        height: Responsive.getHeight(context),
        child: Column(
          children: [
            SizedBox(width: double.infinity),
            CustomAppBar(
              title: Text(
                'Laptop (Windows)',
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
                'Now you can control your windows storage from your phone and vice versa',
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
                      'First, you need to download windows client and install it on your windows device',
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
                      'https://firebasestorage.googleapis.com/v0/b/advanced-file-manager-8b7ab.appspot.com/o/laptop%2Fwindows_client.exe?alt=media&token=516c4906-ae51-4776-a2df-0e2570be1af4',
                      mode: LaunchMode.externalApplication,
                    );
                    if (firstTime) {
                      handleConnectToLaptopButton(context, true);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Download',
                  ),
                ),
                HSpace(),
                ElevatedButton(
                  onPressed: () {
                    copyToClipboard(context,
                        'https://firebasestorage.googleapis.com/v0/b/advanced-file-manager-8b7ab.appspot.com/o/laptop%2Fwindows_client.exe?alt=media&token=516c4906-ae51-4776-a2df-0e2570be1af4');
                    if (firstTime) {
                      handleConnectToLaptopButton(context, true);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Copy Link',
                  ),
                ),
              ],
            ),
            VSpace(factor: .1),
            Text(
              '40 MB',
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
