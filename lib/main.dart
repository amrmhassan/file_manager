// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/firebase_options.dart';
import 'package:explorer/helpers/hive/hive_initiator.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:explorer/providers/connect_laptop_provider.dart';
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
import 'package:explorer/screens/connect_laptop_coming_soon/connect_laptop_coming_soon.dart';
import 'package:explorer/screens/connect_laptop_screen/connect_laptop_screen.dart';
import 'package:explorer/screens/download_manager_screen/download_manager_screen.dart';
import 'package:explorer/screens/download_settings_screen/download_settings_screen.dart';
import 'package:explorer/screens/intro_screen/intro_screen.dart';
import 'package:explorer/screens/items_viewer_screen/items_viewer_screen.dart';
import 'package:explorer/screens/ext_files_screen/ext_files_screen.dart';
import 'package:explorer/screens/ext_report_screen/ext_report_screen.dart';
import 'package:explorer/screens/home_screen/home_screen.dart';
import 'package:explorer/screens/isolate_testing_screen/isolate_testing_screen.dart';
import 'package:explorer/screens/laptop_messages_screen/laptop_messages_screen.dart';
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
import 'package:explorer/utils/notifications/notification_contorller.dart';
import 'package:explorer/utils/notifications/notification_id_mapper.dart';
import 'package:explorer/utils/notifications/notification_init.dart';
import 'package:explorer/utils/theme_utils.dart';
import 'package:external_path/external_path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//! add the ability to download a folder
//! add video, audio notification
//! prevent the app from being killed when it is in the background
//!

// fix viewwing the file hint in windows
// fix continuing faild task from laptop

// fix notification still viewed after file downloaded

//! add download folder, then allow selecting for multiple downloads in sharespace viewer screen, then sorting, then" download to "

bool firstTimeRunApp = false;
DownloadsNotificationIDSMapper notificationMapper =
    DownloadsNotificationIDSMapper();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
  if (kReleaseMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  try {
    await HiveInitiator().setup();
    firstTimeRunApp = await SharedPrefHelper.firstTimeRunApp();
    await setThemeVariables();
    initializeNotification();
    //?
    // sdcard setting
    var path = await ExternalPath.getExternalStorageDirectories();
    path.insert(0, '/');
    initialDirs = path.map((e) => Directory(e)).toList();

    //?
  } catch (e) {
    printOnDebug('Error with first time app in main() or theme variables');
    logger.e(e);
  }

  runApp(const MyApp());
}

bool testing = false;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
    super.initState();
  }

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
        ChangeNotifierProvider(create: (ctx) => ConnectLaptopProvider()),
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
          ShareSettingsScreen.routeName: (context) => ShareSettingsScreen(),
          WhiteBlockListScreen.routeName: (context) => WhiteBlockListScreen(),
          IntroScreen.routeName: (context) => IntroScreen(),
          AboutUsScreen.routeName: (context) => AboutUsScreen(),
          LaptopMessagesScreen.routeName: (context) => LaptopMessagesScreen(),
          ConnectLaptopScreen.routeName: (context) => ConnectLaptopScreen(),
          DownloadSetScreen.routeName: (context) => DownloadSetScreen(),
          ConnLaptopComingSoon.routeName: (context) => ConnLaptopComingSoon(),
        },
      ),
    );
  }
}
