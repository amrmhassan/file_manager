import 'package:explorer/providers/download_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
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
