import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/screens/download_manager_screen/download_manager_screen.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
    logger.e('Dismissing the download');
    BuildContext? context = navigatorKey.currentContext;
    if (context == null) return;

    downPF(context).togglePauseResumeTask(
      receivedAction.summary!,
      serverPF(context),
      sharePF(context),
    );
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    BuildContext? context = navigatorKey.currentContext;
    if (context == null) return;

    Navigator.pushNamed(context, DownloadManagerScreen.routeName);
  }
}
