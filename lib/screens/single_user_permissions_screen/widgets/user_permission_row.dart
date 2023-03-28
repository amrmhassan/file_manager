// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/models/peer_permissions_model.dart';
import 'package:explorer/screens/single_user_permissions_screen/widgets/permission_status_button.dart';
import 'package:flutter/material.dart';

class UserPermissionRow extends StatelessWidget {
  final PeerPermissionsModel peerPermissionModel;
  final PermissionModel permissionModel;

  const UserPermissionRow({
    super.key,
    required this.peerPermissionModel,
    required this.permissionModel,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
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
              border: Border.all(
                width: 1,
                color: kLightCardBackgroundColor,
              ),
            ),
            child: Row(
              children: PermissionStatus.values
                  .map(
                    (permissionStatus) => PermissionStatusButton(
                      peerPermissionModel: peerPermissionModel,
                      permissionModel: permissionModel,
                      permissionStatus: permissionStatus,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
