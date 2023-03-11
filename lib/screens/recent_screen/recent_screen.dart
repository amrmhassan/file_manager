// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/shared_pref_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/shimmer_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:explorer/providers/util/analyzer_provider.dart';
import 'package:explorer/screens/analyzer_screen/analyzer_screen.dart';
import 'package:explorer/screens/analyzer_screen/widgets/analyzer_options_item.dart';
import 'package:explorer/screens/connect_laptop_screen/connect_laptop_screen.dart';
import 'package:explorer/screens/items_viewer_screen/items_viewer_screen.dart';
import 'package:explorer/screens/listy_screen/listy_screen.dart';
import 'package:explorer/screens/recent_items_viewer_screen/recent_items_viewer_screen.dart';
import 'package:explorer/screens/recent_screen/widget/recent_item_type.dart';
import 'package:explorer/screens/recent_screen/widget/storage_segments.dart';
import 'package:explorer/screens/scan_qr_code_screen/scan_qr_code_screen.dart';
import 'package:explorer/screens/share_screen/share_screen.dart';
import 'package:explorer/screens/storage_cleaner_screen/storage_cleaner_screen.dart';
import 'package:explorer/screens/whats_app_screen/whats_app_screen.dart';
import 'package:explorer/screens/connect_laptop_coming_soon/connect_laptop_coming_soon.dart';
import 'package:explorer/screens/windows_client_update_note_screen/windows_client_update_note_screen.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
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
                logoName: 'management',
                onTap: () {
                  Navigator.pushNamed(context, ShareScreen.routeName);
                },
                title: 'Share',
                color: Colors.white,
              ),
              VSpace(),
              AnalyzerOptionsItem(
                logoName: 'laptop-icon',
                onTap: () async {
                  bool downloaded = (await SharedPrefHelper.getBool(
                          downloadWindowsClientKey)) ??
                      false;
                  if (downloaded) {
                    bool noted = (await SharedPrefHelper.getBool(
                            windowsClientUpdateNoteKey)) ??
                        false;
                    if (noted) {
                      handleConnectToLaptopButton(context);
                    } else {
                      SharedPrefHelper.setBool(
                        windowsClientUpdateNoteKey,
                        true,
                      );
                      Navigator.pushNamed(
                        context,
                        WindowsUpdateNoteScreen.routeName,
                      );
                    }
                  } else {
                    SharedPrefHelper.setBool(downloadWindowsClientKey, true);
                    Navigator.pushNamed(
                      context,
                      ConnLaptopComingSoon.routeName,
                      arguments: true,
                    );
                  }
                },
                title: 'Connect Laptop',
                color: Colors.white,
              ),
              VSpace(),
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
              VSpace(),
            ],
          ),
        ),
        (analyzerProvider.allExtensionInfo == null ||
                (analyzerProvider.allExtensionInfo ?? []).isEmpty
            ? ShimmerWrapper(
                baseColor: Colors.white,
                lightColor: Color.fromARGB(255, 172, 172, 172),
                child: StorageSegments(),
              )
            : StorageSegments()),
      ],
    );
  }
}

void handleConnectToLaptopButton(
  BuildContext context, [
  bool replace = false,
]) async {
  if (connectLaptopPF(context).remoteIP != null) {
    Navigator.pushNamed(context, ConnectLaptopScreen.routeName);
    return;
  }

  var code = await (replace
      ? Navigator.pushReplacementNamed(context, ScanQRCodeScreen.routeName)
      : Navigator.pushNamed(context, ScanQRCodeScreen.routeName));

  bool connected = await connectLaptopPF(navigatorKey.currentContext ?? context)
      .handleConnect(code);
  if (!connected) {
    showSnackBar(
        context: context,
        message:
            'Please ensure that both devices are connected to either the same Wi-Fi or to the hotspot of one of the devices.');
  }
  try {
    Navigator.pushNamed(context, ConnectLaptopScreen.routeName);
  } catch (e) {
    logger.e(e);
  }
}
