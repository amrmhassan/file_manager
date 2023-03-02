import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:explorer/main.dart';

class NotificationsIDS {
  static int downloadNotification = 10;
}

class QuickNotification {
  static void sendDownloadNotification(
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

  static void closeDownloadNotification(String id) {
    int notiID = notificationMapper.notificationID(id);
    AwesomeNotifications().cancel(notiID);
  }
}
