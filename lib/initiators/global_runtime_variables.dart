import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/services/audio_service/my_audio_handler.dart';
import 'package:explorer/utils/models_transformer_utils.dart';
import 'package:explorer/utils/notifications/notification_id_mapper.dart';

bool firstTimeRunApp = false;
bool testing = false;
DownloadsNotificationIDSMapper notificationMapper =
    DownloadsNotificationIDSMapper();

var validPaths = initialDirs.skip(1).map((e) => {
      'path': e.path,
      'type': EntityType.folder,
    });
List<StorageItemModel> explorerMainDisks =
    pathsToStorageItemsWithType(validPaths);

late MyAudioHandler myAudioHandler;
