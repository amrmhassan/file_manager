class ServiceNotificationIDs {
  static const int audioPlayer = 900;
  static const int videoPlayer = 901;
  static const int shareSpace = 902;
  static const int connLaptop = 903;
  static const int serviceRunning = 903;
}

class ServiceActions {
  static const String stopService = 'stopService';
  //# audio actions
  static const String playAudioAction = 'playAudioAction';
  static const String pauseAudioAction = 'pauseAudioAction';
  static const String seekToAction = 'seekToAction';
}

class ServiceResActions {
  static const String setFullSongDuration = 'setFullSondDuration';
  static const String setCurrentAudioDuration = 'setCurrentAudioDuration';
  static const String audioFinished = 'audioFinished';
}
