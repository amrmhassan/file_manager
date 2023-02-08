//? to catch clicking the phone back button
// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/providers/settings_provider.dart';
import 'package:explorer/providers/util/analyzer_provider.dart';
import 'package:explorer/providers/util/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:explorer/providers/recent_provider.dart';
import 'package:explorer/screens/home_screen/home_screen.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

//? handle press back button
Future<bool> handlePressPhoneBackButton({
  required BuildContext context,
  required int exitCounter,
  required VoidCallback incrementExitCounter,
  required VoidCallback clearExitCounter,
  required bool sizesExplorer,
}) {
  var expProvider = Provider.of<ExplorerProvider>(context, listen: false);
  bool exit = false;
  String cp = expProvider.currentActiveDir.path;
  String ip = initialDir.path;
  if (cp == ip) {
    if (sizesExplorer) {
      return Future.delayed(Duration.zero).then((value) => true);
    }
    exitCounter++;
    incrementExitCounter();
    if (exitCounter <= 1) {
      showSnackBar(context: context, message: 'Back Again To Exit');
      exit = false;
    } else {
      exit = true;
    }
  } else {
    exit = false;
  }
  var foProviderFalse = Provider.of<FilesOperationsProvider>(
    context,
    listen: false,
  );
  expProvider.goBack(
    sizesExplorer: sizesExplorer,
    analyzerProvider: Provider.of<AnalyzerProvider>(context, listen: false),
    filesOperationsProvider: foProviderFalse,
    mediaPlayerProvider:
        Provider.of<MediaPlayerProvider>(context, listen: false),
  );
  //* to reset the exit counter after 2 seconds
  Future.delayed(Duration(seconds: 5)).then((value) {
    clearExitCounter();
  });
  return Future.delayed(Duration.zero).then((value) => exit);
}

//? to handle apply permissions callback after granting permissions
void handlePermissionsGrantedCallback(BuildContext context) async {
  var expProvider = Provider.of<ExplorerProvider>(context, listen: false);
  var settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
  var foProviderFalse = Provider.of<FilesOperationsProvider>(
    context,
    listen: false,
  );
  expProvider.setActiveDir(
    path: expProvider.currentActiveDir.path,
    filesOperationsProvider: foProviderFalse,
  );
  settingsProvider.loadAllSettings();
  var recentProvider = Provider.of<RecentProvider>(context, listen: false);
  await Provider.of<AnalyzerProvider>(context, listen: false)
      .handleAnalyzeEvent(recentProvider);
}

//? set the current active screen
void setActiveScreen(BuildContext context, int i) {
  pageController.animateToPage(
    i,
    duration: homePageViewDuration,
    curve: Curves.easeInOut,
  );
  Provider.of<ExplorerProvider>(context, listen: false).setActivePageIndex(i);
}

void handleOpenTabFromOtherScreen(
  String path,
  BuildContext context, [
  String? filePath,
]) {
  var expProviderFalse = Provider.of<ExplorerProvider>(
    context,
    listen: false,
  );
  var foProviderFalse = Provider.of<FilesOperationsProvider>(
    context,
    listen: false,
  );
  Navigator.pop(context);
  Navigator.pop(context);
  try {
    expProviderFalse.openTab(path, foProviderFalse);
  } catch (e) {
    printOnDebug('This tab already exists');
  }

  setActiveScreen(context, 1);
  if (filePath != null) {
    expProviderFalse.setViewedFilePath(filePath);
  }
}
