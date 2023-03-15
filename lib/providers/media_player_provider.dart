import 'dart:async';

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/global/widgets/custom_slider/sub_range_model.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:explorer/utils/notifications/quick_notifications.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart' as volume_controllers;

class MediaPlayerProvider extends ChangeNotifier {
  //# service stream subscriptions
  StreamSubscription? fullDurationsub;
  StreamSubscription? currentDurationSub;
  StreamSubscription? audioFinishedSub;

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

  Future<void> pausePlaying() async {
    myAudioHandler.pause();
    audioPlaying = false;
    notifyListeners();
  }

  Future<void> resumePlaying() async {
    myAudioHandler.play();
    audioPlaying = true;
    notifyListeners();
  }

  //? pause playing
  Future<void> stopPlaying([bool callBackgroundService = true]) async {
    if (callBackgroundService) {
      // AudioServiceController.pauseAudio();
      myAudioHandler.pause();
    }
    QuickNotification.closeAudioNotification();

    audioPlaying = false;
    fullSongDuration = null;
    currentDuration = null;
    playingAudioFilePath = null;
    playerHidden = true;

    notifyListeners();
  }

  //? to play an audio
  Future<void> _playAudio(
    String path, [
    bool network = false,
    String? fileRemotePath,
  ]) async {
    try {
      runAudioBackgroundServiceListeners();
      // AudioServiceController.playAudio(path, network, fileRemotePath);
      myAudioHandler.playAudio(path, this, network, fileRemotePath);

      late String fileName;
      if (network) {
        fileName = getFileName(fileRemotePath!);
      } else {
        fileName = getFileName(path);
      }

      // QuickNotification.sendAudioNotification(fileName);
      audioPlaying = true;
      notifyListeners();
    } catch (e) {
      audioPlaying = false;
      fullSongDuration = null;
      notifyListeners();
    }
  }

  void runAudioBackgroundServiceListeners() {
    fullDurationsub?.cancel();
    currentDurationSub?.cancel();
    audioFinishedSub?.cancel();
    fullSongDuration = null;
    currentDurationSub = null;
    audioFinishedSub = null;

    // here receive the full sond duration
//     fullDurationsub = flutterBackgroundService
//         .on(ServiceResActions.setFullSongDuration)
//         .listen((event) {
//       int? duration = event?['duration'];
//       if (duration == null) {
//         logger.i('full song duration is null');
//         throw Exception('full song duration is null');
//       }
//       fullSongDuration = Duration(milliseconds: duration);
//     });
//     // listen for duration stream
//     currentDurationSub = flutterBackgroundService
//         .on(ServiceResActions.setCurrentAudioDuration)
//         .listen((event) {
//       Duration d = Duration(milliseconds: event!['duration']);
//       if (d.inMilliseconds > (fullSongDuration?.inMilliseconds ?? 0)) return;
//       currentDuration = d;
//       notifyListeners();
//     });

// // receive the audio finished
//     audioFinishedSub = flutterBackgroundService
//         .on(ServiceResActions.audioFinished)
//         .listen((event) {
//       pausePlaying(false);
//     });
  }

  // ? to forward by 10 seconds
  void forward10() {
    seekTo(currentDuration!.inMilliseconds + 10 * 1000);
  }

  // ? to backward by 10 seconds
  void backward10() {
    seekTo(currentDuration!.inMilliseconds - 10 * 1000);
  }

  //? seek to
  void seekTo(int millisecond) {
    myAudioHandler.seek(Duration(milliseconds: millisecond));
  }

  void handlePlayingAudioAfterResumingApp() async {
    bool isPlaying = myAudioHandler.isPlaying;
    if (isPlaying) {
      Duration? fullSongD = myAudioHandler.getFullSongDurtion;
      //! get the file name from the background service
      // QuickNotification.sendAudioNotification('fileName');
      runAudioBackgroundServiceListeners();
      audioPlaying = true;
      fullSongDuration = fullSongD;
      notifyListeners();
    }
  }

  //# video controllers
  String? playingVideoPath;
  VideoPlayerController? videoPlayerController;
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

  void setVideoSpeed(double s) {
    videoSpeed = s;
    notifyListeners();
    videoPlayerController?.setPlaybackSpeed(s);
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
    closeVideo();
    if (network) {
      playingVideoPath = fileRemotePath;
    } else {
      playingVideoPath = path;
    }
    videoPlayerController = VideoPlayerController.network(path,
        httpHeaders: network
            ? {
                filePathHeaderKey: Uri.encodeComponent(fileRemotePath!),
              }
            : {},
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: true,
        ))
      ..initialize().then((value) {
        videoHeight = videoPlayerController?.value.size.height;
        videoWidth = videoPlayerController?.value.size.width;
        videoAspectRatio = videoPlayerController?.value.aspectRatio;
        videoDuration = videoPlayerController?.value.duration;
        networkVideo = network;

        notifyListeners();
      })
      ..play()
      ..addListener(() async {
        videoPosition = videoPlayerController?.value.position ?? Duration.zero;
        _bufferedParts = videoPlayerController?.value.buffered ?? [];
        isBuffering = videoPlayerController?.value.isBuffering ?? false;

        notifyListeners();
        if (isVideoPlaying &&
            !(videoPlayerController?.value.isPlaying ?? false)) {
          //* this means it stopped playing cause it's duration finished
          closeVideo();
        }
      });
    isVideoPlaying = true;
    videoHidden = false;

    notifyListeners();
  }

  //? close video
  void closeVideo() {
    videoPlayerController?.removeListener(() {});
    videoPlayerController?.dispose();
    videoPlayerController = null;
    isVideoPlaying = false;
    videoDuration = null;
    videoMuted = false;
    videoPosition = Duration.zero;
    videoHidden = false;
    bottomVideoControllersHidden = false;
    _bufferedParts.clear();
    videoSpeed = 1;
    notifyListeners();
  }

  //? toggle video play
  void toggleVideoPlay() {
    isVideoPlaying = !isVideoPlaying;
    bottomVideoControllersHidden = false;
    notifyListeners();
    if (isVideoPlaying) {
      videoPlayerController?.play();
    } else {
      videoPlayerController?.pause();
    }
  }

  void pauseVideo() {
    isVideoPlaying = false;
    notifyListeners();
    videoPlayerController?.pause();
  }

  void resumeVideo() {
    isVideoPlaying = true;
    notifyListeners();
    videoPlayerController?.play();
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
    if (videoMuted) {
      await videoPlayerController?.setVolume(1);
    } else {
      await videoPlayerController?.setVolume(0);
    }

    videoMuted = !videoMuted;
    notifyListeners();
  }

  //# video fast seeking
  Future videoBackWard10() async {
    videoPlayerController?.seekTo(
        Duration(milliseconds: videoPosition.inMilliseconds - 10 * 1000));
    Duration newDuration =
        Duration(milliseconds: videoPosition.inMilliseconds - 10000);
    if (newDuration.inSeconds < 0) {
      videoPlayerController?.seekTo(Duration.zero);
    } else {
      videoPlayerController?.seekTo(newDuration);
    }
  }

  Future videoForWard10() async {
    Duration newDuration = Duration(
      milliseconds: videoPosition.inMilliseconds + 10000,
    );
    if (newDuration.inSeconds > videoDuration!.inSeconds) {
      videoPlayerController?.seekTo(videoDuration!);
    } else {
      videoPlayerController?.seekTo(newDuration);
    }
  }
}
