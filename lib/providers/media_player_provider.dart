import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
      printOnDebug(e);
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
  double videoVolume = 0;
  bool volumeTouched = false;

  //? set volume touched
  void setVolumeTouched(bool t) {
    volumeTouched = t;
    notifyListeners();
  }

  //? play video
  void playVideo(String path) {
    videoPlayerController = VideoPlayerController.network(path)
      ..initialize().then((value) {
        videoHeight = videoPlayerController?.value.size.height;
        videoWidth = videoPlayerController?.value.size.width;
        videoAspectRatio = videoPlayerController?.value.aspectRatio;
        videoVolume = videoPlayerController?.value.volume ?? 0;
        notifyListeners();
      })
      ..play();

    notifyListeners();
  }

  //? close video
  void closeVideo() {
    videoPlayerController?.dispose();
    videoPlayerController = null;
    notifyListeners();
  }

  //? add to video volume
  void addToVolume(double v) async {
    videoVolume += v;
    if (videoVolume < 0) videoVolume = 0;
    if (videoVolume > 1) videoVolume = 1;
    await videoPlayerController?.setVolume(videoVolume);
    notifyListeners();
  }
}
