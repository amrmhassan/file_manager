// ignore_for_file: prefer_const_constructors

import 'package:explorer/helpers/hive/hive_helper.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:explorer/models/entity_clicked_model.dart';
import 'package:explorer/providers/media_player_provider/media_player_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/shared_pref_constants.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:explorer/helpers/string_to_type.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/tab_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/isolates/load_folder_children_isolates.dart';
import 'package:explorer/utils/directory_watchers.dart';
import 'package:explorer/utils/screen_utils/children_view_utils.dart';

Map<String, String> mainDisksMapper = {};

class ExplorerProvider extends ChangeNotifier {
  // this will indicate that the mode is just to view the downloaded file or folder

  String? viewedFilePath;
  void setViewedFilePath(String? p) {
    viewedFilePath = p;
    notifyListeners();
  }

  int activeViewIndex = 0;

  void setActivePageIndex(int i) {
    activeViewIndex = i;
    notifyListeners();
  }

  String? _activeTabPath;

  String? get activeTabPath {
    if (_tabs.isNotEmpty && _activeTabPath == null) {
      return _tabs.first.path;
    }
    return _activeTabPath;
  }

  final List<TabModel> _tabs = [];

  List<TabModel> get tabs => [..._tabs];

  final List<StorageItemModel> _children = [];

  List<StorageItemModel> get children => [..._children];

  SendPort? globalSendPort;

  bool loadingChildren = false;

  String? error;

  Directory currentActiveDir = initialDirs.first;

  StreamSubscription<FileSystemEntity>? streamSub;

  StreamSubscription? watchDirStreamSub;

  int? parentSize;

  //# sorting options
  //? sort parameters
  SortOption _sortOption = defaultSortOption;

  SortOption get sortOption => _sortOption;
  bool _prioritizeFolders = defaultPriotorizeFolders;

  bool get prioritizeFolders => _prioritizeFolders;
  bool _showHiddenFiles = defaultShowHiddenFiles;

  bool get showHiddenFiles => _showHiddenFiles;

  //? to set the sort option

  void setSortOptions(SortOption s) async {
    _sortOption = s;
    notifyListeners();
    await SharedPrefHelper.setString(sortOptionKey, _sortOption.name);
  }

  //? to set priotorize folders

  void togglePriotorizeFolders() async {
    _prioritizeFolders = !_prioritizeFolders;
    notifyListeners();
    await SharedPrefHelper.setBool(priotorizeFoldersKey, _prioritizeFolders);
  }

  //? to set show hidden files

  void toggleShowHiddenFiles() async {
    _showHiddenFiles = !_showHiddenFiles;
    notifyListeners();
    await SharedPrefHelper.setBool(showHiddenFilesKey, _showHiddenFiles);
  }

  //? to load sort options when app loaded

  Future loadSortOptions() async {
    String? sortOptionString = await SharedPrefHelper.getString(sortOptionKey);
    bool? prioritizeFoldersLoadedBool =
        await SharedPrefHelper.getBool(priotorizeFoldersKey);
    bool? showHiddenFilesLoadedBool =
        await SharedPrefHelper.getBool(showHiddenFilesKey);

    SortOption sortOptionLoaded = sortOptionString == null
        ? defaultSortOption
        : stringToEnum(sortOptionString, SortOption.values);
    bool priotorizeLoaded =
        prioritizeFoldersLoadedBool ?? defaultPriotorizeFolders;
    bool showHiddenFilesLoaded =
        showHiddenFilesLoadedBool ?? defaultShowHiddenFiles;

    _sortOption = sortOptionLoaded;
    _prioritizeFolders = priotorizeLoaded;
    _showHiddenFiles = showHiddenFilesLoaded;
    notifyListeners();
  }
  //# end of sort options

  //? to run the isolate in the background
  ExplorerProvider() {
    runTheIsolate();
  }

  //? to change viewed file name

  void changeViewedFileName(String oldPath, String newPath) {
    File newFile = File(newPath);
    FileStat fileStat = newFile.statSync();
    StorageItemModel newItem = StorageItemModel(
      parentPath: newFile.parent.path,
      path: newFile.path,
      modified: fileStat.modified,
      accessed: fileStat.accessed,
      changed: fileStat.changed,
      entityType: EntityType.file,
      size: fileStat.size,
    );
    int index = _children.indexWhere((element) => element.path == oldPath);
    _children.removeAt(index);
    _children.insert(index, newItem);
  }

  //? void remove item when deleted

  void removeItemWhenDeleted(String path) {
    _children.removeWhere((element) => element.path == path);
    notifyListeners();
  }

