import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:just_audio/just_audio.dart';

class AudioHandlersUtils {
  String? _playingFileName;
  StreamSubscription? _durationStreamSub;
  StreamSubscription? _playBackStreamSub;

  final AudioPlayer _audioPlayer = AudioPlayer();

  String? get fileName => _playingFileName;

  AudioPlayer get audioPlayer => _audioPlayer;
  Duration? _fullSongDuration;
  String? playingFilePath;

  Duration? get fullSongDuration => _fullSongDuration;

  Future playAudio(
    String path,
    MediaPlayerProvider mediaPlayerProvider, [
    bool network = false,
    String? fileRemotePath,
  ]) async {
    _durationStreamSub?.cancel();
    _playBackStreamSub?.cancel();
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

    _durationStreamSub = _audioPlayer.positionStream.listen((event) {
      mediaPlayerProvider.setCurrentSongPosition(event);
    });

    //? listening for audio playback state
    _playBackStreamSub = _audioPlayer.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        mediaPlayerProvider.stopPlaying(false);
      }
    });
  }

  PlaybackState transformEvent(PlaybackEvent event, Function onCompleted) {
    if (event.processingState == ProcessingState.completed) {
      onCompleted();
    }
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.idle,
      }[audioPlayer.processingState]!,
      playing: audioPlayer.playing,
      updatePosition: audioPlayer.position,
      bufferedPosition: audioPlayer.bufferedPosition,
      speed: audioPlayer.speed,
      queueIndex: event.currentIndex,
    );
  }

  int get fastForwardValue {
    int newMilliSecondDuration =
        (audioPlayer.position).inMilliseconds + 10 * 1000;
    if (newMilliSecondDuration >
        (_fullSongDuration ?? Duration.zero).inMilliseconds) {
      newMilliSecondDuration =
          (_fullSongDuration ?? Duration.zero).inMilliseconds;
    }
    return newMilliSecondDuration;
  }

  int get rewindValue {
    int newMilliSecondDuration =
        (audioPlayer.position).inMilliseconds - 10 * 1000;
    if (newMilliSecondDuration < 0) {
      newMilliSecondDuration = 0;
    }
    return newMilliSecondDuration;
  }
}
