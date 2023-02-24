// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/screens/share_screen/widgets/not_sharing_view.dart';
import 'package:explorer/screens/share_screen/widgets/share_screen_navbar.dart';
import 'package:explorer/screens/share_screen/widgets/share_space_card.dart';
import 'package:explorer/screens/share_screen/widgets/share_space_screen_appbar.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShareScreen extends StatefulWidget {
  static const String routeName = '/ShareScreen';
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  @override
  Widget build(BuildContext context) {
    var serverProvider = Provider.of<ServerProvider>(context);

    var shareProvider = Provider.of<ShareProvider>(context);
    var shareProviderFalse = Provider.of<ShareProvider>(context, listen: false);

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShareSpaceScreenAppBar(),
          VSpace(),
          serverProvider.myIp == null
              ? NotSharingView()
              : Builder(builder: (context) {
                  PeerModel? hostPeer = serverProvider.getHostPeer;
                  if (hostPeer == null) {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: double.infinity),
                          CircularProgressIndicator(
                            color: kMainIconColor,
                            strokeWidth: 3,
                          ),
                          VSpace(factor: .8),
                          Text(
                            'Loading Group Info',
                            style: h4TextStyleInactive,
                          ),
                        ],
                      ),
                    );
                  }

                  bool iamTheHost =
                      shareProvider.myDeviceId == hostPeer.deviceID;

                  var otherPeersButMe = serverProvider.peers.where(
                    (element) =>
                        element.deviceID != shareProviderFalse.myDeviceId,
                  );
                  PeerModel me = serverProvider.peers.firstWhere(
                    (element) =>
                        element.deviceID == shareProviderFalse.myDeviceId,
                  );
                  return Expanded(
                    child: PaddingWrapper(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                iamTheHost
                                    ? 'You are the group host'
                                    : 'Connected to ${hostPeer.name}',
                                style: h4TextStyleInactive,
                              ),
                            ],
                          ),
                          VSpace(),
                          ShareSpaceCard(
                            peerModel: me,
                            me: true,
                          ),
                          ...otherPeersButMe.map((e) => ShareSpaceCard(
                                peerModel: e,
                                me: false,
                              )),
                        ],
                      ),
                    ),
                  );
                }),
          ShareScreenNavBar(),
        ],
      ),
    );
  }
}
