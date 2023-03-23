// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/custom_app_drawer/widgets/app_drawer_item.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/share_settings_screen/widgets/device_id_viewer.dart';
import 'package:explorer/screens/share_settings_screen/widgets/my_image_settings.dart';
import 'package:explorer/screens/share_settings_screen/widgets/my_name_with_edit_widget.dart';
import 'package:explorer/screens/share_settings_screen/widgets/pick_icon_button.dart';
import 'package:explorer/screens/white_block_list_screen/white_block_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class ShareSettingsScreen extends StatelessWidget {
  static const String routeName = '/ShareSettingsScreen';
  const ShareSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'share-settings'.i18n(),
              style: h3TextStyle,
            ),
          ),
          VSpace(),
          MyImageSettings(),
          VSpace(),
          PickMyIconButton(),
          VSpace(),
          MyNameWithEditWidget(),
          VSpace(factor: .5),
          DeviceIDViewer(),
          // AppDrawerItem(
          //   title: 'Devices White List',
          //   onTap: () {},
          // ),
          ListTile(
            leading: Image.asset(
              'assets/icons/friends.png',
              width: largeIconSize / 1.3,
              color: kGreenColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, WhiteBlockListScreen.routeName,
                  arguments: true);
            },
            contentPadding: EdgeInsets.symmetric(horizontal: kHPad),
            trailing: Text(
              'white-list'.i18n(),
              style: h4TextStyle,
            ),
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/blocked.png',
              width: largeIconSize / 1.3,
              color: kDangerColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, WhiteBlockListScreen.routeName,
                  arguments: false);
            },
            contentPadding: EdgeInsets.symmetric(horizontal: kHPad),
            trailing: Text(
              'blocked-list'.i18n(),
              style: h4TextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
