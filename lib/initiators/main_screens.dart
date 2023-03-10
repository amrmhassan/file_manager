import 'package:flutter/material.dart';
import 'package:explorer/screens/about_us_screen/about_us_screen.dart';
import 'package:explorer/screens/analyzer_screen/analyzer_screen.dart';
import 'package:explorer/screens/connect_laptop_coming_soon/connect_laptop_coming_soon.dart';
import 'package:explorer/screens/connect_laptop_screen/connect_laptop_screen.dart';
import 'package:explorer/screens/download_manager_screen/download_manager_screen.dart';
import 'package:explorer/screens/download_settings_screen/download_settings_screen.dart';
import 'package:explorer/screens/items_viewer_screen/items_viewer_screen.dart';
import 'package:explorer/screens/ext_files_screen/ext_files_screen.dart';
import 'package:explorer/screens/ext_report_screen/ext_report_screen.dart';
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
import 'package:explorer/screens/whats_app_files_screen/whats_app_files_screen.dart';
import 'package:explorer/screens/whats_app_screen/whats_app_screen.dart';
import 'package:explorer/screens/white_block_list_screen/white_block_list_screen.dart';
import 'package:explorer/screens/home_screen/home_screen.dart';
import 'package:explorer/screens/intro_screen/intro_screen.dart';
import 'package:explorer/screens/test_screen/test_screen.dart';

Map<String, Widget Function(BuildContext)> mainRoutes = {
  HomeScreen.routeName: (context) => const HomeScreen(),
  TestScreen.routeName: (context) => const TestScreen(),
  IsolateTestingScreen.routeName: (context) => const IsolateTestingScreen(),
  SizesExpScreen.routeName: (context) => const SizesExpScreen(),
  ExtReportScreen.routeName: (context) => const ExtReportScreen(),
  ExtFilesScreen.routeName: (context) => const ExtFilesScreen(),
  AnalyzerScreen.routeName: (context) => const AnalyzerScreen(),
  WhatsAppScreen.routeName: (context) => const WhatsAppScreen(),
  WhatsappFilesScreen.routeName: (context) => const WhatsappFilesScreen(),
  RecentsViewerScreen.routeName: (context) => const RecentsViewerScreen(),
  StorageCleanerScreen.routeName: (context) => const StorageCleanerScreen(),
  ItemsViewerScreen.routeName: (context) => const ItemsViewerScreen(),
  ListyScreen.routeName: (context) => const ListyScreen(),
  ListyItemViewerScreen.routeName: (context) => const ListyItemViewerScreen(),
  SettingsScreen.routeName: (context) => const SettingsScreen(),
  SelectedItemsScreen.routeName: (context) => const SelectedItemsScreen(),
  ShareScreen.routeName: (context) => const ShareScreen(),
  QrCodeViewerScreen.routeName: (context) => const QrCodeViewerScreen(),
  ScanQRCodeScreen.routeName: (context) => const ScanQRCodeScreen(),
  ShareSpaceVScreen.routeName: (context) => const ShareSpaceVScreen(),
  DownloadManagerScreen.routeName: (context) => const DownloadManagerScreen(),
  ShareSettingsScreen.routeName: (context) => const ShareSettingsScreen(),
  WhiteBlockListScreen.routeName: (context) => const WhiteBlockListScreen(),
  IntroScreen.routeName: (context) => const IntroScreen(),
  AboutUsScreen.routeName: (context) => const AboutUsScreen(),
  LaptopMessagesScreen.routeName: (context) => const LaptopMessagesScreen(),
  ConnectLaptopScreen.routeName: (context) => const ConnectLaptopScreen(),
  DownloadSetScreen.routeName: (context) => const DownloadSetScreen(),
  ConnLaptopComingSoon.routeName: (context) => const ConnLaptopComingSoon(),
};