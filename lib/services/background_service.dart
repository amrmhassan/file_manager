import 'dart:async';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:explorer/services/audio_service/audio_service.dart';
import 'package:explorer/services/connect_laptop_service/connect_laptop_service.dart';
import 'package:explorer/services/services_constants.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:explorer/constants/global_constants.dart';

late FlutterBackgroundService flutterBackgroundService;

class BackgroundService {
  //? this will be like the router, that handles the background service calls and routes them to the right place
  @pragma('vm:entry-point')
  static void _onStart(ServiceInstance service) {
    DartPluginRegistrant.ensureInitialized();
    AudioService audioService = AudioService(service);
    ConnectLaptopService connLaptopService = ConnectLaptopService(service);
    service
      // audio service
      ..on(ServiceActions.playAudioAction).listen(audioService.playAudio)
      ..on(ServiceActions.pauseAudioAction).listen(audioService.pauseAudio)
      ..on(ServiceActions.seekToAction).listen(audioService.seekTo)
      ..on(ServiceActions.checkAudioPlaying).listen(audioService.isPlaying)
      ..on(ServiceActions.fullSongDuration)
          .listen(audioService.getFullSongDuration)
      // conn laptop service
      ..on(ServiceActions.openLaptopServer).listen(connLaptopService.openServer)
      ..on(ServiceActions.stopService).listen((event) {
        logger.i('Stopping background service');
        service.stopSelf();
      });
  }

  static Future<bool> get isRunning => flutterBackgroundService.isRunning();

  static Future initService() async {
    flutterBackgroundService = FlutterBackgroundService();

    await flutterBackgroundService.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: _onStart,
        isForegroundMode: true,
        initialNotificationTitle: 'App Running',
        notificationChannelId: 'basic_channel',
        foregroundServiceNotificationId: ServiceNotificationIDs.serviceRunning,
        autoStartOnBoot: false,
        autoStart: false,
      ),
    );
    await flutterBackgroundService.startService();
    await AwesomeNotifications().cancel(ServiceNotificationIDs.serviceRunning);
  }
}
