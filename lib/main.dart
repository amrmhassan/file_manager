// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/helpers/hive/hive_initiator.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:explorer/providers/download_provider.dart';
import 'package:explorer/providers/quick_send_provider.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/providers/util/analyzer_provider.dart';
import 'package:explorer/providers/children_info_provider.dart';
import 'package:explorer/providers/util/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/providers/listy_provider.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:explorer/providers/recent_provider.dart';
import 'package:explorer/providers/theme_provider.dart';
import 'package:explorer/providers/thumbnail_provider.dart';
import 'package:explorer/providers/settings_provider.dart';
import 'package:explorer/screens/about_us_screen/about_us_screen.dart';
import 'package:explorer/screens/analyzer_screen/analyzer_screen.dart';
import 'package:explorer/screens/download_manager_screen/download_manager_screen.dart';
import 'package:explorer/screens/error_viewing_screen/error_viewing_screen.dart';
import 'package:explorer/screens/intro_screen/intro_screen.dart';
import 'package:explorer/screens/items_viewer_screen/items_viewer_screen.dart';
import 'package:explorer/screens/ext_files_screen/ext_files_screen.dart';
import 'package:explorer/screens/ext_report_screen/ext_report_screen.dart';
import 'package:explorer/screens/home_screen/home_screen.dart';
import 'package:explorer/screens/isolate_testing_screen/isolate_testing_screen.dart';
import 'package:explorer/screens/listy_items_viewer_screen/listy_items_viewer_screen.dart';
import 'package:explorer/screens/listy_screen/listy_screen.dart';
import 'package:explorer/screens/qr_code_viewer_screen/qr_code_viewer_screen.dart';
import 'package:explorer/screens/recent_items_viewer_screen/recent_items_viewer_screen.dart';
import 'package:explorer/screens/scan_qr_code_screen/scan_qr_code_screen.dart';
import 'package:explorer/screens/selected_items_screen/selected_items_screen.dart';
import 'package:explorer/screens/settings_screen/settings_screen.dart';
import 'package:explorer/screens/share_screen/share_screen.dart';
import 'package:explorer/screens/share_settings_screen/share_settings_screen.dart';
import 'package:explorer/screens/share_space_viewer_screen/share_space_viewer_screen.dart';
import 'package:explorer/screens/sizes_exp_screen/sizes_exp_screen.dart';
import 'package:explorer/screens/storage_cleaner_screen/storage_cleaner_screen.dart';
import 'package:explorer/screens/test_screen/test_screen.dart';
import 'package:explorer/screens/whats_app_files_screen/whats_app_files_screen.dart';
import 'package:explorer/screens/whats_app_screen/whats_app_screen.dart';
import 'package:explorer/screens/white_block_list_screen/white_block_list_screen.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/theme_utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//! fix my share space when connected
//! before publishing
//2- about developer
// new features
//3- deploy
//? share space mean the main items that are in the main view of peer share space, this doesn't include the children of a shared folder or so
//! add the ability to download a folder
//! add video, audio notification
//! prevent the app from being killed when it is in the background
//!

// view buffered places in the video player seeker bar
// make the fast seeker widget for the video to be much bigger for the landscape mode
// make the video not to be hidden when clicking the eye button next to a video even if the video is playing right now
// open the task file when clicking over it and open it's folder when clicking the folder icon

// add settings for the sharing
//!!! when pausing the downloaded file at it's end(i think when it's downloading the final smaller part) the error happen and it doesn't download till the end
//! add AnimatedSwitcher for the fade in image for the user image

// fix the issue of connecting with wifi or hotspot
// -- host device can open his hotspot or connect with same wifi network
// -- but client device must connect over his wifi

// when downloading a file and it exists, tell give the user the option to overwrite it or to cancel downloading

// Today wednesday  Notifications of video, audio, download
// Fix the problem of killing the app in background

// the new approach towards the wifi or hotspot problem is that the sending device will show
// all ips in the qr code, for example
// for better implementation you can just limit the number of interfaces by choosing only who has wlan or wifi or wi-fi,local area(for windows) something like that
// http://192.168.1.7:45569||http://192.168.137.78:45569||etc...
// and the receiving device will check for each of these, and the one that creates an error is wrong, and the one that gives response via a certain  is the right one

