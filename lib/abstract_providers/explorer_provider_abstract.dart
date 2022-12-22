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
  //# active page index (for the home page) explorer or the recent screen
  late int activeViewIndex;
  void setActivePageIndex(int i);

  //# the current active directory, it's children are viewed in the explorer list
  late Directory currentActiveDir;
  void setActiveDir({
    required String path,
    AnalyzerProvider? analyzerProvider,
    bool sizesExplorer = false,
    required FilesOperationsProvider filesOperationsProvider,
  });

  //# explorer tabs
  String? get activeTabPath;
  List<TabModel> get tabs;
  void addTab(String path, FilesOperationsProvider filesOperationsProvider);
  void closeTab(String path, FilesOperationsProvider filesOperationsProvider);
  void openTab(String path, FilesOperationsProvider filesOperationsProvider);
  void updateCurrentActiveTab(String path);

  //# viewed children and their methods
  int? parentSize;
  late bool loadingChildren;
  List<StorageItemModel> get children;
  Future<List<StorageItemModel>> viewedChildren(
    BuildContext context, [
    bool sizesExplorer = false,
  ]);
  void addToList(List<StorageItemModel> chunk);
  void updateParentSize(AnalyzerProvider analyzerProvider);

  //# sorting children
  bool get prioritizeFolders;
  bool get showHiddenFiles;
  SortOption get sortOption;
  Future loadSortOptions();
  void setSortOptions(SortOption s);
  void togglePriotorizeFolders();
  void toggleShowHiddenFiles();

  //# streams subscriptions
  StreamSubscription? watchDirStreamSub;
  StreamSubscription<FileSystemEntity>? streamSub;

  //# send ports
  SendPort? globalSendPort;

  //# editing entities info utils, when making a file operation
  void changeViewedFolderName(String oldPath, String newPath);
  void changeViewedFileName(String oldPath, String newPath);
  void removeItemWhenDeleted(String path);

  //# selected items
  bool get allActiveDirChildrenSelected;
  List<StorageItemModel> get selectedFromCurrentActiveDir;
  void addToSelectedFromCurrentDir(StorageItemModel s);
  void clearSelectedFromActiveDir([bool notify = true]);
  void removeFromSelectedFromCurrentDir(String path);
  void updateSelectedFromActiveDir({
    required FilesOperationsProvider filesOperationsProvider,
  });

  //# explorer navigation
  String? error;
  void goHome({
    required AnalyzerProvider? analyzerProvider,
    required bool sizesExplorer,
    required FilesOperationsProvider filesOperationsProvider,
  });
  void goBack({
    required AnalyzerProvider? analyzerProvider,
    required bool sizesExplorer,
    required FilesOperationsProvider filesOperationsProvider,
    required MediaPlayerProvider mediaPlayerProvider,
  });

//# important methods for the class to run
  void runTheIsolate();
}
