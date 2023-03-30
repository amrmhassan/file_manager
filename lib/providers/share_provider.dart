// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/shared_pref_constants.dart';
import 'package:explorer/helpers/hive/hive_helper.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

//! when adding a folder to share space all of it's children will be added to it too
//! and when exploring inside this folder check if the file is a child of a shared folder then make the "add to share space" button to be remove from share space
//! and if it is a child of a folder that is excluded from share space just make the opposite
//? share space mean the main items that are in the main view of peer share space, this doesn't include the children of a shared folder or so

enum MemberType {
  host, // who have the hotspot
  client, // who is connected to the host with wifi
}

enum DeviceType {
  android,
  windows,
}

class ShareProvider extends ChangeNotifier {
  //# shared space items properties
  late String myDeviceId;
  final List<ShareSpaceItemModel> _sharedItems = [];
  final List<String> hiddenEntitiesPaths = [];
  String? myImagePath;

  late String myName;

  List<ShareSpaceItemModel> get sharedItems {
    var operated = _sharedItems.map((e) {
      e.size = File(e.path).statSync().size;
      return e;
    }).toList();
    return operated;
  }

  //?
  bool showHideFromShareSpaceButton(Iterable<String> paths) {
    // this will show the button only if the entity is a child of a shared entity, not the entity itself
    for (var path in paths) {
      bool inSharedItems = _sharedItems.any(
          (element) => path.contains(element.path) && path != element.path);
      if (!inSharedItems) {
        return false;
      }

      // if the entity is a child of a hidden item then the button should be viewed also(not the entity itself)
      if (hiddenEntitiesPaths
          .any((element) => path.contains(element) && path != element)) {
        return false;
      }
    }
    return true;
  }

  //?
  Future<void> removeFromHiddenEntities(Iterable<String> paths) async {
    Box box = await HiveBox.hiddenFromShareSpace;
    for (var path in paths) {
      hiddenEntitiesPaths.remove(path);
      notifyListeners();

      box.delete(path);
    }
  }

  //?
  Future<void> addToHiddenEntities(Iterable<String> paths) async {
    Box box = await HiveBox.hiddenFromShareSpace;

    for (var path in paths) {
      if (hiddenEntitiesPaths.contains(path)) continue;
      hiddenEntitiesPaths.add(path);
      notifyListeners();
      await box.put(path, path);
    }
  }

  //?
  Future<void> setMyImagePath(String path) async {
    myImagePath = path;
    notifyListeners();
    await SharedPrefHelper.setString(myImageKey, path);
  }

  //? i will give this device an id in the first run of the app
  //? and if it is there just don't change it
  Future<void> loadDeviceIdAndName() async {
    await _loadDeviceID();
    await _loadMyName();
    await _loadMyImagePath();
  }

  Future<String> _getAndroidName() async {
    var info = await DeviceInfoPlugin().androidInfo;
    String name = ('${info.manufacturer ?? ''} ${info.model ?? ''}');
    if (name.replaceAll(' ', '').isEmpty) {
      return myDefaultName;
    }
    return name;
  }

  Future<String> _getWindowsName() async {
    var info = await DeviceInfoPlugin().windowsInfo;
    String name = info.computerName;
    if (name.replaceAll(' ', '').isEmpty) {
      return myDefaultName;
    }
    return name;
  }

  //? to load my saved name
  Future<void> _loadMyName() async {
    String? savedName = await SharedPrefHelper.getString(myNameKey);

    if (savedName == null) {
      myName = Platform.isWindows
          ? await _getWindowsName()
          : await _getAndroidName();
      notifyListeners();
      await SharedPrefHelper.setString(myNameKey, myName);
      return;
    }
    myName = savedName;
    notifyListeners();
  }

  //? to load my saved name
  Future<void> _loadMyImagePath() async {
    String? savedPath = await SharedPrefHelper.getString(myImageKey);

    if (savedPath == null) return;
    if (!File(savedPath).existsSync()) return;

    myImagePath = savedPath;
    notifyListeners();
  }

  //? to load my saved name
  Future<void> _loadDeviceID() async {
    String? savedId = await SharedPrefHelper.getString(deviceIdKey);

    if (savedId == null) {
      myDeviceId = Uuid().v4();
      notifyListeners();
      await SharedPrefHelper.setString(deviceIdKey, myDeviceId);
      return;
    }

    myDeviceId = savedId;
    notifyListeners();
  }

