// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/shared_pref_constants.dart';
import 'package:explorer/helpers/db_helper.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

//! when adding a folder to share space all of it's children will be added to it too
//! and when exploring inside this folder check if the file is a child of a shared folder then make the "add to share space" button to be remove from share space
//! and if it is a child of a folder that is excluded from share space just make the opposite

enum MemberType {
  host, // who have the hotspot
  client, // who is connected to the host with wifi
}

class ShareProvider extends ChangeNotifier {
  //# shared space items properties
  late String myDeviceId;
  final List<ShareSpaceItemModel> _sharedItems = [];

  List<ShareSpaceItemModel> get sharedItems {
    var operated = _sharedItems.map((e) {
      e.size = File(e.path).statSync().size;
      return e;
    }).toList();
    return operated;
  }

  //? i will give this device an id in the first run of the app
  //? and if it is there just don't change it
  Future<void> giveDeviceAnId() async {
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

  //? to remove multiple items from share space
  Future removeMultipleItemsFromShareSpace(List<StorageItemModel> items) async {
    for (var item in items) {
      await _removeItemFromShareSpace(item.path);
    }
  }

  //? to remove an item from share space
  Future _removeItemFromShareSpace(String path) async {
    _sharedItems.removeWhere((element) => element.path == path);
    notifyListeners();
    await DBHelper.deleteById(path, shareSpaceItemsTableName, persistentDbName);
  }

  //? add multiple files to share space
  Future<List<ShareSpaceItemModel>> addMultipleFilesToShareSpace(
      List<StorageItemModel> items) async {
    List<ShareSpaceItemModel> addedItems = [];
    for (var item in items) {
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
    await DBHelper.insert(
      shareSpaceItemsTableName,
      shareSpaceItemModel.toJSON(),
      persistentDbName,
    );
    return shareSpaceItemModel;
  }

  //? to check if multiple items are at share space
  Future<bool> areAllItemsAtShareSpace(List<StorageItemModel> items) async {
    bool allItemsExist = true;
    for (var item in items) {
      bool atShareSpace = await _isItemAtShareSpace(item.path);
      if (!atShareSpace) {
        allItemsExist = false;
        break;
      }
    }
    return allItemsExist;
  }

  //? to check if an item is at share space
  Future<bool> _isItemAtShareSpace(String path) async {
    var data = await DBHelper.getDataWhere(
      shareSpaceItemsTableName,
      pathString,
      path,
      persistentDbName,
    );
    return data.isNotEmpty;
  }

//? loading shared items from sqlite
  Future<void> loadSharedItems() async {
    var data =
        await DBHelper.getData(shareSpaceItemsTableName, persistentDbName);
    for (var item in data) {
      _sharedItems.add(ShareSpaceItemModel.fromJSON(item));
    }
    notifyListeners();
  }
}
