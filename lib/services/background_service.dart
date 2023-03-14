import 'dart:ui';

import 'package:explorer/services/services_constants.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:explorer/constants/global_constants.dart';

late FlutterBackgroundService flutterBackgroundService;

class BackgroundService {
  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) {
    DartPluginRegistrant.ensureInitialized();
    service
      ..on(ServiceActions.stopService).listen((event) {
        logger.i('Stopping background service');
        service.stopSelf();
      })
      ..on(ServiceActions.playAudioAction).listen((event) {
        logger.i('Plying audio ');
        // play audio here
      })
      ..on(ServiceActions.pauseAudioAction).listen((event) {
        logger.i('Pausing audio ');
        // pause audio here
      });
  }

  static Future<bool> get isRunning => flutterBackgroundService.isRunning();

  static Future initService() async {
    flutterBackgroundService = FlutterBackgroundService();

    if (await flutterBackgroundService.isRunning()) {
      flutterBackgroundService.invoke(ServiceActions.stopService);
    }

    await flutterBackgroundService.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        initialNotificationTitle: 'App Running',
        notificationChannelId: 'basic_channel',
        foregroundServiceNotificationId: ServiceNotificationIDs.serviceRunning,
        initialNotificationContent: 'Starting App',
        autoStartOnBoot: false,
        autoStart: true,
      ),
    );

    flutterBackgroundService.invoke(
      'data',
      {
        'name': 'amr hassan',
      },
    );
    flutterBackgroundService.on('data_back').listen((event) {
      logger.i(event);
    });
  }
}
