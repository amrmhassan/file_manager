import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:just_audio/just_audio.dart';
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

  Duration? get fullVideoDuration => _fullVideoDuration;

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
        mediaPlayerProvider.onInitVideo(_videoPlayerController!, network);
      })
      ..play()
      ..addListener(() async {
        videoState = _videoPlayerController!.value.isPlaying
            ? VideoState.ready
            : _videoPlayerController!.value.isBuffering
                ? VideoState.buffering
                : VideoState.idle;

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
      }[videoState]!,
      playing: _videoPlayerController?.value.isPlaying ?? false,
      updatePosition: _videoPlayerController?.value.position ?? Duration.zero,
      speed: _videoPlayerController?.value.playbackSpeed ?? 1,
      queueIndex: 2,
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
  }

  void setSpeed(double s) {
    _videoPlayerController?.setPlaybackSpeed(s);
  }

  void setMuted(bool muted) {
    _videoPlayerController?.setVolume(muted ? 0 : 1);
  }
}
