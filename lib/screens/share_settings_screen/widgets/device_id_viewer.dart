// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class DeviceIDViewer extends StatelessWidget {
  const DeviceIDViewer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var shareProvider = shareP(context);

    return PaddingWrapper(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Device ID',
            style: h4TextStyleInactive,
          ),
          GestureDetector(
            onTap: () {
              copyToClipboard(context, shareProvider.myDeviceId);
            },
            child: Text(
              shareProvider.myDeviceId,
              style: h5InactiveTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
