// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/models/beacon_server_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/screens/scan_qr_code_screen/widgets/beacon_server_icon.dart';
import 'package:explorer/screens/share_screen/widgets/share_controllers_buttons.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BeaconServerInfoCard extends StatelessWidget {
  final BeaconServerModel beaconServerModel;
  const BeaconServerInfoCard({
    super.key,
    required this.beaconServerModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        // beaconPF(context).connectToBeaconServer(context, beaconServerModel);
        try {
          showSnackBar(context: context, message: 'Waiting for host response');
          var shareProvider = sharePF(context);
          await beaconPF(context).askForBeaconServerConnLink(
            myName: shareProvider.myName,
            myDeviceID: shareProvider.myDeviceId,
            beaconServerUrl: beaconServerModel.url,
          );
          String connLink = beaconServerModel.connQueryLink!;
          try {
            handleConnectToHostWithCode(connLink, context);
            Navigator.pop(context);
          } catch (e) {
            showSnackBar(
              context: context,
              message: e.toString(),
              snackBarType: SnackBarType.error,
            );
          }
        } catch (e) {
          if (e is DioError) {
            String? refuseMessage =
                e.response?.headers.value(KHeaders.serverRefuseReasonHeaderKey);
            fastSnackBar(
              msg: refuseMessage ?? e.toString(),
              snackBarType: SnackBarType.error,
            );
          } else {
            fastSnackBar(
              msg: e.toString(),
              snackBarType: SnackBarType.error,
            );
          }
        }
      },
      leading: BeaconServerIcon(beaconServerModel: beaconServerModel),
      title: Text(
        beaconServerModel.deviceName,
        style: h4TextStyle,
      ),
      trailing: kDebugMode
          ? Text(beaconServerModel.url)
          : Text(
              'Connect',
              style: h4LiteTextStyle,
            ),
    );
  }
}
