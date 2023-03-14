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
    Completer<bool> completer = Completer<bool>();
    flutterBackgroundService.invoke(ServiceActions.checkAudioPlaying);
    flutterBackgroundService.on(ServiceResActions.isPlaying).listen((event) {
      bool playing = event!['playing'];
      completer.complete(playing);
    });
    return completer.future;
  }
}
