// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/recent_items_viewer_screen/recent_items_viewer_screen.dart';
import 'package:explorer/screens/recent_screen/widget/recent_item_type.dart';
import 'package:explorer/screens/recent_screen/widget/recents_widget.dart';
import 'package:flutter/material.dart';

class RecentScreen extends StatefulWidget {
  const RecentScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RecentScreen> createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
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
        // Container(
        //   width: double.infinity,
        //   alignment: Alignment.center,
        //   child: Text(
        //     'Recent Files',
        //     style: h2TextStyle.copyWith(
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
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
                        print('object');
                        Navigator.pushNamed(
                          context,
                          RecentItemsViewerScreen.routeName,
                          arguments: RecentType.image,
                        );
                      },
                    ),
                    RecentItemType(
                      iconName: 'video',
                      title: 'Videos',
                      onTap: () {},
                    ),
                    RecentItemType(
                      iconName: 'doc',
                      onTap: () {},
                      title: 'Docs',
                    ),
                    RecentItemType(
                      iconName: 'music',
                      onTap: () {},
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
                      onTap: () {},
                    ),
                    RecentItemType(
                      iconName: 'download2',
                      title: 'Downloads',
                      onTap: () {},
                    ),
                    RecentItemType(
                      iconName: 'archive',
                      onTap: () {},
                      title: 'Archives',
                    ),
                    RecentItemType(
                      iconName: 'whatsapp',
                      onTap: () {},
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
