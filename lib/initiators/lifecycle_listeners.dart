import 'dart:async';
import 'dart:io';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:flutter/material.dart';

void listenForLifeCycleEvents() {
  WidgetsBinding.instance.addObserver(
    LifecycleEventHandler(
      detachedCallBack: () {
        logger.i('App killed');
      },
      resumeCallBack: () async {
        logger.i('resume...');
      },
    ),
  );
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({this.resumeCallBack, this.detachedCallBack});

  final FutureOr resumeCallBack;
  final FutureOr detachedCallBack;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.i(state);
    if (state == AppLifecycleState.detached) {
      logger.e('App UI Closed');
      // flutterBackgroundService.invoke(ServiceActions.stopService);

      File loggingTestFile = File('sdcard/detachEvents.txt');
      if (!loggingTestFile.existsSync()) {
        loggingTestFile.createSync();
      }
      bool contextExist = navigatorKey.currentContext != null;
      var raf = loggingTestFile.openSync(mode: FileMode.append);
      String data =
          'App Detached\n${contextExist ? "context exist" : "no context"}\n${DateTime.now().toIso8601String()}\n-----------------------\n';
      raf.writeStringSync(data);
      raf.closeSync();
    }
    super.didChangeAppLifecycleState(state);
  }
}
