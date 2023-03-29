import 'package:explorer/providers/beacon_provider.dart';
import 'package:explorer/providers/connect_laptop_provider.dart';
import 'package:explorer/providers/download_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/providers/language_provider.dart';
import 'package:explorer/providers/listy_provider.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:explorer/providers/permissions_provider.dart';
import 'package:explorer/providers/quick_send_provider.dart';
import 'package:explorer/providers/recent_provider.dart';
import 'package:explorer/providers/search_provider.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//? server provider
ServerProvider serverPF(BuildContext context) {
  return Provider.of<ServerProvider>(context, listen: false);
}

ServerProvider serverP(BuildContext context) {
  return Provider.of<ServerProvider>(context);
}

//? share provider

ShareProvider sharePF(BuildContext context) {
  return Provider.of<ShareProvider>(context, listen: false);
}

ShareProvider shareP(BuildContext context) {
  return Provider.of<ShareProvider>(context);
}

//? download provider
DownloadProvider downPF(BuildContext context) {
  return Provider.of<DownloadProvider>(context, listen: false);
}

DownloadProvider downP(BuildContext context) {
  return Provider.of<DownloadProvider>(context);
}

//? shareItemsExplorerProvider
ShareItemsExplorerProvider shareExpPF(BuildContext context) {
  return Provider.of<ShareItemsExplorerProvider>(context, listen: false);
}

ShareItemsExplorerProvider shareExpP(BuildContext context) {
  return Provider.of<ShareItemsExplorerProvider>(context);
}

//? media player providers
MediaPlayerProvider mpPF(BuildContext context) {
  return Provider.of<MediaPlayerProvider>(context, listen: false);
}

MediaPlayerProvider mpP(BuildContext context) {
  return Provider.of<MediaPlayerProvider>(context);
}

//? files operations providers
FilesOperationsProvider foPF(BuildContext context) {
  return Provider.of<FilesOperationsProvider>(context, listen: false);
}

FilesOperationsProvider foP(BuildContext context) {
  return Provider.of<FilesOperationsProvider>(context);
}

//? explorer provider providers
ExplorerProvider expPF(BuildContext context) {
  return Provider.of<ExplorerProvider>(context, listen: false);
}

ExplorerProvider expP(BuildContext context) {
  return Provider.of<ExplorerProvider>(context);
}

//? quick share provider providers
QuickSendProvider quickSPF(BuildContext context) {
  return Provider.of<QuickSendProvider>(context, listen: false);
}

QuickSendProvider quickSP(BuildContext context) {
  return Provider.of<QuickSendProvider>(context);
}

//? analyzer provider providers
AnalyzerProvider analyzerPF(BuildContext context) {
  return Provider.of<AnalyzerProvider>(context, listen: false);
}

AnalyzerProvider analyzerP(BuildContext context) {
  return Provider.of<AnalyzerProvider>(context);
}

//? connect laptop provider
ConnectLaptopProvider connectLaptopPF(BuildContext context) {
  return Provider.of<ConnectLaptopProvider>(context, listen: false);
}

ConnectLaptopProvider connectLaptopP(BuildContext context) {
  return Provider.of<ConnectLaptopProvider>(context);
}

//? listy provider
ListyProvider listyPF(BuildContext context) {
  return Provider.of<ListyProvider>(context, listen: false);
}

ListyProvider listyP(BuildContext context) {
  return Provider.of<ListyProvider>(context);
}

//? listy provider
MediaPlayerProvider mediaPF(BuildContext context) {
  return Provider.of<MediaPlayerProvider>(context, listen: false);
}

MediaPlayerProvider mediaP(BuildContext context) {
  return Provider.of<MediaPlayerProvider>(context);
}

//? recent provider
RecentProvider recentPF(BuildContext context) {
  return Provider.of<RecentProvider>(context, listen: false);
}

RecentProvider recentP(BuildContext context) {
  return Provider.of<RecentProvider>(context);
}

//? recent provider
SearchProvider searchPF(BuildContext context) {
  return Provider.of<SearchProvider>(context, listen: false);
}

SearchProvider searchP(BuildContext context) {
  return Provider.of<SearchProvider>(context);
}

//? language provider
LanguageProvider langPF(BuildContext context) {
  return Provider.of<LanguageProvider>(context, listen: false);
}

LanguageProvider langP(BuildContext context) {
  return Provider.of<LanguageProvider>(context);
}

//? permissions provider
PermissionProvider permissionsPF(BuildContext context) {
  return Provider.of<PermissionProvider>(context, listen: false);
}

PermissionProvider permissionsP(BuildContext context) {
  return Provider.of<PermissionProvider>(context);
}

//? beacon provider
BeaconProvider beaconPF(BuildContext context) {
  return Provider.of<BeaconProvider>(context, listen: false);
}

BeaconProvider beaconP(BuildContext context) {
  return Provider.of<BeaconProvider>(context);
}
