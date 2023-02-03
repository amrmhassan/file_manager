import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRCodeScreen extends StatefulWidget {
  static const String routeName = '/ScanQRCodeScreen';
  const ScanQRCodeScreen({super.key});

  @override
  State<ScanQRCodeScreen> createState() => _ScanQRCodeScreenState();
}

class _ScanQRCodeScreenState extends State<ScanQRCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QrScanner');
  Barcode? result;
  QRViewController? controller;
  void _onQRViewCreated(QRViewController c) async {
    try {
      await c.resumeCamera();
      //? instead of end point you can add a date time object
      //? and make the maximum period to scan is for example 10 minutes
      //? if the qr code was created more than 10 minutes just show a warning that
      //? it needs to be refreshed
      //? as clicking on the qr code icon will add a new 10 minutes to the qr code

//! don't activate this length part because it doesn't work in some cases
      // &&
      //       (scanData.code ?? '').length >=
      //           ('http://1.1.1.1:0$dummyEndPoint').length &&
      //       (scanData.code ?? '').length <=
      //           ('http://999.999.999.999:65000$dummyEndPoint').length
      c.scannedDataStream.listen((scanData) async {
        if ((scanData.code ?? '').endsWith(dummyEndPoint) &&
            (scanData.code ?? '').startsWith('http://')) {
          Navigator.pop(context, scanData.code?.replaceAll(dummyEndPoint, ''));
          await c.stopCamera();
        }
        setState(() {
          result = scanData;
        });
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
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'Scan Qr Code',
              style: h2TextStyle.copyWith(
                color: kActiveTextColor,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderRadius: 10,
                      borderColor: kBackgroundColor,
                      borderWidth: 10,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
