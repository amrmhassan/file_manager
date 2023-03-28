// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/models/peer_permissions_model.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class PermissionStatusButton extends StatelessWidget {
  const PermissionStatusButton({
    super.key,
    required this.peerPermissionModel,
    required this.permissionModel,
    required this.permissionStatus,
  });

  final PeerPermissionsModel peerPermissionModel;
  final PermissionModel permissionModel;
  final PermissionStatus permissionStatus;

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      onTap: () {
        permissionsPF(context).editPeerPermission(
          peerPermissionModel.peerDeviceID,
          permissionName: permissionModel.permissionName,
          status: permissionStatus,
          peerName: peerPermissionModel.peerName,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            mediumBorderRadius,
          ),
          color: permissionModel.permissionStatus == permissionStatus
              ? PermissionsNamesUtils.getPermissionStatusColor(
                  permissionStatus,
                )
              : null,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: kHPad / 4,
          vertical: kVPad / 6,
        ),
        child: Text(
          PermissionsNamesUtils.getPermissionStatusTitle(
            permissionStatus,
          ),
        ),
      ),
    );
  }
}
