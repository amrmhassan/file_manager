// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

Future<void> getStorageInfoHandler(
  HttpRequest request,
  HttpResponse response,
) async {
  BuildContext? context = navigatorKey.currentContext;
  if (context == null) {
    response
      ..statusCode = HttpStatus.internalServerError
      ..write('An error with context')
      ..close();
    return;
  }
  try {
    int totalSpace = await analyzerPF(context).getTotalDiskSpace();
    int freeSpace = await analyzerPF(context).getFreeDiskSpace();

    response
      ..headers.add(freeSpaceHeaderKey, freeSpace)
      ..headers.add(totalSpaceHeaderKey, totalSpace)
      ..write('Space is in headers')
      ..close();
  } catch (e) {
    response
      ..statusCode = HttpStatus.internalServerError
      ..write('An error getting free space and total space')
      ..close();
  }
}
