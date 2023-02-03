import 'dart:async';

import 'package:explorer/constants/server_constants.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart' as volume_controllers;

class MediaPlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration? fullSongDuration;
  Duration? currentDuration;

  bool playerHidden = false;
  void togglePlayerHidden() {
    playerHidden = !playerHidden;
    notifyListeners();
  }

  StreamSubscription? durationStreamSub;

//? check playing
  bool audioPlaying = false;

//? playing audio file path
  String? playingAudioFilePath;

  Future<void> setPlayingFile(
    String path, [
    bool network = false,
    String? fileRemotePath,
  ]) async {
    playingAudioFilePath = path;
    if (network) {
      playingAudioFilePath = fileRemotePath;
    }
    notifyListeners();
    await _playAudio(
      path,
      network,
      fileRemotePath,
    );
  }

  //? pause playing
  Future<void> pausePlaying() async {
    await _audioPlayer.pause();

    audioPlaying = false;
    notifyListeners();
  }

//? to play an audio
  Future<void> _playAudio(
    String path, [
    bool network = false,
    String? fileRemotePath,
  ]) async {
    try {
      if (durationStreamSub != null) {
        durationStreamSub?.cancel();
      }
      if (network) {
        fullSongDuration = await _audioPlayer.setUrl(
          path,
          headers: network
              ? {
                  filePathHeaderKey: Uri.encodeComponent(fileRemotePath!),
                }
              : null,
        );
      } else {
        fullSongDuration = await _audioPlayer.setFilePath(path);
      }
      audioPlaying = true;
      notifyListeners();

      durationStreamSub = _audioPlayer.positionStream.listen((event) {
        currentDuration = event;
        if (currentDuration?.inSeconds == fullSongDuration?.inSeconds) {
          audioPlaying = false;
          fullSongDuration = null;
          playingAudioFilePath = null;
          currentDuration = null;
        }
        notifyListeners();
      });
      await _audioPlayer.play();
    } catch (e) {
      audioPlaying = false;
      fullSongDuration = null;
      notifyListeners();
    }
  }

  // ? to forward by 10 seconds
  void forward10() {
    _audioPlayer.seek(
        Duration(milliseconds: currentDuration!.inMilliseconds + 10 * 1000));
  }

  // ? to backward by 10 seconds
  void backward10() {
    _audioPlayer.seek(
        Duration(milliseconds: currentDuration!.inMilliseconds - 10 * 1000));
  }

  //? seek to
  void seekTo(int millisecond) {
    _audioPlayer.seek(Duration(milliseconds: millisecond));
  }

  //# video controllers
  VideoPlayerController? videoPlayerController;
  double? videoHeight;
  double? videoWidth;
  double? videoAspectRatio;
  // double videoVolume = 0;
  bool volumeTouched = false;
  bool seekerTouched = false;
  Duration? videoDuration;
  bool isVideoPlaying = false;
  Duration videoPosition = Duration.zero;
  bool videoHidden = false;
  bool networkVideo = false;

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
    // print(path);
    // print(network);
    // print('object');
    // if (network) {
    //   String parsedPath = path.replaceFirst('http://', '');
    //   var parts = parsedPath.split('/');
    //   parsedPath = parts.sublist(2).join('/');
    //   playingAudioFilePath = parsedPath;
    //   path = playingAudioFilePath!;
    // }

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
        // videoVolume = videoPlayerController?.value.volume ?? 0;
        videoDuration = videoPlayerController?.value.duration;
        networkVideo = network;

        notifyListeners();
      })
      ..play()
      ..addListener(() async {
        videoPosition = videoPlayerController?.value.position ?? Duration.zero;
        if (isVideoPlaying &&
            !(videoPlayerController?.value.isPlaying ?? false)) {
          //* this means it stopped playing cause it's duration finished
          closeVideo();
        }
      });
    isVideoPlaying = true;

    notifyListeners();
  }

  //? close video
  void closeVideo() {
    videoPlayerController?.removeListener(() {});
    videoPlayerController?.dispose();
    videoPlayerController = null;
    isVideoPlaying = false;
    videoDuration = null;
    videoPosition = Duration.zero;
    videoHidden = false;
    bottomVideoControllersHidden = false;
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
}
