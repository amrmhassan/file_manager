import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/foreground_service_controller.dart';
import 'package:explorer/screens/test_screen/test_audio_service.dart';
import 'package:explorer/services/media_service/my_media_handler.dart';
import 'package:explorer/utils/models_transformer_utils.dart';
import 'package:explorer/utils/notifications/notification_id_mapper.dart';
import 'package:flutter/material.dart';

//?
bool firstTimeRunApp = false;
//?
bool testing = false;
//?
DownloadsNotificationIDSMapper notificationMapper =
    DownloadsNotificationIDSMapper();
//?
var validPaths = initialDirs
    .where(
      (element) => element.path != initialDirs.first.path,
    )
    .map((e) => {
          'path': e.path,
          'type': EntityType.folder,
        });
//?
List<StorageItemModel> explorerMainDisks =
    pathsToStorageItemsWithType(validPaths);
//?
late MyMediaHandler myMediaHandler;
//?
ForegroundServiceController foregroundServiceController =
    ForegroundServiceController();
//?
Locale? loadedCurrentLocale;
//?
late MyTestAudioService myTestMediaHandler;

//! windows variables
late String downloadFolder;
