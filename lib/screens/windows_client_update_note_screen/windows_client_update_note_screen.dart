// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/recent_screen/recent_screen.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
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
            'windows-update-note'.i18n(),
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
                  handleConnectToLaptopButton(context, true);
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
    );
  }
}
