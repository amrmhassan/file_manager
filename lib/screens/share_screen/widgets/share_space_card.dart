// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/peer_model.dart';
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
                onTap: () {},
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

class PeerIcon extends StatelessWidget {
  const PeerIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(largePadding),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: Colors.white.withOpacity(.6),
      ),
      child: Image.asset(
        'assets/icons/user.png',
        color: kCardBackgroundColor.withOpacity(.5),
      ),
    );
  }
}
