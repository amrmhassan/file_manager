// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/screens/share_screen/widgets/peer_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShareSpaceCard extends StatelessWidget {
  final PeerModel peerModel;
  final bool me;
  const ShareSpaceCard({
    Key? key,
    required this.peerModel,
    required this.me,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: kHPad / 2,
            vertical: kVPad / 2,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: kCardBackgroundColor,
            borderRadius: BorderRadius.circular(
              mediumBorderRadius,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  PeerIcon(),
                  HSpace(),
                  Text(
                    me ? 'Your Share Space' : '${peerModel.name} Share Space',
                    style: me ? h3TextStyle : h3InactiveTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              ButtonWrapper(
                borderRadius: 1000,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => ModalWrapper(
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
                            title: 'Device ID:',
                            value: peerModel.deviceID,
                          ),
                          PeerInfoItem(
                            title: 'Session ID:',
                            value: peerModel.sessionID,
                          ),
                          PeerInfoItem(
                            title: 'Joined At:',
                            value: DateFormat('yy-MM-dd hh:mm aa')
                                .format(peerModel.joinedAt),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/icons/info.png',
                  width: mediumIconSize,
                  color: kMainIconColor.withOpacity(.8),
                ),
              )
            ],
          ),
        ),
        VSpace(factor: .5),
      ],
    );
  }
}

class PeerInfoItem extends StatelessWidget {
  final String title;
  final String value;
  const PeerInfoItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: h4TextStyle,
        ),
        Text(
          value,
          style: h4TextStyleInactive,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
