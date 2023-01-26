import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/screens/share_screen/widgets/peer_info_item.dart';
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
    return ModalWrapper(
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
          PeerInfoItem(
            title: 'Device ID:',
            value: peerModel.deviceID,
          ),
          PeerInfoItem(
            title: 'Session ID:',
            value: peerModel.sessionID,
          ),
        ],
      ),
    );
  }
}
