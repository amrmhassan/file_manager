// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/shimmer_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/util/analyzer_provider.dart';
import 'package:explorer/screens/analyzer_screen/analyzer_screen.dart';
import 'package:explorer/screens/analyzer_screen/widgets/analyzer_options_item.dart';
import 'package:explorer/screens/items_viewer_screen/items_viewer_screen.dart';
import 'package:explorer/screens/listy_screen/listy_screen.dart';
import 'package:explorer/screens/recent_items_viewer_screen/recent_items_viewer_screen.dart';
import 'package:explorer/screens/recent_screen/widget/recent_item_type.dart';
import 'package:explorer/screens/recent_screen/widget/storage_segments.dart';
import 'package:explorer/screens/storage_cleaner_screen/storage_cleaner_screen.dart';
import 'package:explorer/screens/whats_app_screen/whats_app_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      RecentsViewerScreen.routeName,
      arguments: recentType,
    );
  }

  @override
  Widget build(BuildContext context) {
    var analyzerProvider = Provider.of<AnalyzerProvider>(context);
    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              VSpace(factor: .5),
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
                            iconName: 'image',
                            title: 'Images',
                            onTap: () {
                              openRecentScreen(RecentType.image);
                            },
                            color: kImagesColor,
                          ),
                          RecentItemType(
                            iconName: 'play-button',
                            title: 'Videos',
                            onTap: () {
                              openRecentScreen(RecentType.video);
                            },
                            color: kVideoColor,
                          ),
                          RecentItemType(
                            iconName: 'google-docs',
                            onTap: () {
                              openRecentScreen(RecentType.doc);
                            },
                            title: 'Docs',
                            color: kDocsColor,
                          ),
                          RecentItemType(
                            iconName: 'musical-note',
                            onTap: () {
                              openRecentScreen(RecentType.music);
                            },
                            title: 'Music',
                            color: kAudioColor,
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
                            color: kAPKsColor,
                          ),
                          RecentItemType(
                            iconName: 'download',
                            title: 'Downloads',
                            onTap: () {
                              openRecentScreen(RecentType.download);
                            },
                            color: kDocsColor,
                          ),
                          RecentItemType(
                            iconName: 'archive',
                            onTap: () {
                              openRecentScreen(RecentType.archives);
                            },
                            title: 'Archives',
                            color: kAPKsColor,
                          ),
                          RecentItemType(
                            iconName: 'whatsapp',
                            onTap: () {
                              Navigator.pushNamed(
                                  context, WhatsAppScreen.routeName);
                            },
                            title: 'Social',
                            color: kWhatsAppColor,
                          ),
                        ],
                      ),
                      VSpace(),
                    ],
                  ),
                ),
              ),
              AnalyzerOptionsItem(
                logoName: 'clock',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ItemsViewerScreen.routeName,
                    arguments: ItemsType.recentOpenedFiles,
                  );
                },
                title: 'Recently Opened',
                color: kMainIconColor,
              ),
              VSpace(),
              AnalyzerOptionsItem(
                logoName: 'analyzer',
                onTap: () {
                  Navigator.pushNamed(context, AnalyzerScreen.routeName);
                },
                title: 'Storage Analyzer',
              ),
              VSpace(),
              AnalyzerOptionsItem(
                logoName: 'cleaner',
                onTap: () {
                  Navigator.pushNamed(context, StorageCleanerScreen.routeName);
                },
                title: 'Storage Cleaner',
              ),
              VSpace(),
              AnalyzerOptionsItem(
                logoName: 'list1',
                onTap: () {
                  Navigator.pushNamed(context, ListyScreen.routeName);
                },
                title: 'Listy',
              ),
              // VSpace(),
              // AnalyzerOptionsItem(
              //   logoName: 'apps',
              //   onTap: () {},
              //   title: 'Apps Data',
              // ),
              VSpace(),
            ],
          ),
        ),
        analyzerProvider.allExtensionInfo == null ||
                (analyzerProvider.allExtensionInfo ?? []).isEmpty
            ? ShimmerWrapper(
                baseColor: Colors.white,
                lightColor: Color.fromARGB(255, 172, 172, 172),
                child: StorageSegments(),
              )
            : StorageSegments(),
      ],
    );
  }
}
