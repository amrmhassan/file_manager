import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/models/analyzer_report_info_model.dart';
import 'package:explorer/models/download_task_model.dart';
import 'package:explorer/models/folder_item_info_model.dart';
import 'package:explorer/models/listy_item_model.dart';
import 'package:explorer/models/listy_model.dart';
import 'package:explorer/models/recent_opened_file_model.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/white_block_list_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveInitiator {
  Future<void> setup() async {
    await Hive.initFlutter();
    _registerAdapters();
  }

  Future<void> _registerAdapters() async {
    Hive.registerAdapter(AnalyzerReportInfoModelAdapter());
    Hive.registerAdapter(DownloadTaskModelAdapter());
    Hive.registerAdapter(FolderItemInfoModelAdapter());
    Hive.registerAdapter(ListyItemModelAdapter());
    Hive.registerAdapter(ListyModelAdapter());
    Hive.registerAdapter(RecentOpenedFileModelAdapter());
    Hive.registerAdapter(ShareSpaceItemModelAdapter());
    Hive.registerAdapter(WhiteBlockListModelAdapter());
    Hive.registerAdapter(LocalFileInfoAdapter());
  }
}
