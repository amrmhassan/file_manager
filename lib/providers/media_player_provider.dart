import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
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
  Future<void> setPlayingFile(String path) async {
    playingAudioFilePath = path;
    notifyListeners();
    await _playAudio(path);
  }

  //? pause playing
  Future<void> pausePlaying() async {
    await _audioPlayer.pause();

    audioPlaying = false;
    notifyListeners();
  }

//? to play an audio
  Future<void> _playAudio(String path) async {
    try {
      if (durationStreamSub != null) {
        durationStreamSub?.cancel();
      }
      await _audioPlayer.setSourceDeviceFile(path);
      fullSongDuration = await _audioPlayer.getDuration();
      audioPlaying = true;
      notifyListeners();
      _audioPlayer.onPlayerComplete.listen((event) {
        audioPlaying = false;
        fullSongDuration = null;
        playingAudioFilePath = null;
        currentDuration = null;
        notifyListeners();
      });
      durationStreamSub = _audioPlayer.onPositionChanged.listen((event) {
        currentDuration = event;
        notifyListeners();
      });

      await _audioPlayer.play(DeviceFileSource(path), position: Duration.zero);
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

  //? set volume touched
  void setVolumeTouched(bool t) {
    volumeTouched = t;
    notifyListeners();
  }

  //? set seeker touched
  void setSeekerTouched(bool t) {
    seekerTouched = t;
    notifyListeners();
  }

  //? play video
  void playVideo(String path) {
    videoPlayerController = VideoPlayerController.network(path,
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true))
      ..initialize().then((value) {
        videoHeight = videoPlayerController?.value.size.height;
        videoWidth = videoPlayerController?.value.size.width;
        videoAspectRatio = videoPlayerController?.value.aspectRatio;
        // videoVolume = videoPlayerController?.value.volume ?? 0;
        videoDuration = videoPlayerController?.value.duration;

        notifyListeners();
      })
      ..play()
      ..addListener(() async {
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
    notifyListeners();
  }

// //? update video volume
//   void updateVideoVolume() async {
//     await updateDeviceVolume();
//     await setVideoVolume(deviceVolume, false);
//   }

//   //? add to video volume
//   void addToVolume(double v) async {
//     videoVolume += v;
//     if (videoVolume < 0) videoVolume = 0;
//     if (videoVolume > 1) videoVolume = 1;
//     await setVideoVolume(videoVolume);

//     // notifyListeners();
//   }

//   //? set video volume
//   Future<void> setVideoVolume(double v, [bool updateDeviceV = true]) async {
//     await videoPlayerController?.setVolume(videoVolume);
//     if (updateDeviceV) setDeviceVolume(videoVolume);
//   }

  //? toggle video play
  void toggleVideoPlay() {
    if (isVideoPlaying) {
      videoPlayerController?.pause();
    } else {
      videoPlayerController?.play();
    }
    isVideoPlaying = !isVideoPlaying;
    notifyListeners();
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
    setDeviceVolume(deviceVolume);
    notifyListeners();
  }

//? to update the device volume from the original android volume
  Future updateDeviceVolume() async {
    deviceVolume = await volume_controllers.VolumeController().getVolume();
    volume_controllers.VolumeController().listener(
      (p0) async {
        deviceVolume = p0;
        notifyListeners();
      },
    );
    notifyListeners();
  }
}
