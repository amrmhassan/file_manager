//? to catch clicking the phone back button
// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

Future<bool> handlePressPhoneBackButton({
  required BuildContext context,
  required int exitCounter,
  required VoidCallback incrmentExitCounter,
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
    incrmentExitCounter();
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
  );
  //* to reset the exit counter after 2 seconds
  Future.delayed(Duration(seconds: 5)).then((value) {
    clearExitCounter();
  });
  return Future.delayed(Duration.zero).then((value) => exit);
}
