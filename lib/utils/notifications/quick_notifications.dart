import 'package:awesome_notifications/awesome_notifications.dart';

void sendNotification(int progress) {
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
        id: 10,
        channelKey: 'basic_channel',
        title: 'Downloading - $progress%',
        body:
            'downloadinged_file_name_into_space_downloadinged_file_name_into_spacedownloadinged_file_name_into_space_downloadinged_file_name_into_spacedownloadinged_file_name_into_space_downloadinged_file_name_into_spacedownloadinged_file_name_into_space_downloadinged_file_name_into_spacedownloadinged_file_name_into_space_downloadinged_file_name_into_spacedownloadinged_file_name_into_space_downloadinged_file_name_into_space.png',
        actionType: ActionType.Default,
        locked: true,
        fullScreenIntent: true,
        progress: progress,
        notificationLayout: NotificationLayout.ProgressBar,
        summary: 'task_id',
      ),
    );
  });
}

void closeNotification() {
  AwesomeNotifications().cancel(10);
}
