// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/white_block_list_model.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class WhiteBlockListScreen extends StatelessWidget {
  static const String routeName = '/WhiteBlockListScreen';
  const WhiteBlockListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool allowed = ModalRoute.of(context)!.settings.arguments as bool;
    var serverProvider = serverP(context);
    List<WhiteBlockListModel> viewedDevices =
        allowed ? serverProvider.allowedPeers : serverProvider.blockedPeers;

    return ScreensWrapper(
        backgroundColor: kBackgroundColor,
        child: Column(
          children: [
            CustomAppBar(
              title: Text(
                allowed ? 'White List' : 'Block List',
                style: h2TextStyle,
              ),
            ),
            VSpace(),
            viewedDevices.isEmpty
                ? Expanded(
                    child: Center(
                    child: Text(
                      'No Devices',
                      style: h4TextStyle,
                    ),
                  ))
                : Expanded(
                    child: ListView.builder(
                    itemCount: viewedDevices.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                        viewedDevices[index].name,
                        style: h4TextStyle,
                      ),
                    ),
                  ))
          ],
        ));
  }
}
