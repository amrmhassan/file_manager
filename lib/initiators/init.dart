// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/firebase_options.dart';
import 'package:explorer/helpers/hive/hive_initiator.dart';
import 'package:explorer/initiators/lang_init.dart';
import 'package:explorer/initiators/media_services_init.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:explorer/initiators/lifecycle_listeners.dart';
import 'package:explorer/initiators/main_disks.dart';
import 'package:explorer/utils/notifications/notification_init.dart';
import 'package:explorer/utils/theme_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helpers/shared_pref_helper.dart';

Future initBeforeRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kReleaseMode) {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } else {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  try {
    await HiveInitiator().setup();
    firstTimeRunApp = await SharedPrefHelper.firstTimeRunApp();
    await setThemeVariables();
    await initializeNotification();
    await initialDirsInit();
    initMainDisksCustomInfo();
    listenForLifeCycleEvents();
    await loadCurrentLang();
    //!
    await mediaPlayersInit();
  } catch (e) {
    logger.e(e);
  }
}
