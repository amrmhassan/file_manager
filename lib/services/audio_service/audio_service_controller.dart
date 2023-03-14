import 'dart:async';

import 'package:explorer/services/background_service.dart';
import 'package:explorer/services/services_constants.dart';

//? this is for the main isolate, or the UI controller using provider, sending events to the background service
class AudioServiceController {
  static void playAudio(String path, bool network, String? fileRemotePath) {
    // here play the audio from the background service
    flutterBackgroundService.invoke(ServiceActions.playAudioAction, {
      'network': network,
      'path': path,
      'fileRemotePath': fileRemotePath,
    });
  }

  static void pauseAudio() {
    // pause audio
    flutterBackgroundService.invoke(ServiceActions.pauseAudioAction);
  }

  static void seekTo(int millisecond) {
    // seek
    flutterBackgroundService
        .invoke(ServiceActions.seekToAction, {'duration': millisecond});
  }

  static Future<bool> isPlaying() {
    StreamSubscription? sub;
    Completer<bool> completer = Completer<bool>();
    flutterBackgroundService.invoke(ServiceActions.checkAudioPlaying);
    sub = flutterBackgroundService
        .on(ServiceResActions.isPlaying)
        .listen((event) {
      bool playing = event!['playing'];
      completer.complete(playing);
      sub?.cancel();
    });
    return completer.future;
  }

  static Future<Duration> getFullSongDurtion() {
    StreamSubscription? sub;
    Completer<Duration> completer = Completer<Duration>();
    flutterBackgroundService.invoke(ServiceActions.fullSongDuration);
    sub = flutterBackgroundService
        .on(ServiceResActions.setFullSongDuration)
        .listen((event) {
      int milliseconds = event!['duration'];
      completer.complete(Duration(milliseconds: milliseconds));
      sub?.cancel();
    });
    return completer.future;
  }
}
