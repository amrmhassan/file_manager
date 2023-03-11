// ignore_for_file: prefer_const_constructors

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:flutter/material.dart';

class NotificationsIDS {
  static const int audioNitificationID = 100;
  static const int videoNotificationID = 102;
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
      if (progress == 100) {
        Future.delayed(Duration(seconds: 2)).then((value) {
          try {
            closeDownloadNotification(id);
          } catch (e) {
            logger.e(e);
          }
        });
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

  static void sendAudioNotification(
    String fileName,
  ) {
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
          id: NotificationsIDS.audioNitificationID,
          channelKey: 'basic_channel',
          title: fileName,
          body: fileName,
          locked: true,
          fullScreenIntent: true,
          notificationLayout: NotificationLayout.MediaPlayer,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'pause',
            label: 'Pause',
            color: Colors.red,
            enabled: true,
            isDangerousOption: true,
            requireInputText: true,
            showInCompactView: true,
          ),
          NotificationActionButton(
            key: 'forward',
            label: 'Pause',
            actionType: ActionType.KeepOnTop,
          ),
          NotificationActionButton(
            key: 'backward',
            label: 'Pause',
            actionType: ActionType.KeepOnTop,
          ),
        ],
      );
    });
  }

  static void closeAudioNotification() {
    AwesomeNotifications().cancel(NotificationsIDS.audioNitificationID);
  }
}
