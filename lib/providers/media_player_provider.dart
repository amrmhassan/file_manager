import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/global/widgets/custom_slider/sub_range_model.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:explorer/services/media_service/my_media_handler.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart' as volume_controllers;

class MediaPlayerProvider extends ChangeNotifier {
  //# service stream subscriptions
  // StreamSubscription? audioPlayerStateSub;
  PlayingMediaType? playingMediaType;
  void setPlayingMediaType(PlayingMediaType p) {
    playingMediaType = p;
    notifyListeners();
  }

  Duration? fullSongDuration;
  Duration? currentDuration;

  void initMediaListeners() {
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToTotalDuration();
  }

  bool get audioFinished =>
      (fullSongDuration?.inMilliseconds == currentDuration?.inMilliseconds) &&
      ((currentDuration != null) || (fullSongDuration != null));

  void _listenToPlaybackState() {
    myTestMediaHandler.playbackState.listen((playbackState) {
      if (playbackState.playing && !audioPlaying) {
        audioPlaying = true;
        notifyListeners();
      } else if (!playbackState.playing && audioPlaying) {
        audioPlaying = false;
        notifyListeners();
      }
      if (((playbackState.processingState == AudioProcessingState.completed) &&
              audioFinished) ||
          (!playbackState.playing && audioFinished)) {
        stopAudioPlaying();
      }
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      setCurrentSongPosition(position);
    });
  }

  void _listenToTotalDuration() {
    myTestMediaHandler.mediaItem.listen((mediaItem) {
      if (mediaItem == null) return;
      setFullSongDuration(mediaItem.duration);
    });
  }

  void setFullSongDuration(Duration? d) {
    fullSongDuration = d;
    notifyListeners();
  }

  void setCurrentSongPosition(Duration d) {
    if (d.inMilliseconds > (fullSongDuration?.inMilliseconds ?? 0) ||
        d.inMilliseconds <= 0) return;
    currentDuration = d;
    notifyListeners();
  }

  bool playerHidden = true;
  void togglePlayerHidden() {
    playerHidden = !playerHidden;
    notifyListeners();
  }

  //? check playing
  bool audioPlaying = false;

  //? playing audio file path
  String? playingAudioFilePath;

  Future<void> setPlayingFile(
    String path, [
    bool network = false,
    String? fileRemotePath,
  ]) async {
    playerHidden = false;
    playingAudioFilePath = path;
    if (network) {
      playingAudioFilePath = fileRemotePath;
    }
    notifyListeners();

    _playAudio(
      path,
      network,
      fileRemotePath,
    );
  }

  Future<void> pauseAudioPlaying([bool callService = true]) async {
    if (callService) myTestMediaHandler.pause();
    audioPlaying = false;
    notifyListeners();
  }

  Future<void> resumeAudioPlaying() async {
    myTestMediaHandler.play();
    audioPlaying = true;
    notifyListeners();
  }

  //? pause playing
  Future<void> stopAudioPlaying([bool callBackgroundService = true]) async {
    if (callBackgroundService) {
      myTestMediaHandler.stop();
    }

    // audioPlayerStateSub?.cancel();

    audioPlaying = false;
    fullSongDuration = null;
    currentDuration = null;
    playingAudioFilePath = null;
    playerHidden = true;
    // audioPlayerStateSub = null;

    notifyListeners();
  }

  //? to play an audio
  Future<void> _playAudio(
    String path, [
    bool network = false,
    String? fileRemotePath,
  ]) async {
    try {
      setPlayingMediaType(PlayingMediaType.audio);
      late String fileName;
      if (network) {
        fileName = getFileName(fileRemotePath!);
      } else {
        fileName = getFileName(path);
      }

      MediaItem mediaItem = MediaItem(
        id: network ? fileRemotePath! : path,
        title: fileName,
        extras: {
          'path': path,
          'network': network,
          'fileRemotePath': fileRemotePath,
          'mediaType': 'audio',
        },
      );
      myTestMediaHandler.addQueueItem(mediaItem);

      myTestMediaHandler.play();

      audioPlaying = true;
      notifyListeners();
    } catch (e) {
      audioPlaying = false;
      fullSongDuration = null;
      notifyListeners();
    }
  }

