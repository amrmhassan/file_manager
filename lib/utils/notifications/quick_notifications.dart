import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/main.dart';

class NotificationsIDS {
  static int downloadNotification = 10;
}

class QuickNotification {
  static void sendNotification(
    int progress,
    String id,
    String fileName,
  ) {
    int notiID = notificationMapper.notificationID(id);
    if (!notificationMapper.allowNotification(progress, notiID)) return;
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          autoDismissible: false,
          id: notiID,
          channelKey: 'basic_channel',
          title: 'Downloading - $progress%',
          body: fileName,
          actionType: ActionType.Default,
          locked: true,
          fullScreenIntent: true,
          progress: progress,
          notificationLayout: NotificationLayout.ProgressBar,
          summary: id,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'pause',
            actionType: ActionType.DismissAction,
            label: 'Pause',
          ),
        ],
      );
    });
  }

  static void closeNotification(String id) {
    int notiID = notificationMapper.notificationID(id);
    AwesomeNotifications().cancel(notiID);
  }
}

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
