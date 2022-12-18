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
        videoVolume = videoPlayerController?.value.volume ?? 0;
        videoDuration = videoPlayerController?.value.duration;

        notifyListeners();
      })
      ..play();
    // ..addListener(() async {
    //   videoPosition =
    //       (await videoPlayerController?.position) ?? Duration.zero;
    //   printOnDebug(videoPosition.inMilliseconds);
    //   if (videoPosition.inMilliseconds >= videoDuration!.inMilliseconds) {
    //     closeVideo();
    //   }
    // });
    isVideoPlaying = true;

    notifyListeners();
  }

  //? close video
  void closeVideo() {
    videoPlayerController?.dispose();
    videoPlayerController = null;
    isVideoPlaying = false;
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
    printOnDebug(p);
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
}
