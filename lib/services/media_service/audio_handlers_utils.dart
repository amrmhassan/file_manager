import 'dart:async';

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:just_audio/just_audio.dart';

class AudioHandlersUtils {
  String? _playingFileName;
  StreamSubscription? _durationStreamSub;
  final AudioPlayer _audioPlayer = AudioPlayer();

  String? get fileName => _playingFileName;

  AudioPlayer get audioPlayer => _audioPlayer;
  Duration? _fullSongDuration;
  Duration? _currentDuration;
  String? playingFilePath;

  Duration? get fullSongDuration => _fullSongDuration;

  Future playAudio(
    String path,
    MediaPlayerProvider mediaPlayerProvider, [
    bool network = false,
    String? fileRemotePath,
  ]) async {
    if (_durationStreamSub != null) {
      _durationStreamSub?.cancel();
    }
    if (network) {
      _playingFileName = getFileName(fileRemotePath!);
    } else {
      _playingFileName = getFileName(path);
    }
    if (network) {
      _fullSongDuration = await _audioPlayer.setUrl(
        path,
        headers: network
            ? {
                filePathHeaderKey: Uri.encodeComponent(fileRemotePath!),
              }
            : null,
      );
      playingFilePath = fileRemotePath;
    } else {
      _fullSongDuration = await _audioPlayer.setFilePath(path);
      playingFilePath = path;
    }

    //? setting full audio duration
    mediaPlayerProvider.setFullSongDuration(_fullSongDuration);

    //? listening for audio duration stream
    _durationStreamSub = _audioPlayer.positionStream.listen((event) {
      mediaPlayerProvider.setCurrentSongPosition(event);
      _currentDuration = event;
    });
    _audioPlayer.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        mediaPlayerProvider.stopPlaying(false);
      }
    });
  }
}
