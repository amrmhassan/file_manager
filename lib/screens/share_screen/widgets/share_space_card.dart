// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/peer_info_modal.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/screens/share_screen/widgets/peer_icon.dart';
import 'package:explorer/screens/share_space_viewer_screen/share_space_viewer_screen.dart';
import 'package:flutter/material.dart';

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
        ButtonWrapper(
          onTap: () {
            Navigator.pushNamed(
              context,
              ShareSpaceVScreen.routeName,
              arguments: peerModel,
            );
          },
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
                  PeerIcon(
                    peerModel: peerModel,
                  ),
                  HSpace(),
                  Text(
                    me ? 'You' : peerModel.name,
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
                    builder: (context) => PeerInfoModal(peerModel: peerModel),
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
