// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/screens/home_screen/widgets/custom_check_box.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';

class AskForShareSpaceModal extends StatefulWidget {
  const AskForShareSpaceModal({
    super.key,
    required this.userName,
  });

  final String userName;

  @override
  State<AskForShareSpaceModal> createState() => _AskForShareSpaceModalState();
}

class _AskForShareSpaceModalState extends State<AskForShareSpaceModal> {
  bool remember = true;
  @override
  Widget build(BuildContext context) {
    return DoubleButtonsModal(
      onOk: () {
        showSnackBar(
          context: context,
          message: 'Blocked considering remember $remember',
          snackBarType: SnackBarType.error,
        );
        Navigator.pop(context, false);
      },
      onCancel: () {
        showSnackBar(
            context: context,
            message: 'Allowed considering remember $remember');
        Navigator.pop(context, true);
      },
      autoPop: false,
      okText: 'Block',
      cancelColor: kBlueColor,
      cancelText: 'Allow',
      title: 'Share Space Request',
      subTitle: '${widget.userName} want\'s to access your share space',
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
                  'Remember me',
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
