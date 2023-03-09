// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class BackgroundService {
  static void runAudioService(
    Function(
      String path,
      bool network,
      String? fileRemotePath,
    )
        handlePlayAudio,
    String path,
    bool network,
    String? fileRemotePath,
    Function(ServiceInstance i) setService,
  ) async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: audioService,

        // auto start service
        autoStart: false,
        isForegroundMode: true,
        autoStartOnBoot: false,
        notificationChannelId: 'basic_channel',
        initialNotificationTitle: 'My SERVICE',
        initialNotificationContent: 'Initializing',
        foregroundServiceNotificationId:
            BackgroundServicesConstants.notificationId,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
      ),
    );
    AwesomeNotifications().cancel(BackgroundServicesConstants.notificationId);
  }

  static void runVideo() {}
}

class BackgroundServicesConstants {
  static const int notificationId = 888;
}

@pragma('vm:entry-point')
void audioService(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();
  service.on('stopService').listen((event) {
    logger.e('stopping service');
  });
}
