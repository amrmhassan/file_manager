import 'dart:async';

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/services/services_constants.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:just_audio/just_audio.dart';

//? this is for controlling the background action, receiving events from the forground UI and execute it
class AudioService {
  final ServiceInstance _service;
  AudioService(this._service);

  StreamSubscription? durationStreamSub;
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;
  Duration? fullSongDuration;
  String? playingFilePath;

  void playAudio(Map<String, dynamic>? event) async {
    if (durationStreamSub != null) {
      durationStreamSub?.cancel();
    }
    bool network = event!['network'];
    String path = event['path'];
    String? fileRemotePath = event['fileRemotePath'];

    logger.i('Plying audio ');
    if (network) {
      fullSongDuration = await _audioPlayer.setUrl(
        path,
        headers: network
            ? {
                filePathHeaderKey: Uri.encodeComponent(fileRemotePath!),
              }
            : null,
      );
      playingFilePath = fileRemotePath;
    } else {
      fullSongDuration = await _audioPlayer.setFilePath(path);
      playingFilePath = path;
    }

    //? setting full audio duration
    _service.invoke(ServiceResActions.setFullSongDuration,
        {'duration': fullSongDuration?.inMilliseconds});

    //? listening for audio duration stream
    durationStreamSub = _audioPlayer.positionStream.listen((event) {
      _service.invoke(ServiceResActions.setCurrentAudioDuration,
          {'duration': event.inMilliseconds});
    });
    _audioPlayer.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        _service.invoke(ServiceResActions.audioFinished);
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
    _service
        .invoke(ServiceResActions.isPlaying, {'playing': _audioPlayer.playing});
  }

  void getFullSongDuration(event) {
    _service.invoke(ServiceResActions.setFullSongDuration,
        {'duration': fullSongDuration?.inMilliseconds});
  }

  void getSongName(event) {
    _service.invoke(ServiceResActions.getSongPath,
        {'name': getFileName(playingFilePath ?? '')});
  }
}
