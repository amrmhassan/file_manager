import 'dart:async';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/controllers_overlay.dart';
import 'package:explorer/global/widgets/custom_slider/sub_range_model.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:explorer/services/media_service/my_media_handler.dart';
import 'package:explorer/utils/notifications/quick_notifications.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart' as volume_controllers;

class MediaPlayerProvider extends ChangeNotifier {
  //# service stream subscriptions
  StreamSubscription? audioPlayerStateSub;

  Duration? fullSongDuration;
  Duration? currentDuration;

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
    if (callService) myMediaHandler.pause();
    audioPlaying = false;
    notifyListeners();
  }

  Future<void> resumeAudioPlaying() async {
    myMediaHandler.play();
    audioPlaying = true;
    notifyListeners();
  }

  //? pause playing
  Future<void> stopAudioPlaying([bool callBackgroundService = true]) async {
    if (callBackgroundService) {
      // AudioServiceController.pauseAudio();
      myMediaHandler.stop();
    }
    QuickNotification.closeAudioNotification();

    audioPlayerStateSub?.cancel();

    audioPlaying = false;
    fullSongDuration = null;
    currentDuration = null;
    playingAudioFilePath = null;
    playerHidden = true;
    audioPlayerStateSub = null;

    notifyListeners();
  }

  //? to play an audio
  Future<void> _playAudio(
    String path, [
    bool network = false,
    String? fileRemotePath,
  ]) async {
    try {
      // AudioServiceController.playAudio(path, network, fileRemotePath);
      myMediaHandler.playMedia(
        PlayingMediaType.audio,
        path,
        this,
        network,
        fileRemotePath,
      );

      // QuickNotification.sendAudioNotification(fileName);
      audioPlaying = true;
      notifyListeners();
      audioPlayerStateSub = myMediaHandler
          .audioHandlersUtils.audioPlayer.playerStateStream
          .listen((event) {
        if (event.playing && !audioPlaying) {
          audioPlaying = true;
          notifyListeners();
        } else if (!event.playing && audioPlaying) {
          audioPlaying = false;
          notifyListeners();
        }
      });
    } catch (e) {
      audioPlaying = false;
      fullSongDuration = null;
      notifyListeners();
    }
  }

  // ? to forward by 10 seconds
  void forward10() {
    myMediaHandler.fastForward();
  }

  // ? to backward by 10 seconds
  void backward10() {
    myMediaHandler.rewind();
  }

  //? seek to
  void seekTo(int millisecond) {
    myMediaHandler.seek(Duration(milliseconds: millisecond));
  }

  void handlePlayingAudioAfterResumingApp() async {
    bool isPlaying = myMediaHandler.isPlaying;
    if (isPlaying) {
      Duration? fullSongD = myMediaHandler.getFullSongDuration;
      audioPlaying = true;
      fullSongDuration = fullSongD;
      notifyListeners();
    }
  }

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
  String? networkStreamLink;

  void setVideoSpeed(double s, [bool callBackground = true]) {
    videoSpeed = s;
    notifyListeners();
    //! call set speed here with call background
    if (callBackground) myMediaHandler.setSpeed(s);
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
  ]) {
    if (network) {
      networkStreamLink = '$path/${Uri.encodeComponent(fileRemotePath!)}';
    }
    myMediaHandler.playMedia(
      PlayingMediaType.video,
      path,
      this,
      network,
      fileRemotePath,
    );
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
    if (tellBackground) myMediaHandler.stop();
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
      if (callBackground) myMediaHandler.pause();
    } catch (e) {
      logger.e(e);
    }
  }

  void resumeVideo([bool callBackground = true]) {
    try {
      isVideoPlaying = true;
      notifyListeners();
      myMediaHandler.play();
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
    myMediaHandler.toggleVideoMuted(!videoMuted);

    videoMuted = !videoMuted;
    notifyListeners();
  }

  //# video fast seeking
  Future videoBackWard10() async {
    myMediaHandler.rewind();
  }

  Future videoForWard10() async {
    myMediaHandler.fastForward();
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
