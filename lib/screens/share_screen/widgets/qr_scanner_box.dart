import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerBox extends StatefulWidget {
  const QrScannerBox({
    Key? key,
  }) : super(key: key);

  @override
  State<QrScannerBox> createState() => _QrScannerBoxState();
}

class _QrScannerBoxState extends State<QrScannerBox> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QrScanner');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderRadius: 10,
            ),
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController c) async {
    setState(() {
      controller = c;
    });
    await c.resumeCamera();
    c.scannedDataStream.listen((scanData) {
      if ((scanData.code ?? '').startsWith('filemanager://')) {
        Navigator.pop(context, scanData.code);
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
}
