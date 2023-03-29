// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/beacon_server_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  static const String routeName = '/TestScreen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      beaconPF(context).clearBeaconServers();

      beaconPF(context).startScanForBeaconServers(serverPF(context));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var beaconProvider = beaconP(context);
    var beaconProviderFalse = beaconPF(context);

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          VSpace(),
          if (beaconProvider.scanning) CircularProgressIndicator(),
          Expanded(
            child: ListView(
              children: beaconProvider.discoveredBeaconServers.map(
                (e) {
                  beaconProviderFalse.askForBeaconServerImage(
                    beaconServerUrl: e.url,
                  );
                  return ListTile(
                    onTap: () async {
                      try {
                        var shareProvider = sharePF(context);
                        await beaconProviderFalse.askForBeaconServerConnLink(
                          myName: shareProvider.myName,
                          myDeviceID: shareProvider.myDeviceId,
                          beaconServerUrl: e.url,
                        );
                      } on DioError catch (e) {
                        String? refuseMessage = e.response!.headers
                            .value(KHeaders.serverRefuseReasonHeaderKey);
                        fastSnackBar(
                          msg: refuseMessage ?? 'Error Occurred',
                          snackBarType: SnackBarType.error,
                        );
                      }
                    },
                    leading: BeaconServerIcon(beaconServerModel: e),
                    title: Text(
                      e.deviceName,
                      style: h4TextStyle,
                    ),
                    trailing: Text(e.url),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class BeaconServerIcon extends StatelessWidget {
  final BeaconServerModel beaconServerModel;
  const BeaconServerIcon({
    super.key,
    required this.beaconServerModel,
  });

  @override
  Widget build(BuildContext context) {
    return beaconServerModel.noImage
        ? Container(
            width: largeIconSize,
            height: largeIconSize,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(
                1000,
              ),
            ),
          )
        : beaconServerModel.serverImage == null // loading my image
            ? Container(
                width: largeIconSize,
                height: largeIconSize,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(
                    1000,
                  ),
                ),
                child: CircularProgressIndicator(),
              )
            // have an image
            : Container(
                clipBehavior: Clip.hardEdge,
                padding: EdgeInsets.all(mediumPadding),
                width: largeIconSize,
                height: largeIconSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    1000,
                  ),
                ),
                child: Image.memory(
                  beaconServerModel.serverImage!,
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
              );
  }
}
