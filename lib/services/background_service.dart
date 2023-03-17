// import 'dart:async';
// import 'dart:ui';

// import 'package:explorer/services/connect_laptop_service/connect_laptop_service.dart';
// import 'package:explorer/services/services_constants.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:explorer/constants/global_constants.dart';

// late FlutterBackgroundService flutterBackgroundService;

// class BackgroundService {
//   //? this will be like the router, that handles the background service calls and routes them to the right place
//   @pragma('vm:entry-point')
//   static void _onStart(ServiceInstance service) {
//     DartPluginRegistrant.ensureInitialized();

//     ConnectLaptopService connLaptopService = ConnectLaptopService(service);
//     service
//       // audio service
//       // ..on(ServiceActions.playAudioAction).listen(audioService.playAudio)
//       // ..on(ServiceActions.pauseAudioAction).listen(audioService.pauseAudio)
//       // ..on(ServiceActions.seekToAction).listen(audioService.seekTo)
//       // ..on(ServiceActions.checkAudioPlaying).listen(audioService.isPlaying)
//       // ..on(ServiceActions.fullSongDuration)
//       //     .listen(audioService.getFullSongDuration)
//       // conn laptop service
//       ..on(ServiceActions.openLaptopServer).listen(connLaptopService.openServer)
//       // stopping service
//       ..on(ServiceActions.stopService).listen((event) {
//         logger.e('Stopping background service');
//         service.stopSelf();
//       });
//   }

//   static Future<bool> get isRunning => flutterBackgroundService.isRunning();

//   static Future initService() async {
//     flutterBackgroundService = FlutterBackgroundService();

//     await flutterBackgroundService.configure(
//       iosConfiguration: IosConfiguration(),
//       androidConfiguration: AndroidConfiguration(
//         onStart: _onStart,
//         isForegroundMode: false,
//         initialNotificationContent: 'App Running',
//         initialNotificationTitle: 'File Manager',
//         notificationChannelId: 'basic_channel',
//         foregroundServiceNotificationId: ServiceNotificationIDs.serviceRunning,
//         autoStartOnBoot: false,
//         autoStart: true,
//       ),
//     );
//   }
// }
