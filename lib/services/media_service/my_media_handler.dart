// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:explorer/services/media_service/audio_handlers_utils.dart';
import 'package:explorer/services/media_service/video_handlers_utils.dart';
import 'package:video_player/video_player.dart';

enum PlayingMediaType {
  audio,
  video,
}

class MyMediaHandler extends BaseAudioHandler
    with
        QueueHandler, // mix in default queue callback implementations
        SeekHandler {
  VideoPlayerController? videoPlayerController;
  AudioHandlersUtils audioHandlersUtils = AudioHandlersUtils();
  VideoHandlersUtils videoHandlersUtils = VideoHandlersUtils();

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
    await _playBackStream?.cancel();

    if (playingMediaType == PlayingMediaType.audio) {
      await audioHandlersUtils.playAudio(
        path,
        mediaPlayerProvider,
        network,
        fileRemotePath,
      );
      playingFileName = audioHandlersUtils.fileName;
      fullMediaDuration = audioHandlersUtils.fullSongDuration ?? Duration.zero;
      _playBackStream =
          audioHandlersUtils.audioPlayer.playbackEventStream.listen((event) {
        var res = audioHandlersUtils.transformEvent(event, () {
          stop();
          audioHandlersUtils.audioPlayer.stop();
        });
        playbackState.add(res);
      });
    } else if (playingMediaType == PlayingMediaType.video) {
      videoHandlersUtils.playVideo(
        path,
        videoPlaybackStateListener,
        () {
          stop();
          audioHandlersUtils.audioPlayer.stop();
        },
        mediaPlayerProvider,
        network,
        fileRemotePath,
      );
      playingFileName = videoHandlersUtils.fileName;
      fullMediaDuration =
          (await videoHandlersUtils.fullVideoDuration) ?? Duration.zero;
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

  void videoPlaybackStateListener(VideoState event) {
    var res = videoHandlersUtils.transformEvent(event, () {
      stop();
      videoHandlersUtils.closeVideo();
    });
    playbackState.add(res);
  }

  @override
  Future<void> onNotificationDeleted() async {
    await stop();
    return super.onNotificationDeleted();
  }

  // The most common callbacks:
  @override
  Future<void> play() async {
    // All 'play' requests from all origins route to here. Implement this
    // callback to start playing audio appropriate to your app. e.g. music.
    if (playingMediaType == PlayingMediaType.audio) {
      audioHandlersUtils.audioPlayer.play();
    } else if (playingMediaType == PlayingMediaType.video) {
      videoHandlersUtils.playOrResume();
    }
    super.play();
  }

  @override
  Future<void> pause() async {
    try {
      if (playingMediaType == PlayingMediaType.audio) {
        audioHandlersUtils.audioPlayer.pause();
      } else if (playingMediaType == PlayingMediaType.video) {
        videoHandlersUtils.pause();
      }
    } catch (e) {
      logger.e(e);
    }
    super.pause();
  }

  @override
  Future<void> setSpeed(double speed) {
    if (playingMediaType == PlayingMediaType.video) {
      videoHandlersUtils.setSpeed(speed);
    }

    return super.setSpeed(speed);
  }

  void toggleVideoMuted(bool muted) {
    videoHandlersUtils.setMuted(muted);
  }

  @override
  Future<void> stop() async {
    if (playingMediaType == PlayingMediaType.audio) {
      audioHandlersUtils.audioPlayer.stop();
    } else if (playingMediaType == PlayingMediaType.video) {
      videoHandlersUtils.closeVideo();
    }
    playingMediaType = null;
    super.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    if (playingMediaType == PlayingMediaType.audio) {
      audioHandlersUtils.audioPlayer.seek(position);
    } else if (playingMediaType == PlayingMediaType.video) {
      videoHandlersUtils.videoPlayerController!.seekTo(position);
    }
    super.seek(position);
  }

  bool get isPlaying => audioHandlersUtils.audioPlayer.playing;
  Duration? get getFullSongDuration => fullMediaDuration;

  @override
  Future<void> fastForward() {
    if (playingMediaType == PlayingMediaType.audio) {
      return seek(Duration(milliseconds: audioHandlersUtils.fastForwardValue));
    } else {
      return seek(Duration(milliseconds: videoHandlersUtils.fastForwardValue));
    }
  }

  @override
  Future<void> rewind() {
    if (playingMediaType == PlayingMediaType.audio) {
      return seek(Duration(milliseconds: audioHandlersUtils.rewindValue));
    } else {
      return seek(Duration(milliseconds: videoHandlersUtils.rewindValue));
    }
  }
}