  //? to change viewed file name

  void changeViewedFolderName(String oldPath, String newPath) {
    Directory newDir = Directory(newPath);
    FileStat fileStat = newDir.statSync();
    StorageItemModel newItem = StorageItemModel(
      parentPath: newDir.parent.path,
      path: newDir.path,
      modified: fileStat.modified,
      accessed: fileStat.accessed,
      changed: fileStat.changed,
      entityType: EntityType.folder,
      size: fileStat.size,
    );
    int index = _children.indexWhere((element) => element.path == oldPath);
    _children.removeAt(index);
    _children.insert(index, newItem);
  }

  //? selected from the current active folder
  List<StorageItemModel> _selectedFromCurrentActiveDir = [];

  List<StorageItemModel> get selectedFromCurrentActiveDir {
    return [..._selectedFromCurrentActiveDir];
  }

  //? to add to the selected from current dir

  void addToSelectedFromCurrentDir(StorageItemModel s) {
    if (!_selectedFromCurrentActiveDir
        .any((element) => element.path == s.path)) {
      _selectedFromCurrentActiveDir.add(s);
      notifyListeners();
    }
  }

  //? to remove from the selected from current dir

  void removeFromSelectedFromCurrentDir(String path) {
    _selectedFromCurrentActiveDir.removeWhere(
      (element) => element.path == path,
    );
    notifyListeners();
  }

  //? to clear the ...

  void clearSelectedFromActiveDir([bool notify = true]) {
    _selectedFromCurrentActiveDir.clear();
    if (notify) notifyListeners();
  }

  //? is all in the current active folder selected or not

  bool get allActiveDirChildrenSelected {
    return _selectedFromCurrentActiveDir.length == _children.length;
  }

  //? to update the parent size if in sizes explorer mode

  void updateParentSize(AnalyzerProvider analyzerProvider) async {
    //? here i will update the current active dir size
    LocalFolderInfo? localFolderInfo =
        await analyzerProvider.getDirInfoByPath(currentActiveDir.path);
    if (localFolderInfo != null && localFolderInfo.size != null) {
      parentSize = localFolderInfo.size;
      notifyListeners();
    }
  }

  Future<List<StorageItemModel>> viewedChildren(
    BuildContext context, [
    bool sizesExplorer = false,
  ]) async {
    if (sizesExplorer) {
      List<StorageItemModel> items = [];

      for (var i = 0; i < _children.length; i++) {
        StorageItemModel child = _children[i];
        int? entitySize;
        if (child.entityType == EntityType.folder) {
          LocalFolderInfo? localFolderInfo =
              await Provider.of<AnalyzerProvider>(context, listen: false)
                  .getDirInfoByPath(child.path);
          if (localFolderInfo != null) {
            entitySize = localFolderInfo.size ?? 0;
          }
        } else {
          FileStat fileStat = await File(child.path).stat();
          entitySize = fileStat.size;
        }
        StorageItemModel updatedStorageItemModel = StorageItemModel(
          parentPath: child.parentPath,
          path: child.path,
          modified: child.modified,
          accessed: child.accessed,
          changed: child.changed,
          entityType: child.entityType,
          size: entitySize,
        );
        items.add(updatedStorageItemModel);
      }
      items.sort(
        (a, b) => (b.size ?? 0).compareTo(a.size ?? 0),
      );
      return items;
    } else {
      List<EntityClickedModel>? factoringItems;
      if (_sortOption == SortOption.frequentlyOpened) {
        factoringItems = await _getUsageData(_children.map((e) => e.path));
      }
      return getFixedEntityList(
        viewedChildren: _children,
        showHiddenFiles: _showHiddenFiles,
        prioritizeFolders: _prioritizeFolders,
        sortOption: _sortOption,
        factoringItems: factoringItems,
      );
    }
  }

  bool goBack({
    required AnalyzerProvider? analyzerProvider,
    required bool sizesExplorer,
    required FilesOperationsProvider filesOperationsProvider,
    required MediaPlayerProvider mediaPlayerProvider,
  }) {
    if (mediaPlayerProvider.videoPlayerController != null &&
        !mediaPlayerProvider.videoHidden) {
      mediaPlayerProvider.togglePlayerHidden();
      return true;
    }
    if (initialDirs.any((element) => element.path == currentActiveDir.path)) {
      return false;
    }
    if (currentActiveDir.parent.path == '.') return false;
    setActiveDir(
      path: currentActiveDir.parent.path,
      sizesExplorer: sizesExplorer,
      analyzerProvider: analyzerProvider,
      filesOperationsProvider: filesOperationsProvider,
    );
    return true;
  }

