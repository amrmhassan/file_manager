// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/share_screen/widgets/peer_icon.dart';
import 'package:explorer/screens/share_settings_screen/widgets/my_name_with_edit_widget.dart';
import 'package:explorer/screens/share_settings_screen/widgets/pick_icon_button.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class ShareSettingsScreen extends StatelessWidget {
  static const String routeName = '/ShareSettingsScreen';
  const ShareSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var shareProvider = shareP(context);
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'Share Settings',
              style: h3TextStyle,
            ),
          ),
          VSpace(),
          PeerIcon(large: true),
          VSpace(),
          PickMyIconButton(),
          VSpace(),
          MyNameWithEditWidget(),
          VSpace(factor: .5),
          PaddingWrapper(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Device ID',
                  style: h4TextStyleInactive,
                ),
                GestureDetector(
                  onTap: () {
                    copyToClipboard(context, shareProvider.myDeviceId);
                  },
                  child: Text(
                    shareProvider.myDeviceId,
                    style: h5InactiveTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
