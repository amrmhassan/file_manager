import 'dart:math';

class DownloadsNotificationIDSMapper {
  final Map<String, int> _ids = {};
  final Map<int, int> _progressMap = {};

  bool allowNotification(int count, int id) {
    int? previousCount = _getCurrentProgress(id);
    if (count == previousCount) return false;
    _updateProgress(id, count);
    return true;
  }

  void _updateProgress(int id, int count) {
    _progressMap[id] = count;
  }

  int? _getCurrentProgress(int id) {
    return _progressMap[id];
  }

  int notificationID(String taskID) {
    if (_ids.keys.contains(taskID)) {
      return _ids[taskID]!;
    } else {
      int randomeID = _getRandomID();
      _ids[taskID] = randomeID;
      return randomeID;
    }
  }

  int _getRandomID() {
    int randomeID = Random().nextInt(10000);
    if (_ids.values.contains(randomeID)) {
      return _getRandomID();
    } else {
      return randomeID;
    }
  }
}
