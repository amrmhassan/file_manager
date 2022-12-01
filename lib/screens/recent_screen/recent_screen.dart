// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/recent_items_viewer_screen/recent_items_viewer_screen.dart';
import 'package:explorer/screens/recent_screen/widget/recent_item_type.dart';
import 'package:explorer/screens/whats_app_screen/whats_app_screen.dart';
import 'package:flutter/material.dart';

class RecentScreen extends StatefulWidget {
  const RecentScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RecentScreen> createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  //? open recent screen
  void openRecentScreen(RecentType recentType) {
    Navigator.pushNamed(
      context,
      RecentItemsViewerScreen.routeName,
      arguments: recentType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        VSpace(factor: .5),
        // RecentWidget(),
        HLine(
          thickness: 1,
          color: kInactiveColor.withOpacity(.2),
        ),

        VSpace(),
        PaddingWrapper(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              // color: kCardBackgroundColor,
              borderRadius: BorderRadius.circular(mediumBorderRadius),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RecentItemType(
                      iconName: 'photo',
                      title: 'Images',
                      onTap: () {
                        openRecentScreen(RecentType.image);
                      },
                    ),
                    RecentItemType(
                      iconName: 'video',
                      title: 'Videos',
                      onTap: () {
                        openRecentScreen(RecentType.video);
                      },
                    ),
                    RecentItemType(
                      iconName: 'doc',
                      onTap: () {
                        openRecentScreen(RecentType.doc);
                      },
                      title: 'Docs',
                    ),
                    RecentItemType(
                      iconName: 'music',
                      onTap: () {
                        openRecentScreen(RecentType.music);
                      },
                      title: 'Music',
                    ),
                  ],
                ),
                VSpace(factor: .5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RecentItemType(
                      iconName: 'android',
                      title: 'APKs',
                      onTap: () {
                        openRecentScreen(RecentType.apk);
                      },
                    ),
                    RecentItemType(
                      iconName: 'download2',
                      title: 'Downloads',
                      onTap: () {
                        openRecentScreen(RecentType.download);
                      },
                    ),
                    RecentItemType(
                      iconName: 'archive',
                      onTap: () {
                        openRecentScreen(RecentType.archives);
                      },
                      title: 'Archives',
                    ),
                    RecentItemType(
                      iconName: 'whatsapp',
                      onTap: () {
                        Navigator.pushNamed(context, WhatsAppScreen.routeName);
                      },
                      title: 'Social',
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
