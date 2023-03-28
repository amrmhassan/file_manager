// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/peer_permissions_model.dart';
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
    var permissionsProvider = permissionsPF(context);
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
                (permissionModel) => ButtonWrapper(
                  borderRadius: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: kHPad * .8,
                    vertical: kVPad / 4,
                  ),
                  child: Row(
                    children: [
                      Text(
                        PermissionsNamesUtils.getPermissionTitleMin(
                            permissionModel.permissionName),
                      ),
                      Spacer(),
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            mediumBorderRadius,
                          ),
                        ),
                        child: Row(
                          children: PermissionStatus.values
                              .map(
                                (permissionStatus) => ButtonWrapper(
                                  onTap: () {
                                    permissionsPF(context).editPeerPermission(
                                      peerPermissionModel.peerDeviceID,
                                      permissionName:
                                          permissionModel.permissionName,
                                      status: permissionStatus,
                                      peerName: peerPermissionModel.peerName,
                                    );
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        mediumBorderRadius,
                                      ),
                                      color: permissionModel.permissionStatus ==
                                              permissionStatus
                                          ? PermissionsNamesUtils
                                              .getPermissionStatusColor(
                                              permissionStatus,
                                            )
                                          : null,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: kHPad / 4,
                                      vertical: kVPad / 6,
                                    ),
                                    child: Text(
                                      PermissionsNamesUtils
                                          .getPermissionStatusTitle(
                                        permissionStatus,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList()
        ],
      ),
    );
  }
}
