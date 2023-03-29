// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/scan_qr_code_screen/widgets/beacon_server_info_card.dart';
import 'package:explorer/screens/scan_qr_code_screen/widgets/beacon_server_scan_box.dart';
import 'package:explorer/screens/scan_qr_code_screen/widgets/beacon_server_title.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class BeaconServersScanResultContainer extends StatefulWidget {
  const BeaconServersScanResultContainer({
    super.key,
  });

  @override
  State<BeaconServersScanResultContainer> createState() =>
      _BeaconServersScanResultContainerState();
}

class _BeaconServersScanResultContainerState
    extends State<BeaconServersScanResultContainer> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      beaconPF(context).startScanForBeaconServers(serverPF(context));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var beaconServer = beaconP(context);

    return Container(
      color: kBackgroundColor,
      height: 200,
      width: double.infinity,
      child: Column(
        children: [
          if (beaconServer.scanning)
            BeaconServerScanBox()
          else if (beaconServer.discoveredBeaconServers.isNotEmpty)
            BeaconServerTitle(),
          Expanded(
            child: beaconServer.scanning &&
                    beaconServer.discoveredBeaconServers.isEmpty
                ? Center(
                    child: Text(
                      'Loading Hosts...',
                      style: h4LightTextStyle,
                    ),
                  )
                : beaconServer.discoveredBeaconServers.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: double.infinity),
                          Text(
                            'No Hosts found',
                            style: h4LightTextStyle,
                          ),
                          TextButton(
                            onPressed: () {
                              beaconPF(context)
                                  .startScanForBeaconServers(serverPF(context));
                            },
                            child: Text(
                              'Rescan',
                            ),
                          ),
                        ],
                      )
                    : ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          ...beaconServer.discoveredBeaconServers
                              .map(
                                (e) => BeaconServerInfoCard(
                                  beaconServerModel: e,
                                ),
                              )
                              .toList(),
                          VSpace(),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}
