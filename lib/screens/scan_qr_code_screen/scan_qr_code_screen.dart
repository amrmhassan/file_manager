// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/qr_result_modal.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/screens/connect_laptop_coming_soon/connect_laptop_coming_soon.dart';
import 'package:explorer/screens/scan_qr_code_screen/widgets/beacon_server_result.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
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
  final GlobalKey qrKey = GlobalKey();
  // Barcode? result;
  QRViewController? controller;
  void _onQRViewCreated(QRViewController c, [bool? justScanner]) async {
    try {
      await c.resumeCamera();
      c.scannedDataStream.listen(
        (event) => onScanCapture(
          event,
          justScanner,
          c,
        ),
      );
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
                if (!Platform.isWindows)
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
                  )
                else
                  Expanded(
                    child: Container(
                      color: kCardBackgroundColor,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hosting devices will show up down below',
                            style: h3InactiveTextStyle,
                            textAlign: TextAlign.center,
                          ),
                          Icon(
                            Icons.broadcast_on_personal_outlined,
                            color: kGreenColor,
                            size: largeIconSize,
                          ),
                        ],
                      ),
                    ),
                  ),
                BeaconServersScanResultContainer(),
              ],
            ),
          )
        ],
      ),
    );
  }

  void onScanCapture(
    Barcode scanData,
    bool? justScanner,
    QRViewController c,
  ) async {
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
        Navigator.pop(context, scanData.code?.replaceAll(EndPoints.dummy, ''));
        await c.stopCamera();
      } else {
        // this time it might be for connecting to laptop option
        String code = (scanData.code ?? '')..replaceAll(EndPoints.dummy, '');
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
  }
}
