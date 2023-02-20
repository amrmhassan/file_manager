// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/screens/share_screen/widgets/peer_info_item.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeerInfoModal extends StatelessWidget {
  const PeerInfoModal({
    Key? key,
    required this.peerModel,
  }) : super(key: key);

  final PeerModel peerModel;

  @override
  Widget build(BuildContext context) {
    var serverProvider = serverP(context);
    var shareProvider = shareP(context);
    return ModalWrapper(
      padding: EdgeInsets.symmetric(horizontal: kHPad, vertical: kVPad / 2),
      showTopLine: false,
      color: kCardBackgroundColor,
      child: Column(
        children: [
          PeerInfoItem(
            title: 'Type:',
            value: peerModel.memberType.name,
          ),
          PeerInfoItem(
            title: 'Peer Name:',
            value: peerModel.name,
          ),
          PeerInfoItem(
            title: 'Joined At:',
            value: DateFormat('yy-MM-dd hh:mm aa').format(peerModel.joinedAt),
          ),
          if (serverProvider.myType == MemberType.host &&
              peerModel.deviceID != shareProvider.myDeviceId)
            Column(
              children: [
                VSpace(),
                ButtonWrapper(
                    padding: EdgeInsets.symmetric(
                      horizontal: kHPad,
                      vertical: kVPad / 2,
                    ),
                    onTap: () {
                      serverPF(context).kickOutPeer(peerModel.ip, context);
                      Navigator.pop(context);
                    },
                    backgroundColor: kDangerColor,
                    child: Text(
                      'Kick Out',
                      style: h4TextStyle,
                    )),
              ],
            ),
          // PeerInfoItem(
          //   title: 'Device ID:',
          //   value: peerModel.deviceID,
          // ),
          // PeerInfoItem(
          //   title: 'Session ID:',
          //   value: peerModel.sessionID,
          // ),
        ],
      ),
    );
  }
}
