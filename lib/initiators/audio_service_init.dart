// ignore_for_file: prefer_const_constructors

import 'package:audio_service/audio_service.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:explorer/services/audio_service/audio_service_controller.dart';

Future audioPlayerInit() async {
  myAudioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'basic_channel',
      androidNotificationChannelName: 'Music playback',
      androidNotificationClickStartsActivity: true,
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
    ),
  );
}
