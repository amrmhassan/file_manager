class ServiceNotificationIDs {
  static const int serviceRunning = 903;
}

class ServiceActions {
  static const String stopService = 'stopService';
  //# audio actions
  static const String playAudioAction = 'playAudioAction';
  static const String pauseAudioAction = 'pauseAudioAction';
  static const String seekToAction = 'seekToAction';
  static const String checkAudioPlaying = 'checkAudioPlaying';
  static const String getFullSongDuration = 'getFullSongDuration';
}

class ServiceResActions {
  //# audio result actions
  static const String setFullSongDuration = 'setFullSondDuration';
  static const String setCurrentAudioDuration = 'setCurrentAudioDuration';
  static const String audioFinished = 'audioFinished';
  static const String isPlaying = 'isPlaying';
  static const String getSongPath = 'getSongPath';
}
