import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MediaPlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration? fullSongDuration;
  Duration? currentDuration;

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
      fullSongDuration = await _audioPlayer.setFilePath(path);
      playing = true;
      notifyListeners();
      _audioPlayer.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          playing = false;
          fullSongDuration = null;
          playingFilePath = null;
          notifyListeners();
        }
      });
      await _audioPlayer.play();
    } catch (e) {
      playing = false;
      fullSongDuration = null;
      notifyListeners();
      printOnDebug(e);
    }
  }
}