  // ? to forward by 10 seconds
  void forward10() {
    myTestMediaHandler.fastForward();
  }

  // ? to backward by 10 seconds
  void backward10() {
    myTestMediaHandler.rewind();
  }

  //? seek to
  void seekTo(int millisecond) {
    myTestMediaHandler.seek(Duration(milliseconds: millisecond));
  }

  // void handlePlayingAudioAfterResumingApp() async {
  //   try {
  //     bool isPlaying = myTestMediaHandler.isPlaying;
  //     if (isPlaying) {
  //       Duration? fullSongD = myTestMediaHandler.getFullSongDuration;
  //       audioPlaying = true;
  //       fullSongDuration = fullSongD;
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     logger.e(e);
  //   }
  // }

  //# video controllers
  String? playingVideoPath;
  double? videoHeight;
  double? videoWidth;
  double? videoAspectRatio;
  bool volumeTouched = false;
  bool seekerTouched = false;
  Duration? videoDuration;
  bool isVideoPlaying = false;
  Duration videoPosition = Duration.zero;
  bool videoHidden = false;
  bool networkVideo = false;
  List<DurationRange> _bufferedParts = [];
  bool isBuffering = false;
  double videoSpeed = 1;
  VideoPlayerController? videoPlayerController;

  void setVideoSpeed(double s, [bool callBackground = true]) {
    videoSpeed = s;
    notifyListeners();
    //! call set speed here with call background
    if (callBackground) myTestMediaHandler.setSpeed(s);
  }

  //? to return the ready buffered parts to be viewed into the video player slider
  List<SubRangeModel> get bufferedTransformer => _bufferedParts
      .map((e) => SubRangeModel(
            start: Duration(milliseconds: e.start.inMilliseconds)
                .inMilliseconds
                .toDouble(),
            end: Duration(milliseconds: e.end.inMilliseconds)
                .inMilliseconds
                .toDouble(),
            color: videoSliderBufferedColor,
          ))
      .toList();

  //? set volume touched
  void setVolumeTouched(bool t) {
    volumeTouched = t;
    bottomVideoControllersHidden = false;
    notifyListeners();
    if (volumeTouched) {
      updateDeviceVolume();
    }
  }

  //? set seeker touched
  void setSeekerTouched(bool t) {
    seekerTouched = t;
    bottomVideoControllersHidden = false;
    notifyListeners();
  }

  //? play video
  void playVideo(
    String path, [
    bool network = false,
    String? fileRemotePath,
  ]) async {
    setPlayingMediaType(PlayingMediaType.video);
    MediaItem mediaItem = MediaItem(
      id: network ? fileRemotePath! : path,
      title: getFileName(network ? fileRemotePath! : path),
      displayTitle: getFileName(network ? fileRemotePath! : path),
      extras: {
        'path': path,
        'network': network,
        'fileRemotePath': fileRemotePath,
        'mediaType': 'video',
      },
    );
    await myTestMediaHandler.playVideo(
      mediaItem,
      this,
      (controller) {
        _runVideoDurationListener(controller);
      },
    );
    myTestMediaHandler.play();

    isVideoPlaying = true;
    videoHidden = false;

    notifyListeners();
  }

  void onInitVideo(VideoPlayerController controller, bool network) {
    videoHeight = controller.value.size.height;
    videoWidth = controller.value.size.width;
    videoAspectRatio = controller.value.aspectRatio;
    videoDuration = controller.value.duration;
    networkVideo = network;
    isVideoPlaying = true;
    videoPlayerController = controller;
    notifyListeners();
  }

  void _runVideoDurationListener(VideoPlayerController controller) {
    videoDuration ??= controller.value.duration;
    videoPosition = controller.value.position;
    _bufferedParts = controller.value.buffered;
    isBuffering = controller.value.isBuffering;
    notifyListeners();
  }

  void videoPositionListener(VideoPlayerController controller) {
    videoPosition = controller.value.position;
    _bufferedParts = controller.value.buffered;
    isBuffering = controller.value.isBuffering;
    notifyListeners();
  }