  Future<void> updateMyName(String newName) async {
    myName = newName;
    notifyListeners();
    await SharedPrefHelper.setString(myNameKey, myName);
  }

  //?
  Future removeImagePath() async {
    myImagePath = null;
    notifyListeners();
    await SharedPrefHelper.removeKey(myImageKey);
  }

  //? to remove multiple items from share space
  Future removeMultipleItemsFromShareSpace(Iterable<String> paths) async {
    for (var item in paths) {
      await _removeItemFromShareSpace(item);
    }
  }

  //? to remove an item from share space
  Future _removeItemFromShareSpace(String path) async {
    // bool notDirectlyShared = _needToBeAddedToHiddenEntities(path);
    // if (notDirectlyShared) {
    //   addToHiddenEntities(path);
    // } else {
    _sharedItems.removeWhere((element) => element.path == path);
    notifyListeners();
    // await DBHelper.deleteById(path, shareSpaceItemsTableName, persistentDbName);
    (await HiveBox.shareSpaceItem).delete(path);
    // }
  }

  //? add multiple files to share space
  Future<List<ShareSpaceItemModel>> addMultipleFilesToShareSpace(
      List<StorageItemModel> items) async {
    List<ShareSpaceItemModel> addedItems = [];
    for (var item in items) {
      if (_sharedItems.any((element) => element.path == item.path)) continue;
      addedItems.add(await _addToShareSpace(item));
    }
    return addedItems;
  }

  //? add file to share space
  Future<ShareSpaceItemModel> _addToShareSpace(
      StorageItemModel storageItemModel) async {
    ShareSpaceItemModel shareSpaceItemModel = ShareSpaceItemModel(
      blockedAt: [],
      entityType: storageItemModel.entityType,
      path: storageItemModel.path,
      ownerDeviceID: myDeviceId,
      addedAt: DateTime.now(),
      ownerSessionID: null,
    );
    _sharedItems.add(shareSpaceItemModel);
    notifyListeners();
    var box = await HiveBox.shareSpaceItem;
    await box.put(shareSpaceItemModel.path, shareSpaceItemModel);
    // await DBHelper.insert(
    //   shareSpaceItemsTableName,
    //   shareSpaceItemModel.toJSON(),
    //   persistentDbName,
    // );
    return shareSpaceItemModel;
  }

  //? to check if multiple items are at share space
  bool areAllItemsAtShareSpace(List<StorageItemModel> items) {
    bool allItemsExist = true;
    for (var item in items) {
      bool atShareSpace = _isItemAtShareSpace(item.path);
      if (!atShareSpace) {
        allItemsExist = false;
        break;
      }
    }
    return allItemsExist;
  }

  bool isHiddenFromShareSpace(Iterable<String> paths) {
    // checking if only one isn't in hidden to return false
    // if all elements are hidden return true
    //-- consider just one element
    // if not exist just return false(not exist)
    for (var path in paths) {
      var res = hiddenEntitiesPaths.any((element) => path == element);
      if (!res) {
        return res;
      }
    }
    return true;
  }

  //? to check if an item is at share space (share space mean the main items that are in the main view of peer share space, this doesn't include the children of a shared folder or so

  bool _isItemAtShareSpace(String path) {
    //! problem
    //! if a folder is added to share space
    //! then sub folder is hidden from share space
    //! then all of the sub folders can't be added to share space anymore

    // checking for existence in sharedItems
    bool exist = false;
    for (var item in _sharedItems) {
      if (path == item.path) {
        exist = true;
        break;
      }
    }
    return exist;
    // if false just return false from here
    // if (!exist) return exist;

    // checking for existence in hidden items from share space or a parent folder of his
    // if (isHiddenFromShareSpace(path)) {
    //   exist = false;
    // }

    // var data = await DBHelper.getDataWhere(
    //   shareSpaceItemsTableName,
    //   pathString,
    //   path,
    //   persistentDbName,
    // );
    // return data.isNotEmpty;
  }

  //? loading shared items from sqlite at app startup
  Future<void> loadSharedItems() async {
    var box = await HiveBox.shareSpaceItem;
    _sharedItems.addAll(box.values.toList().cast());
    // var data =
    //     await DBHelper.getData(shareSpaceItemsTableName, persistentDbName);
    // for (var item in data) {
    //   _sharedItems.add(ShareSpaceItemModel.fromJSON(item));
    // }
    notifyListeners();
  }
}
