// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:explorer/services/media_service/my_media_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

class MyTestAudioService extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  //? video stuff
  VideoPlayerController? videoPlayerController;
  PlayingMediaType? playingMediaType;
  //? video stuff
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);

  MyTestAudioService() {
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    // _listenForSequenceStateChanges();
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    String path = mediaItem.extras!['path'] as String;
    bool network = mediaItem.extras!['network'] as bool;
    String? fileRemotePath = mediaItem.extras!['fileRemotePath'] as String?;

    if (network) {
      return AudioSource.uri(
        Uri.parse(path),
        headers: {
          KHeaders.filePathHeaderKey: Uri.encodeComponent(fileRemotePath!),
        },
        tag: mediaItem,
      );
    } else {
      return AudioSource.file(
        path,
        tag: mediaItem,
      );
    }
  }

  @override
  Future<void> play() async {
    if (playingMediaType == PlayingMediaType.audio) {
      _player.play();
    } else if (playingMediaType == PlayingMediaType.video) {
      videoPlayerController!.play();
    }
  }

  @override
  Future<void> pause() async {
    if (playingMediaType == PlayingMediaType.audio) {
      _player.pause();
    } else if (playingMediaType == PlayingMediaType.video) {
      videoPlayerController!.pause();
    }
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> removeQueueItemAt(int index) async {
    // manage Just Audio
    _playlist.removeAt(index);

    // notify system
    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    logger.i('adding media to queue');
    queue.add([]);
    _playlist.clear();
    playingMediaType = mediaItem.extras!['mediaType'] == 'audio'
        ? PlayingMediaType.audio
        : PlayingMediaType.video;
    if (playingMediaType == PlayingMediaType.audio) {
      // manage Just Audio
      final audioSource = _createAudioSource(mediaItem);
      if (_playlist.length > 0) {
        removeQueueItemAt(0);
      }
      _playlist.add(audioSource);
    }

    // notify system
    final newQueue = queue.value..add(mediaItem);
    logger.i(mediaItem);
    queue.add(newQueue);
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      _player.setShuffleModeEnabled(false);
    } else {
      await _player.shuffle();
      _player.setShuffleModeEnabled(true);
    }
  }

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'dispose') {
      await _player.dispose();
      super.stop();
    }
  }

  @override
  Future<void> stop() async {
    if (playingMediaType == null) return;
    queue.add([]);
    if (playingMediaType == PlayingMediaType.audio) {
      await _player.stop();
      _playlist.clear();
    } else if (playingMediaType == PlayingMediaType.video &&
        videoPlayerController != null) {
      videoPlayerController!.pause();
    }

    logger.e('stopping media ${_player.playing}');
    seek(Duration.zero);
    playingMediaType = null;

    return super.stop();
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    if (_player.shuffleModeEnabled) {
      index = _player.shuffleIndices![index];
    }
    _player.seek(Duration.zero, index: index);
  }

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  Future<void> _loadEmptyPlaylist() async {
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      print("Error: $e");
    }
  }

  // void _listenForSequenceStateChanges() {
  //   _player.sequenceStateStream.listen((SequenceState? sequenceState) {
  //     final sequence = sequenceState?.effectiveSequence;
  //     if (sequence == null || sequence.isEmpty) return;
  //     final items = sequence.map((source) => source.tag as MediaItem);
  //     queue.add(items.toList());
  //   });
  // }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      mediaItem.add(playlist[index]);
    });
  }

  @override
  Future<void> onNotificationDeleted() {
    logger.e('onNotificationDeleted');
    return super.onNotificationDeleted();
  }

  @override
  Future<void> onTaskRemoved() {
    logger.e('onTaskRemoved');
    return super.onTaskRemoved();
  }

  @override
  Future<void> setSpeed(double speed) {
    if (playingMediaType == PlayingMediaType.video) {
      videoPlayerController!.setPlaybackSpeed(speed);
    }
    return super.setSpeed(speed);
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      var index = _player.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.rewind,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.fastForward,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[_player.loopMode]!,
        shuffleMode: (_player.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  Future<void> playVideo(
    MediaItem mediaItem,
    MediaPlayerProvider mediaPlayerProvider,
    Function(VideoPlayerController) durationListener,
  ) {
    bool videoStopped = false;
    Completer completer = Completer();
    String path = mediaItem.extras!['path'] as String;
    bool network = mediaItem.extras!['network'] as bool;
    String? fileRemotePath = mediaItem.extras!['fileRemotePath'] as String?;

    videoPlayerController = VideoPlayerController.network(path,
        httpHeaders: network
            ? {KHeaders.filePathHeaderKey: Uri.encodeComponent(fileRemotePath!)}
            : {},
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: true,
        ))
      ..initialize().then((value) {
        playingMediaType = PlayingMediaType.video;
        Duration fullDuration = videoPlayerController!.value.duration;
        MediaItem editedMediaItem = mediaItem.copyWith(duration: fullDuration);

        completer.complete();
        mediaPlayerProvider.onInitVideo(videoPlayerController!, network);
        addQueueItem(editedMediaItem);

        // final newQueue = queue.value..clear();
        // newQueue.add(editedMediaItem);
        // queue.add(newQueue);
        // logger.i(queue.value.first.title);
        // logger.e(queue.value.length);
      })
      ..play()
      ..addListener(() {
        _runVideoListen(videoPlayerController!);
        durationListener(videoPlayerController!);
        if (videoPlayerController!.value.duration.inMilliseconds ==
                videoPlayerController!.value.position.inMilliseconds &&
            videoPlayerController!.value.position.inMilliseconds != 0 &&
            videoPlayerController!.value.duration.inMilliseconds != 0) {
          if (videoStopped) return;
          videoStopped = true;
          //the video stopped or completed
          mediaPlayerProvider.closeVideo();
          videoPlayerController!.removeListener(() {});
          videoPlayerController!.dispose();
          videoPlayerController == null;
          stop();
        }
      });
    return completer.future;
  }

  void _runVideoListen(VideoPlayerController controller) async {
    final playing = controller.value.isPlaying;

    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.rewind,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[ProcessingState.ready]!,
      playing: playing,
      updatePosition: controller.value.position,
      speed: controller.value.playbackSpeed,
      queueIndex: 1,
      bufferedPosition: controller.value.position,
    ));
  }
}
