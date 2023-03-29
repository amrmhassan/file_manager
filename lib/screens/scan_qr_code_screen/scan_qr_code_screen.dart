// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/global/modals/qr_result_modal.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/beacon_server_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/screens/connect_laptop_coming_soon/connect_laptop_coming_soon.dart';
import 'package:explorer/screens/test_screen/test_screen.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:localization/localization.dart';

class ScanQRCodeScreen extends StatefulWidget {
  static const String routeName = '/ScanQRCodeScreen';
  const ScanQRCodeScreen({super.key});

  @override
  State<ScanQRCodeScreen> createState() => _ScanQRCodeScreenState();
}

class _ScanQRCodeScreenState extends State<ScanQRCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QrScanner');
  // Barcode? result;
  QRViewController? controller;
  void _onQRViewCreated(QRViewController c, [bool? justScanner]) async {
    try {
      await c.resumeCamera();
      c.scannedDataStream.listen((scanData) async {
        if (justScanner == true) {
          await c.pauseCamera();

          await showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => QrResultModal(
              code: scanData.code,
            ),
          );
          await c.resumeCamera();
        } else {
          if ((scanData.code ?? '').endsWith(EndPoints.dummy) &&
              (scanData.code ?? '').startsWith('http://')) {
            Navigator.pop(
                context, scanData.code?.replaceAll(EndPoints.dummy, ''));
            await c.stopCamera();
          } else {
            // this time it might be for connecting to laptop option
            String code = (scanData.code ?? '')
              ..replaceAll(EndPoints.dummy, '');
            var data = code.split(' ');
            if (data.length != 2) return;
            int? last = int.tryParse(data.last);
            if (last == null) return;
            await c.stopCamera();
            try {
              Navigator.pop(context, scanData.code);
            } catch (e) {
              logger.e(e);
            }
          }
        }
      });
    } catch (e, s) {
      throw CustomException(
        e: e,
        s: s,
        rethrowError: true,
      );
    }
    setState(() {
      controller = c;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool? justQrScanner = ModalRoute.of(context)?.settings.arguments as bool?;

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'scan-qr-code'.i18n(),
              style: h2TextStyle.copyWith(
                color: kActiveTextColor,
              ),
            ),
            leftIcon: justQrScanner == true
                ? null
                : Row(
                    children: [
                      HSpace(),
                      ButtonWrapper(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ConnLaptopComingSoon.routeName,
                            arguments: false, // first time
                          );
                        },
                        child: Image.asset(
                          'assets/icons/info.png',
                          width: mediumIconSize,
                          color: kMainIconColor,
                        ),
                      ),
                    ],
                  ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: (p0) =>
                        _onQRViewCreated(p0, justQrScanner),
                    overlay: QrScannerOverlayShape(
                      borderRadius: 10,
                      borderColor: kBackgroundColor,
                      borderWidth: 10,
                    ),
                  ),
                ),
                BeaconServersScanResult(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BeaconServersScanResult extends StatefulWidget {
  const BeaconServersScanResult({
    super.key,
  });

  @override
  State<BeaconServersScanResult> createState() =>
      _BeaconServersScanResultState();
}

class _BeaconServersScanResultState extends State<BeaconServersScanResult> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      beaconPF(context).startScanForBeaconServers(serverPF(context));
    });
    super.initState();
  }

  @override
  void dispose() {
    Future.delayed(Duration.zero).then((value) {
      beaconPF(navigatorKey.currentContext!).clearBeaconServers();
    });
    super.dispose();
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

class BeaconServerTitle extends StatelessWidget {
  const BeaconServerTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HSpace(factor: .8),
        Container(
          alignment: Alignment.centerLeft,
          height: largeIconSize,
          child: Text(
            'Hosting Devices',
            style: h4TextStyleInactive,
          ),
        ),
      ],
    );
  }
}

class BeaconServerScanBox extends StatelessWidget {
  const BeaconServerScanBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: largeIconSize,
      child: Row(
        children: [
          HSpace(factor: .8),
          Text(
            'Scanning...',
            style: h4TextStyleInactive,
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(mediumPadding),
            width: mediumIconSize,
            height: mediumIconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          HSpace(factor: .5),
        ],
      ),
    );
  }
}

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

class BeaconServerIcon extends StatefulWidget {
  final BeaconServerModel beaconServerModel;
  const BeaconServerIcon({
    super.key,
    required this.beaconServerModel,
  });

  @override
  State<BeaconServerIcon> createState() => _BeaconServerIconState();
}

class _BeaconServerIconState extends State<BeaconServerIcon> {
  @override
  void initState() {
    beaconPF(context)
        .askForBeaconServerImage(beaconServerUrl: widget.beaconServerModel.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // no image
    return widget.beaconServerModel.noImage
        ? Container(
            clipBehavior: Clip.hardEdge,
            width: largeIconSize,
            height: largeIconSize,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.2),
              borderRadius: BorderRadius.circular(1000),
            ),
            child: Image.asset(
              'assets/icons/user.png',
              color: kCardBackgroundColor.withOpacity(1),
            ),
          )
        : widget.beaconServerModel.serverImage == null // loading my image
            ? Container(
                clipBehavior: Clip.hardEdge,
                width: largeIconSize,
                height: largeIconSize,
                padding: EdgeInsets.all(largePadding),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.2),
                  borderRadius: BorderRadius.circular(
                    1000,
                  ),
                ),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
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
                  widget.beaconServerModel.serverImage!,
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
              );
  }
}
