// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/single_user_permissions_screen/widgets/user_permission_row.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class SingleUserPermissionsScreen extends StatefulWidget {
  static const String routeName = '/SingleUserPermissionsScreen';
  const SingleUserPermissionsScreen({super.key});

  @override
  State<SingleUserPermissionsScreen> createState() =>
      _SingleUserPermissionsScreenState();
}

class _SingleUserPermissionsScreenState
    extends State<SingleUserPermissionsScreen> {
  @override
  Widget build(BuildContext context) {
    String userID = ModalRoute.of(context)!.settings.arguments as String;
    var permissionsProvider = permissionsP(context);
    var peerPermissionModel =
        permissionsProvider.peerPermissionsModelFromId(userID);

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              '${peerPermissionModel.peerName} Permissions',
              style: h3TextStyle,
            ),
          ),
          VSpace(),
          ...peerPermissionModel.userPermissions
              .map(
                (permissionModel) => UserPermissionRow(
                  peerPermissionModel: peerPermissionModel,
                  permissionModel: permissionModel,
                ),
              )
              .toList()
        ],
      ),
    );
  }
}