  //? close video
  void closeVideo([bool tellBackground = true]) {
    pauseVideo();
    videoPlayerController = null;
    isVideoPlaying = false;
    videoDuration = null;
    videoMuted = false;
    videoPosition = Duration.zero;
    videoHidden = false;
    bottomVideoControllersHidden = false;
    _bufferedParts = [];
    videoSpeed = 1;
    notifyListeners();
    if (tellBackground) myTestMediaHandler.stop();
  }

  //? toggle video play
  void toggleVideoPlay([bool callBackground = true]) {
    if (isVideoPlaying) {
      pauseVideo(callBackground);
    } else {
      resumeVideo(callBackground);
    }
  }

  void pauseVideo([bool callBackground = true]) {
    try {
      isVideoPlaying = false;
      notifyListeners();
      if (callBackground) myTestMediaHandler.pause();
    } catch (e) {
      logger.e(e);
    }
  }

  void resumeVideo([bool callBackground = true]) {
    try {
      isVideoPlaying = true;
      notifyListeners();
      myTestMediaHandler.play();
    } catch (e) {
      logger.e(e);
    }
  }

  //? add to current position
  void addToPosition(double p) async {
    Duration? currentPosition = await videoPlayerController?.position;
    if (currentPosition == null) return;
    videoPosition = Duration(
      microseconds: currentPosition.inMicroseconds,
      milliseconds: (p * 1000).toInt(),
    );
    notifyListeners();
    await videoPlayerController?.seekTo(videoPosition);
  }

  Future<void> seekVideo(double p) async {
    videoPosition = Duration(milliseconds: p.toInt());
    notifyListeners();
    await videoPlayerController?.seekTo(videoPosition);
  }

  //? toggle hide video
  void toggleHideVideo() {
    videoHidden = !videoHidden;
    notifyListeners();
  }

  //# volume controllers
  double deviceVolume = 1;
  //? to set the device volume
  void setDeviceVolume(double v) {
    volume_controllers.VolumeController().setVolume(v, showSystemUI: false);
  }

  //? to change device volume with a slider
  void addToDeviceVolume(double v) {
    deviceVolume += v;
    if (deviceVolume < 0) deviceVolume = 0;
    if (deviceVolume > 1) deviceVolume = 1;
    notifyListeners();
    setDeviceVolume(deviceVolume);
  }

  //? to update the device volume from the original android volume
  Future updateDeviceVolume() async {
    deviceVolume = await volume_controllers.VolumeController().getVolume();
    notifyListeners();
  }

  //# bottom video controllers
  bool bottomVideoControllersHidden = false;
  void toggleBottomVideoControllersHidden() {
    bottomVideoControllersHidden = !bottomVideoControllersHidden;
    notifyListeners();
  }

  void setBottomVideoControllersHidden(bool b) {
    bottomVideoControllersHidden = b;
    notifyListeners();
  }

  //# muting the video
  bool videoMuted = false;
  Future toggleMuteVideo() async {
    // myTestMediaHandler.toggleVideoMuted(!videoMuted);
    videoPlayerController!.setVolume(videoMuted ? 1 : 0);

    videoMuted = !videoMuted;
    notifyListeners();
  }

  //# video fast seeking
  Future videoBackWard10() async {
    int newMilliSecondDuration =
        (videoPlayerController!.value.position).inMilliseconds - 10 * 1000;
    if (newMilliSecondDuration < 0) {
      newMilliSecondDuration = 0;
    }
    seekVideo(newMilliSecondDuration.toDouble());
  }

  Future videoForWard10() async {
    Duration videoD = videoDuration ?? Duration.zero;

    int newMilliSecondDuration =
        (videoPlayerController!.value.position).inMilliseconds + 10 * 1000;

    if (newMilliSecondDuration > videoD.inMilliseconds) {
      newMilliSecondDuration = videoD.inMilliseconds;
    }
    seekVideo(newMilliSecondDuration.toDouble());
  }

  //# video play pause button animation
  AnimationController? pausePlayAnimation;
  void disposeAnimationController() {
    pausePlayAnimation = null;
  }

  void setAnimationController(AnimationController a) {
    pausePlayAnimation = a;
  }
}
