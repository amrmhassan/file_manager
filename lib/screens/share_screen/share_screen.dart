// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareScreen extends StatelessWidget {
  static const String routeName = '/ShareScreen';
  const ShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var shareProvider = Provider.of<ShareProvider>(context);
    var shareProviderFalse = Provider.of<ShareProvider>(context, listen: false);
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  shareProviderFalse.startHost();
                },
                child: Text('Host'),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () async {},
                child: Text('Join'),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: double.infinity),
              if (shareProvider.myConnLink != null)
                GestureDetector(
                  onTap: () {
                    copyPathToClipboard(context, shareProvider.myConnLink!);
                  },
                  child: Column(
                    children: [
                      QrImage(
                        data: shareProvider.myConnLink!,
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        version: QrVersions.auto,
                        size: 200,
                      ),
                      Text(shareProvider.myConnLink!)
                    ],
                  ),
                ),
              Text('Host must open his hotspot'),
            ],
          )
        ],
      ),
    );
  }
}
