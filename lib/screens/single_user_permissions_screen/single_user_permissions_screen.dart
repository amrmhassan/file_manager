// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/peer_permissions_model.dart';
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
              .toList(),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: kHPad,
              vertical: kVPad,
            ),
            child: Row(
              children: [
                ButtonWrapper(
                  onTap: () {
                    permissionsPF(context).allowAllForAUser(
                      peerPermissionModel.peerDeviceID,
                      peerPermissionModel.peerName,
                    );
                  },
                  minimumSpace: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: kHPad / 2,
                    vertical: kVPad / 4,
                  ),
                  backgroundColor: kGreenColor,
                  child: Text('Allow All'),
                ),
                Spacer(),
                ButtonWrapper(
                  onTap: () {
                    permissionsPF(context).askAllForAUser(
                      peerPermissionModel.peerDeviceID,
                      peerPermissionModel.peerName,
                    );
                  },
                  minimumSpace: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: kHPad / 2,
                    vertical: kVPad / 4,
                  ),
                  backgroundColor:
                      PermissionsNamesUtils.getPermissionStatusColor(
                    PermissionStatus.ask,
                  ),
                  child: Text('Ask All'),
                ),
                Spacer(),
                ButtonWrapper(
                  onTap: () {
                    permissionsPF(context).blockAllForAUser(
                      peerPermissionModel.peerDeviceID,
                      peerPermissionModel.peerName,
                    );
                  },
                  minimumSpace: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: kHPad / 2,
                    vertical: kVPad / 4,
                  ),
                  backgroundColor: kDangerColor,
                  child: Text('Block All'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
