import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';

class MediaPlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration? fullSongDuration;
  Duration? currentDuration;

  StreamSubscription? durationStreamSub;

//? check playing
  bool playing = false;

//? playing audio file path
  String? playingFilePath;
  Future<void> setPlayingFile(String path) async {
    playingFilePath = path;
    notifyListeners();
    await _playAudio(path);
  }

  //? pause playing
  Future<void> pausePlaying() async {
    await _audioPlayer.pause();

    playing = false;
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
      playing = true;
      notifyListeners();
      _audioPlayer.onPlayerComplete.listen((event) {
        playing = false;
        fullSongDuration = null;
        playingFilePath = null;
        notifyListeners();
      });
      durationStreamSub = _audioPlayer.onPositionChanged.listen((event) {
        currentDuration = event;
        notifyListeners();
      });

      await _audioPlayer.play(DeviceFileSource(path), position: Duration.zero);
    } catch (e) {
      playing = false;
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
}
