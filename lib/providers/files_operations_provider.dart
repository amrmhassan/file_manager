// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/helpers/db_helper.dart';
import 'package:explorer/isolates/folder_info_isolates.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/utils/files_operations_utils/copy_utils.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path_operations;
import 'package:share_plus/share_plus.dart' as share_plus;

enum FileOperation {
  delete,
  move,
  copy,
  send,
}

enum ExploreMode {
  selection,
  normal,
}

class FilesOperationsProvider extends ChangeNotifier {
  final List<StorageItemModel> _selectedItems = [];
  List<StorageItemModel> get selectedItems {
    return [..._selectedItems];
  }

  FileOperation? currentOperation;

  bool _loadingOperation = false;
  bool get loadingOperation {
    return _loadingOperation;
  }

//? rename folder
  Future<void> performRenameFolder({
    required String newFolderName,
    required String folderPath,
    required ExplorerProvider explorerProvider,
  }) async {
    _loadingOperation = true;
    notifyListeners();
    String newPath =
        '${(folderPath.split('/')..removeLast()).join('/')}/$newFolderName';
    bool containTheSameName =
        explorerProvider.children.any((element) => element.path == newPath);
    if (containTheSameName) {
      throw Exception('The folder Contain The same Name');
    }
    await compute(
        (message) => renameFolder(
              newPath: newPath,
              folderPath: folderPath,
            ),
        '');
    explorerProvider.changeViewedFName(folderPath, newPath);

    _loadingOperation = false;
    clearAllSelectedItems(explorerProvider);

    notifyListeners();
  }

//? rename file
  Future<void> performRenameFile({
    required String newFileName,
    required String filePath,
    required ExplorerProvider explorerProvider,
  }) async {
    _loadingOperation = true;
    notifyListeners();
    String newPath =
        '${(filePath.split('/')..removeLast()).join('/')}/$newFileName';
    bool containTheSameName =
        explorerProvider.children.any((element) => element.path == newPath);
    if (containTheSameName) {
      throw Exception('The folder Contain The same Name');
    }
    await compute(
        (message) => renameFile(
              newPath: newPath,
              filePath: filePath,
            ),
        '');
    explorerProvider.changeViewedFileName(filePath, newPath);
    _loadingOperation = false;
    clearAllSelectedItems(explorerProvider);
    notifyListeners();
  }

//? select all
  void selectAll(
      List<StorageItemModel> dirChildren, ExplorerProvider explorerProvider) {
    for (var element in dirChildren) {
      _addToSelectedItems(element);
      explorerProvider.addToSelectedFromCurrentDir(element);
    }
  }

//? select all
  void deselectAll(
      List<StorageItemModel> dirChildren, ExplorerProvider explorerProvider) {
    for (var element in dirChildren) {
      _removeFromSelectedItems(element.path);
      explorerProvider.removeFromSelectedFromCurrentDir(element.path);
    }
  }

//? delete files
  Future<void> performDelete(ExplorerProvider explorerProvider) async {
    List<StorageItemModel> items = [..._selectedItems];
    _loadingOperation = true;
    currentOperation = null;
    _selectedItems.clear();

    notifyListeners();
    for (var entity in items) {
      try {
        if (entity.entityType == EntityType.file) {
          await compute((m) => deleteFile(entity.path), '');
        } else {
          await compute((m) => deleteFolder(entity.path), '');
        }
        explorerProvider.removeItemWhenDeleted(entity.path);
      } catch (e) {
        rethrow;
      }
    }

    _loadingOperation = false;
    notifyListeners();
  }

//? copy files
  Future<void> performCopy(String currentActiveDir) async {
    List<StorageItemModel> items = [..._selectedItems];
    FileOperation localOperation =
        FileOperation.values[currentOperation!.index];
    _loadingOperation = true;
    currentOperation = null;
    _selectedItems.clear();
    notifyListeners();

//* don't remove the copied folders when it is cut until the whole files and folders are copied successfully
    for (var entity in items) {
      try {
        if (entity.entityType == EntityType.file) {
          await compute((m) => copyFile(entity.path, currentActiveDir), '');
        } else {
          await compute(
              (message) => copyFolder(entity.path, currentActiveDir), '');
        }
      } catch (e) {
        rethrow;
      }
    }
    //* delete after all files copied
    if (localOperation == FileOperation.move) {
      for (var entity in items) {
        if (entity.entityType == EntityType.file) {
          await compute((message) => deleteFile(entity.path), '');
        } else {
          await compute((message) => deleteFolder(entity.path), '');
        }
      }
    }

    _loadingOperation = false;
    notifyListeners();
  }

//? to clear selected items
  void clearAllSelectedItems(ExplorerProvider explorerProvider,
      [bool notify = true]) {
    _selectedItems.clear();
    //* clear the current operation
    currentOperation = null;
    explorerProvider.clearSelectedFromActiveDir(notify);
    notifyListeners();
  }

//? apply the operation
  void applyOperation(String dest) {
    //! here i will check for the current operation and apply it, then delete the current operation
    //! copy , delete, move, send
  }
  //? to set an operation
  void setOperation(FileOperation? fo) {
    currentOperation = fo;
    notifyListeners();
  }

