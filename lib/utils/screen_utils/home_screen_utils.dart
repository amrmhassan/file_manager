//? to catch clicking the phone back button
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/providers/settings_provider.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:explorer/providers/recent_provider.dart';
import 'package:explorer/screens/home_screen/home_screen.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:move_to_background/move_to_background.dart';

//? handle press back button
Future<bool> handlePressPhoneBackButton({
  required BuildContext context,
  required int exitCounter,
  required VoidCallback incrementExitCounter,
  required VoidCallback clearExitCounter,
  required bool sizesExplorer,
}) async {
  var expProvider = Provider.of<ExplorerProvider>(context, listen: false);
  var foProviderFalse = Provider.of<FilesOperationsProvider>(
    context,
    listen: false,
  );

  bool canGoBack = expProvider.goBack(
    sizesExplorer: sizesExplorer,
    analyzerProvider: Provider.of<AnalyzerProvider>(context, listen: false),
    filesOperationsProvider: foProviderFalse,
    mediaPlayerProvider:
        Provider.of<MediaPlayerProvider>(context, listen: false),
  );

  bool exit = false;
  if (!canGoBack) {
    if (sizesExplorer) {
      return Future.value(true);
    }
    exitCounter++;
    incrementExitCounter();
    if (exitCounter <= 1) {
      showSnackBar(context: context, message: 'Back Again To Exit');
      exit = false;
    } else {
      await MoveToBackground.moveTaskToBack();
      // i made this false, to prevent the app from being closed when clicking the back button

      exit = false;
    }
  } else {
    exit = false;
  }

  //* to reset the exit counter after 2 seconds
  Future.delayed(Duration(seconds: 5)).then((value) {
    clearExitCounter();
  });
  return Future.value(exit);
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
  // skip analyzing part for windows
  //# windows
  if (Platform.isWindows) return;

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
  Navigator.popUntil(
      context, (route) => route.settings.name == HomeScreen.routeName);
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
