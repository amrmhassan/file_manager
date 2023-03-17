import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:video_player/video_player.dart';

enum VideoState {
  idle,
  ready,
  buffering,
  completed,
  loading,
}

class VideoHandlersUtils {
  String? _playingFileName;
  bool isVideoPlaying = false;
  late MediaPlayerProvider _mediaPlayerProvider;
  VideoPlayerController? _videoPlayerController;

  String? get fileName => _playingFileName;

  VideoPlayerController? get videoPlayerController => _videoPlayerController;
  Duration? _fullVideoDuration;
  String? playingFilePath;
  VideoState videoState = VideoState.idle;
  late Completer<Duration?> fullVideoDurationCompleter;

  Future<Duration?> get fullVideoDuration => fullVideoDurationCompleter.future;

  Future playVideo(
    String path,
    Function(VideoState event) videoPlaybackStateListener,
    Function() onCompleted,
    MediaPlayerProvider mediaPlayerProvider, [
    bool network = false,
    String? fileRemotePath,
  ]) async {
    _mediaPlayerProvider = mediaPlayerProvider;
    closeVideo();
    fullVideoDurationCompleter = Completer<Duration?>();

    videoState = VideoState.loading;

    if (network) {
      playingFilePath = fileRemotePath;
      _playingFileName = getFileName(fileRemotePath!);
    } else {
      playingFilePath = path;
      _playingFileName = getFileName(path);
    }
    _videoPlayerController = VideoPlayerController.network(path,
        httpHeaders: network
            ? {
                filePathHeaderKey: Uri.encodeComponent(fileRemotePath!),
              }
            : {},
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: true,
        ))
      ..initialize().then((value) {
        _fullVideoDuration ??= _videoPlayerController!.value.duration;
        if (!fullVideoDurationCompleter.isCompleted) {
          fullVideoDurationCompleter.complete(_fullVideoDuration);
        }
        mediaPlayerProvider.onInitVideo(_videoPlayerController!, network);
      })
      ..play()
      ..addListener(() async {
        videoState = _videoPlayerController!.value.isPlaying
            ? VideoState.ready
            : _videoPlayerController!.value.isBuffering
                ? VideoState.buffering
                : VideoState.ready;

        mediaPlayerProvider.videoPositionListener(_videoPlayerController!);
        // videoPosition = videoPlayerController?.value.position ?? Duration.zero;
        // _bufferedParts = videoPlayerController?.value.buffered ?? [];
        // isBuffering = videoPlayerController?.value.isBuffering ?? false;

        var duration = _videoPlayerController?.value.duration.inMilliseconds;
        var position = _videoPlayerController?.value.position.inMilliseconds;
        // notifyListeners();
        if ((duration == position) &&
            duration != null &&
            position != null &&
            duration != 0 &&
            position != 0) {
          //* this means it stopped playing cause it's duration finished
          closeVideo();
        }
        videoPlaybackStateListener(videoState);
      });
    isVideoPlaying = true;
  }

  PlaybackState transformEvent(VideoState event, Function onCompleted) {
    if (event == VideoState.completed) {
      onCompleted();
      return PlaybackState();
    }
    //! i added this check if it doesn't work or not
    videoState = _videoPlayerController == null ? VideoState.idle : videoState;

    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_videoPlayerController?.value.isPlaying ?? false)
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
        VideoState.idle: AudioProcessingState.idle,
        VideoState.loading: AudioProcessingState.loading,
        VideoState.buffering: AudioProcessingState.buffering,
        VideoState.ready: AudioProcessingState.ready,
        VideoState.completed: AudioProcessingState.idle,
      }[event]!,
      playing: _videoPlayerController?.value.isPlaying ?? false,
      updatePosition: _videoPlayerController?.value.position ?? Duration.zero,
      bufferedPosition: _videoPlayerController?.value.position ?? Duration.zero,
      speed: _videoPlayerController?.value.playbackSpeed ?? 1,
      queueIndex: event.index,
    );
  }

  int get fastForwardValue {
    Duration videoDuration = _fullVideoDuration ?? Duration.zero;

    int newMilliSecondDuration =
        (_videoPlayerController!.value.position).inMilliseconds + 10 * 1000;

    if (newMilliSecondDuration > videoDuration.inMilliseconds) {
      newMilliSecondDuration = videoDuration.inMilliseconds;
    }
    return newMilliSecondDuration;
  }

  int get rewindValue {
    int newMilliSecondDuration =
        (_videoPlayerController!.value.position).inMilliseconds - 10 * 1000;
    if (newMilliSecondDuration < 0) {
      newMilliSecondDuration = 0;
    }
    return newMilliSecondDuration;
  }

  void closeVideo() {
    _mediaPlayerProvider.closeVideo(false);
    _videoPlayerController?.removeListener(() {});
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
    isVideoPlaying = false;
    _fullVideoDuration = null;
    videoState = VideoState.completed;
  }

  void setVideoSpeed(double s) {
    _mediaPlayerProvider.setVideoSpeed(s);
    _videoPlayerController?.setPlaybackSpeed(s);
  }

  void pause() {
    _videoPlayerController!.pause();
    _mediaPlayerProvider.pauseVideo(false);
    _mediaPlayerProvider.pausePlayAnimation?.reverse();
  }

  void setSpeed(double s) {
    _videoPlayerController?.setPlaybackSpeed(s);
  }

  void setMuted(bool muted) {
    _videoPlayerController?.setVolume(muted ? 0 : 1);
  }

  void playOrResume() {
    videoPlayerController!.play();
    _mediaPlayerProvider.pausePlayAnimation?.forward();
  }
}