  //? to return if a storage  item is selected
  bool isSelected(String path) {
    return _selectedItems.any((element) => element.path == path);
  }

//? to get the selection mode if selected items isn't empty and normal if empty
  ExploreMode get exploreMode {
    //* if the current operation isn't null then prevent the user from selecting new elements, or removing from them
    if (currentOperation != null) return ExploreMode.normal;
    return _selectedItems.isEmpty ? ExploreMode.normal : ExploreMode.selection;
  }

//? add to selected items
  void _addToSelectedItems(StorageItemModel s) {
    if (!_selectedItems.any((element) => element.path == s.path)) {
      _selectedItems.add(s);
      notifyListeners();
    }
  }

  //? remove from selected items
  void _removeFromSelectedItems(String path) {
    _selectedItems.removeWhere((element) => element.path == path);
    notifyListeners();
  }

//? to toggle from selected items
  void toggleFromSelectedItems(
      StorageItemModel s, ExplorerProvider explorerProvider) {
    //* prevent any adding or removing to or from selected items if the operation is selected
    if (currentOperation != null) return;
    if (_selectedItems.any((element) => element.path == s.path)) {
      explorerProvider.removeFromSelectedFromCurrentDir(s.path);
      return _removeFromSelectedItems(s.path);
    }
    explorerProvider.addToSelectedFromCurrentDir(s);
    return _addToSelectedItems(s);
  }

  //? create new folder
  void createFolder(
    String newFolderName,
    ExplorerProvider explorerProvider,
  ) {
    bool allowCreation = true;
    Directory parent = explorerProvider.currentActiveDir;
    List<StorageItemModel> children = explorerProvider.children;
    for (var entity in children) {
      if (entity.entityType == EntityType.folder) {
        if (path_operations.basename(entity.path) == newFolderName) {
          allowCreation = false;
          break;
        }
      }
    }
    if (allowCreation) {
      Directory newDir = Directory('${parent.path}/$newFolderName');
      newDir.createSync();
    } else {
      throw Exception('This Folder already exists');
    }
  }

  //? to share files
  void shareFiles(ExplorerProvider explorerProvider) async {
    List<StorageItemModel> sI = _selectedItems;
    List<String> items = [];
    _loadingOperation = true;
    notifyListeners();
    //! here loading the folder children
    for (var item in sI) {
      if (item.entityType == EntityType.file) {
        items.add(item.path);
      } else {
        List<FileSystemEntity> folderChildren =
            await compute(getFolderAllItems, item.path);
        for (var element in folderChildren) {
          if (!items.contains(element.path) &&
              element.statSync().type == FileSystemEntityType.file) {
            items.add(element.path);
          }
        }
      }
    }

    //! this might have a problem in the future
    await share_plus.Share.shareFiles(
      items,
      subject: 'Share Files',
      text: 'Share Items',
    );
    _loadingOperation = false;
    clearAllSelectedItems(explorerProvider);
    notifyListeners();
  }

  //? to copy the db to sdcard to view it
  void copyDB() async {
    String dbPath = await DBHelper.getDbPath(tempDbName);
    File oldDb = File('sdcard/$tempDbName');
    if (oldDb.existsSync()) {
      oldDb.deleteSync();
    }
    File copiedFile = copyFile(dbPath, 'sdcard');
    printOnDebug(copiedFile.path);
  }
}
