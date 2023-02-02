// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/download_manager_screen/widgets/download_card.dart';
import 'package:explorer/screens/download_manager_screen/widgets/download_speed_viewer.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class ActiveScreen extends StatelessWidget {
  const ActiveScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var downloadProvider = downP(context);
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          // ElevatedButton(
          //     onPressed: () {
          //       downPF(context).clearAllTasks();
          //     },
          //     child: Text('Clear All')),
          if (downloadProvider.downloadSpeed != null)
            DownloadSpeedViewer(downloadSpeed: downloadProvider.downloadSpeed!),
          VSpace(),
          Expanded(
            child: downloadProvider.activeTasks.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/accept.png',
                          width: largeIconSize,
                          color: kMainIconColor.withOpacity(.5),
                        ),
                        VSpace(factor: .5),
                        Text(
                          'No Active Downloads',
                          style: h3InactiveTextStyle,
                        ),
                      ],
                    ),
                  )
                : PaddingWrapper(
                    padding: EdgeInsets.symmetric(horizontal: kHPad / 2),
                    child: ListView.builder(
                      itemCount: downloadProvider.activeTasks.length,
                      itemBuilder: (context, index) => DownloadCard(
                        downloadTaskModel: downloadProvider.activeTasks[index],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
