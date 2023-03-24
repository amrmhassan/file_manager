// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/home_screen/widgets/custom_check_box.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class AskForShareSpaceModal extends StatefulWidget {
  const AskForShareSpaceModal({
    super.key,
    required this.userName,
    required this.deviceID,
  });

  final String userName;
  final String deviceID;

  @override
  State<AskForShareSpaceModal> createState() => _AskForShareSpaceModalState();
}

class _AskForShareSpaceModalState extends State<AskForShareSpaceModal> {
  bool remember = true;
  @override
  Widget build(BuildContext context) {
    return DoubleButtonsModal(
      onOk: () async {
        await serverPF(context).blockDevice(widget.deviceID, remember);
        showSnackBar(
          context: context,
          message: 'block'.i18n(),
        );
        // this will tell the parent function that it is blocked
        Navigator.pop(context, false);
      },
      onCancel: () async {
        await serverPF(context).allowDevice(widget.deviceID, remember);
        showSnackBar(
          context: context,
          message: 'allow'.i18n(),
        );

        // this will tell the parent function that it is allowed
        Navigator.pop(context, true);
      },
      autoPop: false,
      okText: 'block'.i18n(),
      cancelColor: kBlueColor,
      cancelText: 'allow'.i18n(),
      title: 'share-space-request'.i18n(),
      subTitle: '${widget.userName} ${"wants-access-to-share-space".i18n()}',
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
