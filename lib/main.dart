// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/providers/download_provider.dart';
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
import 'package:explorer/screens/analyzer_screen/analyzer_screen.dart';
import 'package:explorer/screens/download_manager_screen/download_manager_screen.dart';
import 'package:explorer/screens/error_viewing_screen/error_viewing_screen.dart';
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
import 'package:explorer/screens/share_space_viewer_screen/share_space_viewer_screen.dart';
import 'package:explorer/screens/sizes_exp_screen/sizes_exp_screen.dart';
import 'package:explorer/screens/storage_cleaner_screen/storage_cleaner_screen.dart';
import 'package:explorer/screens/test_screen/test_screen.dart';
import 'package:explorer/screens/whats_app_files_screen/whats_app_files_screen.dart';
import 'package:explorer/screens/whats_app_screen/whats_app_screen.dart';
import 'package:explorer/utils/theme_utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//! when the group host i should close the connection at all

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setThemeVariables();
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
        initialRoute: testing ? TestScreen.routeName : HomeScreen.routeName,
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
          ShareSpaceViewerScreen.routeName: (context) =>
              ShareSpaceViewerScreen(),
          DownloadManagerScreen.routeName: (context) => DownloadManagerScreen(),
          ErrorViewScreen.routeName: (context) => ErrorViewScreen(),
        },
      ),
    );
  }
}
