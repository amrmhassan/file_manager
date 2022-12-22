import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/models/tab_model.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'dart:isolate';
import 'dart:io';
import 'dart:async';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:flutter/material.dart';

abstract class ExplorerProviderAbstract {
  late int activeViewIndex;

  late Directory currentActiveDir;

  String? error;

  SendPort? globalSendPort;

  late bool loadingChildren;

  int? parentSize;

  StreamSubscription? watchDirStreamSub;

  String? get activeTabPath;

  void addTab(String path, FilesOperationsProvider filesOperationsProvider);

  void addToList(List<StorageItemModel> chunk);

  void addToSelectedFromCurrentDir(StorageItemModel s);

  bool get allActiveDirChildrenSelected;

  void changeViewedFName(String oldPath, String newPath);

  void changeViewedFileName(String oldPath, String newPath);

  List<StorageItemModel> get children;

  void clearSelectedFromActiveDir([bool notify = true]);

  void closeTab(String path, FilesOperationsProvider filesOperationsProvider);

  void dispose();

  void goBack({
    required AnalyzerProvider? analyzerProvider,
    required bool sizesExplorer,
    required FilesOperationsProvider filesOperationsProvider,
    required MediaPlayerProvider mediaPlayerProvider,
  });

  void goHome({
    required AnalyzerProvider? analyzerProvider,
    required bool sizesExplorer,
    required FilesOperationsProvider filesOperationsProvider,
  });

  Future loadSortOptions();

  void openTab(String path, FilesOperationsProvider filesOperationsProvider);

  bool get prioritizeFolders;

  void removeFromSelectedFromCurrentDir(String path);

  void removeItemWhenDeleted(String path);

  void runTheIsolate();

  List<StorageItemModel> get selectedFromCurrentActiveDir;

  void setActiveDir({
    required String path,
    AnalyzerProvider? analyzerProvider,
    bool sizesExplorer = false,
    required FilesOperationsProvider filesOperationsProvider,
  });

  void setActivePageIndex(int i);

  void setSortOptions(SortOption s);

  bool get showHiddenFiles;

  SortOption get sortOption;

  List<TabModel> get tabs;

  void togglePriotorizeFolders();

  void toggleShowHiddenFiles();

  void updateCurrentActiveTab(String path);

  void updateParentSize(AnalyzerProvider analyzerProvider);

  void updateSelectedFromActiveDir({
    required FilesOperationsProvider filesOperationsProvider,
  });

  Future<List<StorageItemModel>> viewedChildren(
    BuildContext context, [
    bool sizesExplorer = false,
  ]);
}