  //? go home

  void goHome({
    required AnalyzerProvider? analyzerProvider,
    required bool sizesExplorer,
    required FilesOperationsProvider filesOperationsProvider,
  }) {
    setActiveDir(
      path: initialDirs.first.path,
      analyzerProvider: analyzerProvider,
      sizesExplorer: sizesExplorer,
      filesOperationsProvider: filesOperationsProvider,
    );
  }

  //? update the selected items from the current dir when ever the active dir changes
  void updateSelectedFromActiveDir({
    required FilesOperationsProvider filesOperationsProvider,
  }) {
    _selectedFromCurrentActiveDir = filesOperationsProvider.selectedItems
        .where((element) => element.parentPath == currentActiveDir.path)
        .toList();
    notifyListeners();
  }

  //? update the active dir

  void setActiveDir({
    required String path,
    AnalyzerProvider? analyzerProvider,
    bool sizesExplorer = false,
    required FilesOperationsProvider filesOperationsProvider,
  }) {
    // because init dirs will always start with "/" path, so if the  current path is "/" and it only has 2 items, so set the current active dir to be the last item, which is the second item
    if (path == initialDirs.first.path && initialDirs.length <= 2) {
      return setActiveDir(
        path: initialDirs.last.path,
        filesOperationsProvider: filesOperationsProvider,
      );
    }
    //* update the current active tab
    //! update the current active tab to be the same as the new open directory
    // _activeTabPath = path;
    // int index = _tabs.indexWhere((element) => element.path == path);
    // TabModel activeTab = _tabs[index];
    // activeTab.path = path;
    // _tabs[index] = activeTab;
    updateCurrentActiveTab(path);
    //* updating the current active tab
    currentActiveDir = Directory(path);
    //* run folder watchers
    _runActiveDirWatchers();
    updateSelectedFromActiveDir(
        filesOperationsProvider: filesOperationsProvider);

    _updateViewedChildren();
    if (sizesExplorer && analyzerProvider != null) {
      updateParentSize(analyzerProvider);
    }
  }

  //? add chunk to children list

  void addToList(List<StorageItemModel> chunk) {
    _children.addAll(chunk);
    notifyListeners();
  }

  //? trying isolates with the provider

  void runTheIsolate() {
    var receivePort = ReceivePort();
    var sendPort = receivePort.sendPort;
    Isolate.spawn(loadExplorerChildren, sendPort);
    receivePort.listen((message) {
      if (message is SendPort) {
        globalSendPort = message;
      } else if (message is LoadChildrenMessagesData) {
        if (message.flag == LoadChildrenMessagesFlags.childrenChunk) {
          _children.addAll(message.data);
          notifyListeners();
        } else if (message.flag == LoadChildrenMessagesFlags.done) {
          _children.addAll(message.data);
          loadingChildren = false;
          notifyListeners();
        } else if (message.flag == LoadChildrenMessagesFlags.error) {
          logger.e(message.data);
          error = error.toString();
          notifyListeners();
        }
      }
    });
  }

  //? update viewed children
  void _updateViewedChildren() async {
    error = null;
    loadingChildren = true;
    _children.clear();
    notifyListeners();
    if (currentActiveDir.path == initialDirs.first.path) {
      _children.addAll(explorerMainDisks);
      loadingChildren = false;
      notifyListeners();
    } else if (globalSendPort != null) {
      // _children.addAll(initialDir)
      globalSendPort!.send(currentActiveDir.path);
    }
  }

  //? to run watchers
  void _runActiveDirWatchers() {
    if (currentActiveDir.path == initialDirs.first.path) return;
    DirectoryWatchers directoryWatchers =
        DirectoryWatchers(currentActiveDir: currentActiveDir);
    //* add entity watcher
    directoryWatchers.createWatcher(callback: (storageItemModel) {
      bool contain = false;
      for (var entity in _children) {
        if (entity.path == storageItemModel.path) {
          contain = true;
          break;
        }
      }

      bool allowAdding =
          !contain && (currentActiveDir.path == storageItemModel.parentPath);
      if (allowAdding) {
        _children.add(storageItemModel);
        notifyListeners();
      }
    });
  }

  //? add a new tab

  void addTab(String path, FilesOperationsProvider filesOperationsProvider,
      [bool doOpenTab = true]) {
    bool exists = _tabs.any((element) => element.path == path);
    if (exists) {
      throw Exception('Tab is already open');
    }
    if (_tabs.isEmpty) {
      TabModel oldTab = TabModel(path: currentActiveDir.path);
      _tabs.add(oldTab);
    }
    TabModel newTab = TabModel(path: path);
    _tabs.add(newTab);
    if (_activeTabPath == null && doOpenTab) {
      openTab(path, filesOperationsProvider);
    }
    notifyListeners();
  }

