import 'dart:async';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/services/background_service.dart';
import 'package:explorer/services/services_constants.dart';
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
    if (AppLifecycleState.detached == state) {
      flutterBackgroundService.invoke(ServiceActions.stopService);
    }
    super.didChangeAppLifecycleState(state);
  }
}
