// ignore_for_file: prefer_const_constructors

import 'package:audio_service/audio_service.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:explorer/screens/test_screen/test_audio_service.dart';

Future mediaPlayersInit() async {
  // myMediaHandler = await AudioService.init(
  //   builder: () => MyMediaHandler(),
  //   config: AudioServiceConfig(
  //     androidNotificationChannelId: 'media_notification_channel_id',
  //     androidNotificationChannelName: 'Music playback',
  //     androidNotificationOngoing: true,
  //     androidStopForegroundOnPause: true,
  //   ),
  // );
  myTestMediaHandler = await AudioService.init(
    builder: () => MyTestAudioService(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'media_notification_channel_id_test',
      androidNotificationChannelName: 'Music playback Test',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}
