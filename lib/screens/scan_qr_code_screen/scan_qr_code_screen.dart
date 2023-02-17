// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/qr_result_modal.dart';
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
          if ((scanData.code ?? '').endsWith(dummyEndPoint) &&
              (scanData.code ?? '').startsWith('http://')) {
            Navigator.pop(
                context, scanData.code?.replaceAll(dummyEndPoint, ''));
            await c.stopCamera();
          } else {
            // this time it might be for connecting to laptop option
            String code = scanData.code ?? '';
            var data = code.split(' ');
            if (data.length != 2) return;
            int? last = int.tryParse(data.last);
            if (last == null) return;
            Navigator.pop(context, scanData.code);
            await c.stopCamera();
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
                    onQRViewCreated: (p0) =>
                        _onQRViewCreated(p0, justQrScanner),
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
