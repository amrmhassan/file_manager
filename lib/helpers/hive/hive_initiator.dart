import 'package:explorer/analyzing_code/storage_analyzer/models/extension_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/models/analyzer_report_info_model.dart';
import 'package:explorer/models/beacon_client.dart';
import 'package:explorer/models/download_task_model.dart';
import 'package:explorer/models/folder_item_info_model.dart';
import 'package:explorer/models/listy_item_model.dart';
import 'package:explorer/models/listy_model.dart';
import 'package:explorer/models/peer_permissions_model.dart';
import 'package:explorer/models/recent_opened_file_model.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/models/white_block_list_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveInitiator {
  Future<void> setup() async {
    await Hive.initFlutter();
    _registerAdapters();
  }

  Future<void> _registerAdapters() async {
    Hive.registerAdapter(AnalyzerReportInfoModelAdapter()); //=>0
    Hive.registerAdapter(DownloadTaskModelAdapter()); //=>1
    Hive.registerAdapter(FolderItemInfoModelAdapter()); //=>2
    Hive.registerAdapter(ListyItemModelAdapter()); //=>3
    Hive.registerAdapter(ListyModelAdapter()); //=>4
    Hive.registerAdapter(RecentOpenedFileModelAdapter()); //=>5
    Hive.registerAdapter(ShareSpaceItemModelAdapter()); //=>6
    Hive.registerAdapter(WhiteBlockListModelAdapter()); //=>7
    Hive.registerAdapter(LocalFileInfoAdapter()); //=>8
    Hive.registerAdapter(LocalFolderInfoAdapter()); //=>9
    Hive.registerAdapter(ExtensionInfoAdapter()); //=>10
    Hive.registerAdapter(EntityTypeAdapter()); //=>11
    Hive.registerAdapter(TaskStatusAdapter()); //=>12
    Hive.registerAdapter(PeerPermissionsModelAdapter()); //=>13
    Hive.registerAdapter(PermissionModelAdapter()); //=>14
    Hive.registerAdapter(PermissionNameAdapter()); //=>15
    Hive.registerAdapter(PermissionStatusAdapter()); //=>16
    Hive.registerAdapter(BeaconClientAdapter()); //=>17
  }
}
