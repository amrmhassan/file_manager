import 'package:explorer/services/background_service.dart';
import 'package:explorer/services/services_constants.dart';

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
}
