// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler
    with
        QueueHandler, // mix in default queue callback implementations
        SeekHandler {
  StreamSubscription? durationStreamSub;
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;
  Duration? _fullSongDuration;
  Duration? _currentDuration;
  String? playingFilePath;

  MyAudioHandler() {
    _audioPlayer.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

//? to start the audio
  void playAudio(
    String path,
    MediaPlayerProvider mediaPlayerProvider, [
    bool network = false,
    String? fileRemotePath,
  ]) async {
    if (durationStreamSub != null) {
      durationStreamSub?.cancel();
    }
    late String fileName;
    if (network) {
      fileName = getFileName(fileRemotePath!);
    } else {
      fileName = getFileName(path);
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
    durationStreamSub = _audioPlayer.positionStream.listen((event) {
      mediaPlayerProvider.setCurrentSongPosition(event);
      _currentDuration = event;
    });
    _audioPlayer.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        mediaPlayerProvider.stopPlaying(false);
      }
    });
    play();
    var item = MediaItem(
      id: path,
      title: fileName,
      duration: _fullSongDuration,
      playable: true,
      displayTitle: fileName,
    );
    mediaItem.add(item);

    // play audio here
  }

  // The most common callbacks:
  @override
  Future<void> play() async {
    // All 'play' requests from all origins route to here. Implement this
    // callback to start playing audio appropriate to your app. e.g. music.
    _audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    _audioPlayer.pause();
  }

  @override
  Future<void> stop() async {
    _audioPlayer.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    _audioPlayer.seek(position);
  }

  @override
  Future<void> skipToQueueItem(int index) async {}

  bool get isPlaying => _audioPlayer.playing;
  Duration? get getFullSongDuration => _fullSongDuration;

  @override
  Future<void> fastForward() {
    int newMilliSecondDuration =
        (_currentDuration ?? Duration.zero).inMilliseconds + 10 * 1000;
    if (newMilliSecondDuration >
        (_fullSongDuration ?? Duration.zero).inMilliseconds) {
      newMilliSecondDuration =
          (_fullSongDuration ?? Duration.zero).inMilliseconds;
    }
    return seek(Duration(milliseconds: newMilliSecondDuration));
  }

  @override
  Future<void> rewind() {
    int newMilliSecondDuration =
        (_currentDuration ?? Duration.zero).inMilliseconds - 10 * 1000;
    if (newMilliSecondDuration < 0) {
      newMilliSecondDuration = 0;
    }
    return seek(Duration(milliseconds: newMilliSecondDuration));
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    if (event.processingState == ProcessingState.completed) {
      stop();
      _audioPlayer.stop();
      logger.e('Completed');
    }
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_audioPlayer.playing) MediaControl.pause else MediaControl.play,
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
      }[_audioPlayer.processingState]!,
      playing: _audioPlayer.playing,
      updatePosition: _audioPlayer.position,
      bufferedPosition: _audioPlayer.bufferedPosition,
      speed: _audioPlayer.speed,
      queueIndex: event.currentIndex,
    );
  }
}
