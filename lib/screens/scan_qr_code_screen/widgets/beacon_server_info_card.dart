// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/models/beacon_server_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/screens/scan_qr_code_screen/widgets/beacon_server_icon.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
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
        try {
          var shareProvider = sharePF(context);
          await beaconPF(context).askForBeaconServerConnLink(
            myName: shareProvider.myName,
            myDeviceID: shareProvider.myDeviceId,
            beaconServerUrl: beaconServerModel.url,
          );
        } on DioError catch (e) {
          String? refuseMessage =
              e.response!.headers.value(KHeaders.serverRefuseReasonHeaderKey);
          fastSnackBar(
            msg: refuseMessage ?? 'Error Occurred',
            snackBarType: SnackBarType.error,
          );
        }
      },
      leading: BeaconServerIcon(beaconServerModel: beaconServerModel),
      title: Text(
        beaconServerModel.deviceName,
        style: h4TextStyle,
      ),
      trailing: Text(beaconServerModel.url),
    );
  }
}
