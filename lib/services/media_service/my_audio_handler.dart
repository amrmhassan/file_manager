// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:explorer/services/media_service/audio_handlers_utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

enum PlayingMediaType {
  audio,
  video,
}

class MyAudioHandler extends BaseAudioHandler
    with
        QueueHandler, // mix in default queue callback implementations
        SeekHandler {
  VideoPlayerController? videoPlayerController;
  AudioHandlersUtils audioHandlersUtils = AudioHandlersUtils();

  StreamSubscription? _playBackStream;

  String? playingFileName;
  Duration fullMediaDuration = Duration.zero;
  PlayingMediaType? playingMediaType;

  void updateFullMediaDuration(Duration d) {
    fullMediaDuration = d;
  }

//? to start the audio
  void playMedia(
    PlayingMediaType mediaType,
    String path,
    MediaPlayerProvider mediaPlayerProvider, [
    bool network = false,
    String? fileRemotePath,
  ]) async {
    playingMediaType = mediaType;

    if (playingMediaType == PlayingMediaType.audio) {
      await audioHandlersUtils.playAudio(
        path,
        mediaPlayerProvider,
        network,
        fileRemotePath,
      );
      playingFileName = audioHandlersUtils.fileName;
      fullMediaDuration = audioHandlersUtils.fullSongDuration ?? Duration.zero;
      await _playBackStream?.cancel();
      _playBackStream =
          audioHandlersUtils.audioPlayer.playbackEventStream.listen((event) {
        var res = _transformEvent(event);
        playbackState.add(res);
      });
    }
    play();
    var item = MediaItem(
      id: path,
      title: playingFileName ?? 'No Name',
      duration: fullMediaDuration,
      playable: true,
      displayTitle: playingFileName,
    );
    mediaItem.add(item);

    // play audio here
  }

  // The most common callbacks:
  @override
  Future<void> play() async {
    // All 'play' requests from all origins route to here. Implement this
    // callback to start playing audio appropriate to your app. e.g. music.
    audioHandlersUtils.audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    audioHandlersUtils.audioPlayer.pause();
  }

  @override
  Future<void> stop() async {
    playingMediaType = null;
    audioHandlersUtils.audioPlayer.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    audioHandlersUtils.audioPlayer.seek(position);
  }

  @override
  Future<void> skipToQueueItem(int index) async {}

  bool get isPlaying => audioHandlersUtils.audioPlayer.playing;
  Duration? get getFullSongDuration => fullMediaDuration;

  @override
  Future<void> fastForward() {
    int newMilliSecondDuration =
        (audioHandlersUtils.audioPlayer.position).inMilliseconds + 10 * 1000;
    if (newMilliSecondDuration > (fullMediaDuration).inMilliseconds) {
      newMilliSecondDuration = (fullMediaDuration).inMilliseconds;
    }
    return seek(Duration(milliseconds: newMilliSecondDuration));
  }

  @override
  Future<void> rewind() {
    int newMilliSecondDuration =
        (audioHandlersUtils.audioPlayer.position).inMilliseconds - 10 * 1000;
    if (newMilliSecondDuration < 0) {
      newMilliSecondDuration = 0;
    }
    return seek(Duration(milliseconds: newMilliSecondDuration));
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    if (event.processingState == ProcessingState.completed) {
      stop();
      audioHandlersUtils.audioPlayer.stop();
      logger.e('Completed');
    }
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (audioHandlersUtils.audioPlayer.playing)
          MediaControl.pause
        else
          MediaControl.play,
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
      }[audioHandlersUtils.audioPlayer.processingState]!,
      playing: audioHandlersUtils.audioPlayer.playing,
      updatePosition: audioHandlersUtils.audioPlayer.position,
      bufferedPosition: audioHandlersUtils.audioPlayer.bufferedPosition,
      speed: audioHandlersUtils.audioPlayer.speed,
      queueIndex: event.currentIndex,
    );
  }
}
