import 'dart:async';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/services/services_constants.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:just_audio/just_audio.dart';

//? this is for controlling the background action, receiving events from the forground UI and execute it
class AudioService {
  ServiceInstance service;
  AudioService(this.service);

  StreamSubscription? durationStreamSub;
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;

  void playAudio(Map<String, dynamic>? event) async {
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
    });
    _audioPlayer.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        service.invoke(ServiceResActions.audioFinished);
        logger.i('song finished');
      }
    });
    await _audioPlayer.play();

    // play audio here
  }

  void pauseAudio(Map<String, dynamic>? event) {
    logger.i('Pausing audio ');
    // pause audio here
    _audioPlayer.pause();
  }

  void seekTo(Map<String, dynamic>? event) {
    int milliseconds = event!['duration'];
    _audioPlayer.seek(Duration(milliseconds: milliseconds));
  }

  void isPlaying(event) {
    service
        .invoke(ServiceResActions.isPlaying, {'playing': _audioPlayer.playing});
  }
}