bool firstTimeRunApp = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await HiveInitiator().setup();
    firstTimeRunApp = await SharedPrefHelper.firstTimeRunApp();
    await setThemeVariables();
  } catch (e) {
    printOnDebug('Error with first time app in main() or theme variables');
  }

  runApp(const MyApp());
}

bool testing = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ChildrenItemsProvider()),
        ChangeNotifierProvider(create: (ctx) => AnalyzerProvider()),
        ChangeNotifierProvider(create: (ctx) => ExplorerProvider()),
        ChangeNotifierProvider(create: (ctx) => FilesOperationsProvider()),
        ChangeNotifierProvider(create: (ctx) => SettingsProvider()),
        ChangeNotifierProvider(create: (ctx) => RecentProvider()),
        ChangeNotifierProvider(create: (ctx) => ThemeProvider()),
        ChangeNotifierProvider(create: (ctx) => MediaPlayerProvider()),
        ChangeNotifierProvider(create: (ctx) => ListyProvider()),
        ChangeNotifierProvider(create: (ctx) => ThumbnailProvider()),
        ChangeNotifierProvider(create: (ctx) => ShareProvider()),
        ChangeNotifierProvider(create: (ctx) => ServerProvider()),
        ChangeNotifierProvider(create: (ctx) => ShareItemsExplorerProvider()),
        ChangeNotifierProvider(create: (ctx) => DownloadProvider()),
        ChangeNotifierProvider(create: (ctx) => QuickSendProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(
            bodyLarge: TextStyle(
              fontFamily: 'Cairo',
              color: kActiveTextColor,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'Cairo',
              color: kActiveTextColor,
            ),
          ),
        ),
        initialRoute: testing
            ? TestScreen.routeName
            : (firstTimeRunApp ? IntroScreen.routeName : HomeScreen.routeName),
        navigatorKey: navigatorKey,
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
          TestScreen.routeName: (context) => TestScreen(),
          IsolateTestingScreen.routeName: (context) => IsolateTestingScreen(),
          SizesExpScreen.routeName: (context) => SizesExpScreen(),
          ExtReportScreen.routeName: (context) => ExtReportScreen(),
          ExtFilesScreen.routeName: (context) => ExtFilesScreen(),
          AnalyzerScreen.routeName: (context) => AnalyzerScreen(),
          WhatsAppScreen.routeName: (context) => WhatsAppScreen(),
          WhatsappFilesScreen.routeName: (context) => WhatsappFilesScreen(),
          RecentsViewerScreen.routeName: (context) => RecentsViewerScreen(),
          StorageCleanerScreen.routeName: (context) => StorageCleanerScreen(),
          ItemsViewerScreen.routeName: (context) => ItemsViewerScreen(),
          ListyScreen.routeName: (context) => ListyScreen(),
          ListyItemViewerScreen.routeName: (context) => ListyItemViewerScreen(),
          SettingsScreen.routeName: (context) => SettingsScreen(),
          SelectedItemsScreen.routeName: (context) => SelectedItemsScreen(),
          ShareScreen.routeName: (context) => ShareScreen(),
          QrCodeViewerScreen.routeName: (context) => QrCodeViewerScreen(),
          ScanQRCodeScreen.routeName: (context) => ScanQRCodeScreen(),
          ShareSpaceVScreen.routeName: (context) => ShareSpaceVScreen(),
          DownloadManagerScreen.routeName: (context) => DownloadManagerScreen(),
          ErrorViewScreen.routeName: (context) => ErrorViewScreen(),
          ShareSettingsScreen.routeName: (context) => ShareSettingsScreen(),
          WhiteBlockListScreen.routeName: (context) => WhiteBlockListScreen(),
          IntroScreen.routeName: (context) => IntroScreen(),
          AboutUsScreen.routeName: (context) => AboutUsScreen(),
        },
      ),
    );
  }
}
