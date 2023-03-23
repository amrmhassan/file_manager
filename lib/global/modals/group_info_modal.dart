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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

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
                  'your-name'.i18n(),
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
                  'connected-devices'.i18n(),
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
                  'member-type'.i18n(),
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
                  'your-ip'.i18n(),
                  style: h4TextStyle,
                ),
                HSpace(factor: .2),
                Expanded(
                  child: Text(
                    serverProvider.myIp!,
                    style: h5LiteTextStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            if (kDebugMode)
              Row(
                children: [
                  Text(
                    'your-port'.i18n(),
                    style: h4TextStyle,
                  ),
                  HSpace(factor: .2),
                  Expanded(
                    child: Text(
                      serverProvider.myPort.toString(),
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
                        ? 'close'.i18n()
                        : 'leave'.i18n(),
                    title: 'are-you-sure'.i18n(),
                    subTitle: 'are-you-sure-note'.i18n(),
                  ),
                );
              },
              backgroundColor: kDangerColor,
              child: Text(
                serverProvider.myType == MemberType.host
                    ? 'close-group'.i18n()
                    : 'leave-group'.i18n(),
                style: h4TextStyle,
              ),
            ),
          ],
        ));
  }
}
