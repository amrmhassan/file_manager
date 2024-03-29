// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/share_settings_screen/widgets/device_id_viewer.dart';
import 'package:explorer/screens/share_settings_screen/widgets/my_image_settings.dart';
import 'package:explorer/screens/share_settings_screen/widgets/my_name_with_edit_widget.dart';
import 'package:explorer/screens/share_settings_screen/widgets/pick_icon_button.dart';
import 'package:explorer/screens/white_block_list_screen/white_block_list_screen.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
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
          VSpace(),
          UsersPermissionsButton(),
          VSpace(factor: .5),
          MyNameWithEditWidget(),
          VSpace(factor: .5),
          DeviceIDViewer(),
          VSpace(),
          // AppDrawerItem(
          //   title: 'Devices White List',
          //   onTap: () {},
          // ),
          // ListTile(
          //   leading: Image.asset(
          //     'assets/icons/friends.png',
          //     width: largeIconSize / 1.3,
          //     color: kGreenColor,
          //   ),
          //   onTap: () {
          //     Navigator.pushNamed(context, WhiteBlockListScreen.routeName,
          //         arguments: true);
          //   },
          //   contentPadding: EdgeInsets.symmetric(horizontal: kHPad),
          //   trailing: Text(
          //     'white-list'.i18n(),
          //     style: h4TextStyle,
          //   ),
          // ),
          // ListTile(
          //   leading: Image.asset(
          //     'assets/icons/blocked.png',
          //     width: largeIconSize / 1.3,
          //     color: kDangerColor,
          //   ),
          //   onTap: () {
          //     Navigator.pushNamed(context, WhiteBlockListScreen.routeName,
          //         arguments: false);
          //   },
          //   contentPadding: EdgeInsets.symmetric(horizontal: kHPad),
          //   trailing: Text(
          //     'blocked-list'.i18n(),
          //     style: h4TextStyle,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class UsersPermissionsButton extends StatelessWidget {
  const UsersPermissionsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var permissionProvider = permissionsP(context);
    return ButtonWrapper(
      borderRadius: 0,
      padding: EdgeInsets.symmetric(
        horizontal: kHPad,
        vertical: kVPad / 2,
      ),
      alignment: Alignment.centerLeft,
      onTap: () {
        Navigator.pushNamed(context, UsersPermissionScreen.routeName);
      },
      child: Row(
        children: [
          Text(
            'known-users'.i18n(),
            style: h4TextStyle,
          ),
          Spacer(),
          Text(
            '${permissionProvider.peersPermissions.length.toString()} ${"users".i18n()}',
            style: h4TextStyleInactive,
          ),
        ],
      ),
    );
  }
}
