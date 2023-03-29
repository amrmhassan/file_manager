import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:explorer/providers/beacon_provider.dart';
import 'package:explorer/providers/language_provider.dart';
import 'package:explorer/providers/permissions_provider.dart';
import 'package:explorer/providers/search_provider.dart';
import 'package:explorer/providers/connect_laptop_provider.dart';
import 'package:explorer/providers/download_provider.dart';
import 'package:explorer/providers/quick_send_provider.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/children_info_provider.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/providers/listy_provider.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:explorer/providers/recent_provider.dart';
import 'package:explorer/providers/theme_provider.dart';
import 'package:explorer/providers/thumbnail_provider.dart';
import 'package:explorer/providers/settings_provider.dart';

List<SingleChildWidget> mainProviders = [
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
  ChangeNotifierProvider(create: (ctx) => SearchProvider()),
  ChangeNotifierProvider(create: (ctx) => LanguageProvider()),
  ChangeNotifierProvider(create: (ctx) => PermissionProvider()),
  ChangeNotifierProvider(create: (ctx) => BeaconProvider()),
];
