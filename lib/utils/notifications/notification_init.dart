// ignore_for_file: prefer_const_constructors

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

Future<void> initializeNotification() async {
  await AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xffFDCF4F),
        ledColor: Colors.white,
        importance: NotificationImportance.Default,
        enableLights: false,
        enableVibration: false,
        playSound: false,
        locked: false,
        channelShowBadge: false,
        defaultPrivacy: NotificationPrivacy.Public,
        criticalAlerts: false,
      )
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Download',
      )
    ],
    debug: true,
  );
}