  //? open tab

  void openTab(String path, FilesOperationsProvider filesOperationsProvider) {
    if (!_tabs.any((element) => element.path == path)) {
      addTab(path, filesOperationsProvider, false);
    }
    _activeTabPath = path;
    setActiveDir(path: path, filesOperationsProvider: filesOperationsProvider);
    notifyListeners();
  }

//? close tab

  void closeTab(String path, FilesOperationsProvider filesOperationsProvider) {
    int index = _tabs.indexWhere((element) => element.path == path);
    int length = _tabs.length;
    bool activeTab = path == activeTabPath;

    if (activeTab && length > 1) {
      _activeTabPath = _tabs[index - 1 < 0 ? index + 1 : index - 1].path;
      openTab(_activeTabPath!, filesOperationsProvider);
    }
    _tabs.removeAt(index);
    notifyListeners();
  }

  //? to update the current active tab when opening new one

  void updateCurrentActiveTab(String path) {
    if (_tabs.isEmpty) return;
    //* if the path already exists in a tab just activate that tab
    bool exists = _tabs.any((element) => element.path == path);
    if (exists) {
      _activeTabPath = path;
      notifyListeners();
      return;
    }
    //* if not just update the current active tab to be equal to the path, and update the current active tab path
    //* to return if there is no active tab
    if (_activeTabPath == null) return;
    int index = _tabs.indexWhere((element) => _activeTabPath == element.path);
    TabModel tabModel = TabModel(path: path);
    _tabs[index] = tabModel;
    _activeTabPath = path;
    notifyListeners();
  }

  //# frequently opened feature
  // this forgetting factor is
  // int forgettingFactor = 1;

  List<EntityClickedModel> _allItems = [];
  // this will be used to wait until the clicking action saves then load the new ones after clicking the new folder
  Completer? _stillSavingCompleter;
  // this will run each time a new dir is clicked and sort option is frequently opened
  //? this function will run before the increase function because items will be empty at first until it gets filled
  //? running this function, then the allItems will be updated continuously
  Future<List<EntityClickedModel>> _getUsageData(
    Iterable<String> childrenItems,
  ) async {
    if (_allItems.isEmpty) {
      if (_stillSavingCompleter != null) {
        await _stillSavingCompleter!.future;
      }
      var box = await HiveBox.entityClickedBox;
      _allItems = box.values.toList().cast();

      var matchedItems = childrenItems.map((e) => _getClickedModel(e));
      return matchedItems.toList();
    } else {
      var matchedItems = childrenItems.map((e) => _getClickedModel(e));
      return matchedItems.toList();
    }
  }

// this will be called whenever an entity is being clicked
  Future<void> increaseClickedItem(String path) async {
    _stillSavingCompleter = Completer();
    var box = await HiveBox.entityClickedBox;
    EntityClickedModel? fetchedItem = box.get(path);
    int timesClicked = _arrangeFactorInt(fetchedItem);

    int newClicks = timesClicked + 1;
    DateTime now = DateTime.now();
    EntityClickedModel itemToSave = EntityClickedModel(
      path: path,
      times: newClicks,
      lastTimeClicked: now.toIso8601String(),
    );
    _updateClickedItem(path, itemToSave);

    _stillSavingCompleter?.complete();
    await box.put(itemToSave.path, itemToSave);
  }

  int _arrangeFactorInt(EntityClickedModel? arrangeModel) {
    if (arrangeModel == null) return 0;
    double factor = getArrangeFactor(arrangeModel);
    if (factor < 0) {
      return 0;
    } else {
      return factor.toInt();
    }
  }

  EntityClickedModel _getClickedModel(String path) {
    EntityClickedModel? model;
    try {
      model = _allItems.firstWhere((element) => element.path == path);
    } catch (e) {
      // item doesn't exist in the box yet
    }
    model = model ??
        EntityClickedModel(
          path: path,
          times: 0,
          lastTimeClicked: DateTime.now().toIso8601String(),
        );
    return model;
  }

  void _updateClickedItem(String path, EntityClickedModel newModel) {
    int index = _allItems.indexWhere((element) => element.path == path);
    if (index == -1) {
      // item doesn't exist yet
      _allItems.add(newModel);
    } else {
      _allItems[index] = newModel;
    }
  }
}
