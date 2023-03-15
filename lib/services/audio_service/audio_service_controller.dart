import 'dart:async';

import 'package:audio_service/audio_service.dart';
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
  Duration? fullSongDuration;
  String? playingFilePath;

  void playAudio(
    String path,
    MediaPlayerProvider mediaPlayerProvider, [
    bool network = false,
    String? fileRemotePath,
  ]) async {
    if (durationStreamSub != null) {
      durationStreamSub?.cancel();
    }

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
    mediaPlayerProvider.setFullSongDuration(fullSongDuration);

    //? listening for audio duration stream
    durationStreamSub = _audioPlayer.positionStream.listen((event) {
      mediaPlayerProvider.setCurrentSongPosition(event);
    });
    _audioPlayer.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        mediaPlayerProvider.pausePlaying(false);
      }
    });
    play();

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
  Duration? get getFullSongDurtion => fullSongDuration;
}
