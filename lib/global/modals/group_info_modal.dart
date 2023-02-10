// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class GroupInfoModal extends StatelessWidget {
  const GroupInfoModal({
    super.key,
    required this.serverProvider,
    required this.onLeaveGroup,
  });

  final ServerProvider serverProvider;
  final VoidCallback onLeaveGroup;

  @override
  Widget build(BuildContext context) {
    var shareProvider = shareP(context);
    return ModalWrapper(
        bottomPaddingFactor: .8,
        color: kBackgroundColor,
        showTopLine: false,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Your Name',
                  style: h4TextStyle,
                ),
                HSpace(factor: .2),
                Expanded(
                  child: Text(
                    shareProvider.myName,
                    style: h5LiteTextStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Connected Devices',
                  style: h4TextStyle,
                ),
                HSpace(factor: .2),
                Expanded(
                  child: Text(
                    (serverProvider.peers.length - 1).toString(),
                    style: h5LiteTextStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Member Type',
                  style: h4TextStyle,
                ),
                HSpace(factor: .2),
                Expanded(
                  child: Text(
                    capitalizeWord(serverProvider.myType.name),
                    style: h5LiteTextStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Your session ID',
                  style: h4TextStyle,
                ),
                HSpace(factor: .2),
                Expanded(
                  child: Text(
                    serverProvider.me(shareProvider).sessionID,
                    style: h5LiteTextStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Your Device ID',
                  style: h4TextStyle,
                ),
                HSpace(factor: .2),
                Expanded(
                  child: Text(
                    shareProvider.myDeviceId,
                    style: h5LiteTextStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            VSpace(),
            ButtonWrapper(
              padding: EdgeInsets.symmetric(
                horizontal: kHPad,
                vertical: kVPad / 2,
              ),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => DoubleButtonsModal(
                    onOk: () {
                      onLeaveGroup();
                    },
                    okText: serverProvider.myType == MemberType.host
                        ? 'Close'
                        : 'Leave',
                    title: 'Are you sure?',
                    subTitle:
                        'closing the group will cut any downloads or streams',
                  ),
                );
              },
              backgroundColor: kDangerColor,
              child: Text(
                serverProvider.myType == MemberType.host
                    ? 'Close Group'
                    : 'Leave Group',
                style: h4TextStyle,
              ),
            ),
          ],
        ));
  }
}
