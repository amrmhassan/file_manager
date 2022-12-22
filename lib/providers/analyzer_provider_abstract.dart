import 'package:explorer/models/analyzer_report_info_model.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/extension_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/storage_analyzer_v4.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/advanced_storage_analyzer.dart';

import 'package:explorer/providers/recent_provider.dart';

abstract class AnalyzerProviderAbstract {
  //# storage analyzer data(results)
  get loading;
  bool get savingInfoToSqlite;
  String get currentAnalyzedFolder;
  List<LocalFolderInfo>? get foldersInfo;
  StorageAnalyzerV4? get storageAnalyzerV4;
  List<ExtensionInfo>? get allExtensionInfo;
  AdvancedStorageAnalyzer? get advancedStorageAnalyzer;

  //# getting storage report
  DateTime? lastAnalyzingReportDate;
  AnalyzerReportInfoModel? reportInfo;
  Future<int> getFreeDiskSpace();
  Future<int> getAppsDiskSpace(int totalFilesSize);
  Future<int> getTotalDiskSpace();

  //# initializing scanners
  Future<void> handleAnalyzeEvent(RecentProvider recentProvider);
  Future<void> loadInitialAppData(RecentProvider recentProvider);

  //# other useful methods
  void clearAllData();
  Future<LocalFolderInfo?> getDirInfoByPath(String path);
}
