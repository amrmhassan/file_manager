import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
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
    setState(() {
      controller = c;
    });
    await c.resumeCamera();
    c.scannedDataStream.listen((scanData) async {
      if ((scanData.code ?? '').endsWith(dummyEndPoint) &&
          (scanData.code ?? '').startsWith('http://') &&
          (scanData.code ?? '').length >=
              ('http://1.1.1.1:0$dummyEndPoint').length &&
          (scanData.code ?? '').length <=
              ('http://999.999.999.999:65000$dummyEndPoint').length) {
        Navigator.pop(context, scanData.code?.replaceAll(dummyEndPoint, ''));
        await c.stopCamera();
      }
      setState(() {
        result = scanData;
      });
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
