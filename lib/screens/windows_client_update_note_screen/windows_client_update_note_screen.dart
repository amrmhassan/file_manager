// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/recent_screen/recent_screen.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WindowsUpdateNoteScreen extends StatelessWidget {
  static const String routeName = '/WindowsUpdateNoteScreen';
  const WindowsUpdateNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/warning.png'),
          VSpace(),
          Text(
            'You must update windows client first manually before using it',
            style: h1TextStyle,
            textAlign: TextAlign.center,
          ),
          VSpace(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  launchUrlString(
                    laptopClientDownloadLink,
                    mode: LaunchMode.externalApplication,
                  );
                  handleConnectToLaptopButton(context, true);
                },
                child: Text(
                  'Download',
                ),
              ),
              HSpace(),
              ElevatedButton(
                onPressed: () {
                  copyToClipboard(
                    context,
                    laptopClientDownloadLink,
                  );
                  handleConnectToLaptopButton(context, true);
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
    );
  }
}
