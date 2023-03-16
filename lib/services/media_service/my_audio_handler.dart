// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:explorer/services/media_service/audio_handlers_utils.dart';
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
        var res = audioHandlersUtils.transformEvent(event, () {
          stop();
          audioHandlersUtils.audioPlayer.stop();
        });
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
    return seek(Duration(milliseconds: audioHandlersUtils.fastForwardValue));
  }

  @override
  Future<void> rewind() {
    return seek(Duration(milliseconds: audioHandlersUtils.rewindValue));
  }
}
