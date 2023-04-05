import 'dart:async';
import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart' as volume_controllers;
import 'package:explorer/constants/global_constants.dart';

class MediaPlayerProviderWindows extends ChangeNotifier {
  final Player _audioPlayer = Player(id: 1000);
  Duration? fullSongDuration;
  Duration? currentDuration;

  bool playerHidden = false;

  void togglePlayerHidden() {
    playerHidden = !playerHidden;
    notifyListeners();
  }

  StreamSubscription? durationStreamSub;
  StreamSubscription? playbackStreamSub;

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
    _audioPlayer.pause();

    audioPlaying = false;
    notifyListeners();
  }

  //? pause playing
  Future<void> resumePlaying() async {
    _audioPlayer.play();

    audioPlaying = true;
    notifyListeners();
  }

  //? to play an audio
  Future<void> _playAudio(
    String path, [
    bool network = false,
    String? fileRemotePath,
  ]) async {
    logger.i('network $network');
    logger.i(path);
    logger.i(fileRemotePath);
    try {
      if (durationStreamSub != null) {
        await durationStreamSub?.cancel();
      }
      if (playbackStreamSub != null) {
        await playbackStreamSub?.cancel();
      }
      if (network) {
        String url = '$path/${Uri.encodeComponent(fileRemotePath!)}';
        _audioPlayer.open(
          Media.network(url),
        );
      } else {
        _audioPlayer.open(Media.file(File(path)), autoStart: true);
      }

      audioPlaying = true;
      notifyListeners();

      playbackStreamSub = _audioPlayer.playbackStream.listen((event) {
        if (_audioPlayer.playback.isCompleted) {
          audioPlaying = false;
          fullSongDuration = null;
          playingAudioFilePath = null;
          currentDuration = null;
          playerHidden = false;
          notifyListeners();
          playbackStreamSub?.cancel();
          durationStreamSub?.cancel();
        }
      });
      durationStreamSub = _audioPlayer.positionStream.listen((event) {
        if (fullSongDuration == null ||
            fullSongDuration?.inSeconds != event.duration?.inSeconds) {
          fullSongDuration = event.duration;
        }
        currentDuration = event.position;

        notifyListeners();
      });
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
  // VideoPlayerController? videoPlayerController;
  String? playingVideoPath;
  Player? videoPlayerController;
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
  // final List<DurationRange> _bufferedParts = [];
  bool isBuffering = false;
  double videoSpeed = 1;
  StreamSubscription? videoPositionStream;
  StreamSubscription? videoStateStream;
  String? networkStreamLink;

  void setVideoSpeed(double s) {
    videoSpeed = s;
    notifyListeners();
    videoPlayerController?.setRate(s);
  }

  //? to return the ready buffered parts to be viewed into the video player slider
  // List<SubRangeModel> get bufferedTransformer => _bufferedParts
  //     .map((e) => SubRangeModel(
  //           start: Duration(milliseconds: e.start.inMilliseconds)
  //               .inMilliseconds
  //               .toDouble(),
  //           end: Duration(milliseconds: e.end.inMilliseconds)
  //               .inMilliseconds
  //               .toDouble(),
  //           color: videoSliderBufferedColor,
  //         ))
  //     .toList();

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
    closeVideo();
    videoStateStream?.cancel();
    videoPositionStream?.cancel();

    videoPlayerController = Player(id: 2000);
    if (network) {
      String url = '$path/${Uri.encodeComponent(fileRemotePath!)}';
      videoPlayerController?.open(Media.network(url));
      playingVideoPath = fileRemotePath;
    } else {
      videoPlayerController?.open(Media.file(File(path)));
      playingVideoPath = path;
    }
    networkVideo = network;
    videoStateStream = videoPlayerController?.playbackStream.listen(
      (event) {
        if (event.isCompleted) {
          videoStateStream?.cancel();
          videoPositionStream?.cancel();
          closeVideo();
        }
      },
    );

    notifyListeners();
    videoPlayerController?.positionStream.listen((event) {
      if (videoDuration == null ||
          videoDuration?.inSeconds != event.duration?.inSeconds) {
        videoDuration = event.duration;
        notifyListeners();
      }
      videoPosition = event.position ?? Duration.zero;
      // _bufferedParts = videoPlayerController.

      notifyListeners();
    });

    // ..initialize().then((value) {
    //   videoHeight = videoPlayerController?.value.size.height;
    //   videoWidth = videoPlayerController?.value.size.width;
    //   videoAspectRatio = videoPlayerController?.value.aspectRatio;
    //   videoDuration = videoPlayerController?.value.duration;
    //   networkVideo = network;

    //   notifyListeners();
    // })
    // ..play()
    // ..addListener(() async {
    //   videoPosition = videoPlayerController?.value.position ?? Duration.zero;
    //   _bufferedParts = videoPlayerController?.value.buffered ?? [];
    //   isBuffering = videoPlayerController?.value.isBuffering ?? false;

    //   notifyListeners();
    //   if (isVideoPlaying &&
    //       !(videoPlayerController?.value.isPlaying ?? false)) {
    //     //* this means it stopped playing cause it's duration finished
    //     closeVideo();
    //   }
    // });
    isVideoPlaying = true;
    videoHidden = false;

    notifyListeners();
  }

  //? close video
  void closeVideo() {
    videoPlayerController?.stop();
    videoPlayerController?.dispose();
    videoPlayerController = null;
    isVideoPlaying = false;
    videoDuration = null;
    videoMuted = false;
    videoPosition = Duration.zero;
    videoHidden = false;
    bottomVideoControllersHidden = false;
    playingVideoPath = null;
    // _bufferedParts.clear();
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
  // void addToPosition(double p) async {
  //   Duration? currentPosition = await videoPlayerController?.position;
  //   if (currentPosition == null) return;
  //   videoPosition = Duration(
  //     microseconds: currentPosition.inMicroseconds,
  //     milliseconds: (p * 1000).toInt(),
  //   );
  //   notifyListeners();
  //   await videoPlayerController?.seekTo(videoPosition);
  // }

  Future<void> seekVideo(double p) async {
    videoPosition = Duration(milliseconds: p.toInt());
    notifyListeners();
    videoPlayerController?.seek(videoPosition);
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
      videoPlayerController?.setVolume(1);
    } else {
      videoPlayerController?.setVolume(0);
    }

    videoMuted = !videoMuted;
    notifyListeners();
  }

  //# video fast seeking
  Future videoBackWard10() async {
    videoPlayerController?.seek(
        Duration(milliseconds: videoPosition.inMilliseconds - 10 * 1000));
    Duration newDuration =
        Duration(milliseconds: videoPosition.inMilliseconds - 10000);
    if (newDuration.inSeconds < 0) {
      videoPlayerController?.seek(Duration.zero);
    } else {
      videoPlayerController?.seek(newDuration);
    }
  }

  Future videoForWard10() async {
    Duration newDuration = Duration(
      milliseconds: videoPosition.inMilliseconds + 10000,
    );
    if (newDuration.inSeconds > videoDuration!.inSeconds) {
      videoPlayerController?.seek(videoDuration!);
    } else {
      videoPlayerController?.seek(newDuration);
    }
  }
}
