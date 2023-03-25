// ignore_for_file: prefer_const_constructors

import 'package:audio_service/audio_service.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:explorer/services/media_service/my_media_handler.dart';

Future mediaPlayersInit() async {
  myMediaHandler = await AudioService.init(
    builder: () => MyMediaHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'media_notification_channel_id',
      androidNotificationChannelName: 'Music playback',
    ),
  );
}
