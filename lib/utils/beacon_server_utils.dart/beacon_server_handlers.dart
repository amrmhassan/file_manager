import 'dart:io';

import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

// beacon server handlers
class BSH {
  static void getServerName(
    HttpRequest request,
    HttpResponse response,
  ) {
    BuildContext? context = navigatorKey.currentContext;
    if (context == null) {
      response
        ..statusCode = HttpStatus.internalServerError
        ..write('An error with context')
        ..close();
      return;
    }
    ShareProvider shareProvider = sharePF(context);
    String myName = shareProvider.myName;
    response
      ..write(myName)
      ..close();
  }

  static void getServerConnLink(
    HttpRequest request,
    HttpResponse response,
  ) {
    BuildContext? context = navigatorKey.currentContext;
    if (context == null) {
      response
        ..statusCode = HttpStatus.internalServerError
        ..write('An error with context')
        ..close();
      return;
    }
    try {
      ServerProvider serverProvider = serverPF(context);
      String connLink = serverProvider.myConnLink!;

      response
        ..write(connLink)
        ..close();
    } catch (e) {
      response
        ..statusCode = HttpStatus.internalServerError
        ..write('error occurred ')
        ..close();
    }
  }
}
