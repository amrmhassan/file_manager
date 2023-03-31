// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/firebase_options.dart';
import 'package:explorer/helpers/hive/hive_initiator.dart';
import 'package:explorer/initiators/lang_init.dart';
import 'package:explorer/initiators/media_services_init.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:explorer/initiators/lifecycle_listeners.dart';
import 'package:explorer/initiators/main_disks.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/notifications/notification_init.dart';
import 'package:explorer/utils/theme_utils.dart';
import 'package:explorer/windows_stuff/disks_capturer.dart';
import 'package:explorer/windows_stuff/windows_size.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:firedart/firestore/firestore.dart';

import '../helpers/shared_pref_helper.dart';

class AppInit {
  static Future init() async {
    if (Platform.isAndroid) {
      await _android();
    } else {
      await _windows();
    }
  }

  static Future _android() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (kReleaseMode) {
        FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      } else {
        FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      }
    } catch (e) {
      logger.e(e);
    }

    try {
      await mediaPlayersInit();
      await HiveInitiator().setup();
      firstTimeRunApp = await SharedPrefHelper.firstTimeRunApp();
      await setThemeVariables();
      await loadCurrentLang();

      await initialDirsInit();
      initMainDisksCustomInfo();
      await initializeNotification();
      listenForLifeCycleEvents();
    } catch (e) {
      logger.e(e);
    }
  }

  static Future _windows() async {
    WidgetsFlutterBinding.ensureInitialized();
    Firestore.initialize('advanced-file-manager-8b7ab');

    await windowManager.ensureInitialized();

    try {
      await HiveInitiator().setup();
      firstTimeRunApp = await SharedPrefHelper.firstTimeRunApp();
      await setThemeVariables();
      await initWindowSize();
      await DartVLC.initialize();
      downloadFolder = (await getApplicationDocumentsDirectory()).path;
      initialDirsInitForWindows();
    } catch (e) {
      printOnDebug('Error with first time app in main() or theme variables');
    }
  }
}
