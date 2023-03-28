// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/client_utils.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

class TestScreen extends StatefulWidget {
  static const String routeName = '/TestScreen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          ElevatedButton(
            onPressed: () async {
              var peers = serverPF(context).peers;
              try {
                var data = await getPeerClipboard(peers[0]);
                if (data == null) {
                  //
                  showSnackBar(context: context, message: 'No Data');
                } else {
                  showSnackBar(context: context, message: data.toString());
                }
              } on DioError catch (e) {
                showSnackBar(
                  context: context,
                  message: e.response?.data,
                  snackBarType: SnackBarType.error,
                );
                logger.e(e.response!.statusCode);
                logger.e(e.response?.data);
              }
            },
            child: Text('test'),
          ),
        ],
      ),
    );
  }
}
