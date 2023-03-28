// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/peer_permissions_model.dart';
import 'package:explorer/screens/home_screen/widgets/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:explorer/utils/providers_calls_utils.dart';

class AskPermissionModal extends StatefulWidget {
  const AskPermissionModal({
    super.key,
    required this.userName,
    required this.deviceID,
    required this.permissionName,
  });

  final String userName;
  final String deviceID;
  final PermissionName permissionName;

  @override
  State<AskPermissionModal> createState() => _AskPermissionModalState();
}

class _AskPermissionModalState extends State<AskPermissionModal> {
  bool remember = false;
  String get permissionMsg => PermissionsNamesUtils.getPermissionNameReadable(
        widget.permissionName,
        widget.userName,
      );

  String get permissionTitle =>
      PermissionsNamesUtils.getPermissionTitle(widget.permissionName);

  @override
  void initState() {
    //? here is the default remember option some non sensitive permissions names
    remember = widget.permissionName == PermissionName.shareSpace ||
        widget.permissionName == PermissionName.sendFile ||
        widget.permissionName == PermissionName.sendText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var permissionProvider = permissionsPF(context);

    return DoubleButtonsModal(
      onOk: () async {
        //? this is block considering remember
        if (remember) {
          // notify the provider to save the permission status for that user
          permissionProvider.editPeerPermission(
            widget.deviceID,
            permissionName: widget.permissionName,
            status: PermissionStatus.blocked,
            peerName: widget.userName,
          );
        }

        Navigator.pop(context, false);
      },
      onCancel: () async {
        //? this is allow considering remember
        if (remember) {
          // notify the provider to save the permission status for that user
          permissionProvider.editPeerPermission(
            widget.deviceID,
            permissionName: widget.permissionName,
            status: PermissionStatus.allowed,
            peerName: widget.userName,
          );
        }

        Navigator.pop(context, true);
      },
      autoPop: false,
      okText: 'block'.i18n(),
      cancelColor: kBlueColor,
      cancelText: 'allow'.i18n(),
      title: permissionTitle,
      subTitle: permissionMsg,
      reverseButtonsOrder: true,
      extra: GestureDetector(
        onTap: () {
          setState(() {
            remember = !remember;
          });
        },
        child: Column(
          children: [
            VSpace(factor: .6),
            Row(
              children: [
                CustomCheckBox(
                  checked: remember,
                ),
                HSpace(factor: .4),
                Text(
                  'remember-for-later'.i18n(),
                  style: h4TextStyleInactive,
                ),
              ],
            ),
            VSpace(),
          ],
        ),
      ),
    );
  }
}
