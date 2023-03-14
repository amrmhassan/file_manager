import 'dart:async';
import 'dart:ui';

import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/services/services_constants.dart';
import 'package:explorer/utils/duration_utils.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:just_audio/just_audio.dart';

late FlutterBackgroundService flutterBackgroundService;
StreamSubscription? durationStreamSub;
AudioPlayer _audioPlayer = AudioPlayer();

class BackgroundService {
  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) {
    DartPluginRegistrant.ensureInitialized();
    service
      ..on(ServiceActions.playAudioAction).listen((event) async {
        if (durationStreamSub != null) {
          durationStreamSub?.cancel();
        }
        bool network = event!['network'];
        String path = event['path'];
        String? fileRemotePath = event['fileRemotePath'];

        logger.i('Plying audio ');
        Duration? fullSongDuration;
        if (network) {
          fullSongDuration = await _audioPlayer.setUrl(
            path,
            headers: network
                ? {
                    filePathHeaderKey: Uri.encodeComponent(fileRemotePath!),
                  }
                : null,
          );
        } else {
          fullSongDuration = await _audioPlayer.setFilePath(path);
        }

        //? setting full audio duration
        service.invoke(ServiceResActions.setFullSongDuration,
            {'duration': fullSongDuration?.inMilliseconds});

        //? listening for audio duration stream
        durationStreamSub = _audioPlayer.positionStream.listen((event) {
          service.invoke(ServiceResActions.setCurrentAudioDuration,
              {'duration': event.inMilliseconds});
          print(durationToString(event));
        });
        _audioPlayer.playerStateStream.listen((event) {
          if (event.processingState == ProcessingState.completed) {
            service.invoke(ServiceResActions.audioFinished);
            logger.i('song finished');
          }
        });
        await _audioPlayer.play();

        // play audio here
      })
      ..on(ServiceActions.pauseAudioAction).listen((event) {
        logger.i('Pausing audio ');
        // pause audio here
        _audioPlayer.pause();
      })
      ..on(ServiceActions.seekToAction).listen((event) {
        int milliseconds = event!['duration'];
        _audioPlayer.seek(Duration(milliseconds: milliseconds));
      })
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
  }
}
