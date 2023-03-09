// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/defaults_constants.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/helpers/hive/hive_helper.dart';
import 'package:explorer/models/listy_item_model.dart';
import 'package:explorer/models/listy_model.dart';
import 'package:explorer/models/types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ListyProvider extends ChangeNotifier {
  List<ListyModel> _listy = [];

  List<ListyModel> get listyList {
    return [..._listy];
  }

  //? load listy lists
  Future loadListyLists() async {
    try {
      var box = await HiveBox.listy;
      if (box.values.isEmpty) {
        _listy = [...defaultListyList];
        notifyListeners();
        box.add(defaultListyList.first);
        return;
      }
      _listy = box.values.toList().cast();
      notifyListeners();
    } catch (e) {
      logger.e(e);
    }
  }

//? to create a new listy
  Future addListy({
    required String title,
    String? icon,
    bool throwError = true,
  }) async {
    DateTime createdAt = DateTime.now();
    String iconPath = icon ?? 'assets/icons/listy.png';
    bool titleExists = _listy.any((element) => element.title == title);
    if (titleExists && throwError) {
      throw Exception('This list already exist');
    } else if (titleExists) {
      return;
    }
    ListyModel listyModel = ListyModel(
      id: Uuid().v4(),
      title: title,
      createdAt: createdAt,
      icon: iconPath,
    );
    _listy.add(listyModel);
    notifyListeners();
    var box = await HiveBox.listy;
    await box.add(listyModel);
  }

  //? to check if an entity is in a list
  Future<bool> itemExistInAListy({
    required String path,
    required String listyTitle,
  }) async {
    //! the error happens here
    String id = listyByTitle(listyTitle).id;
    var data = [
      ...(await HiveBox.customBox(id))
          .values
          .where((element) => element.path == path)
          .toList()
          .cast()
    ];

    return data.isNotEmpty;
  }

  ListyModel listyByTitle(String title) {
    return _listy.firstWhere((element) => element.title == title);
  }

  //? add item to listy
  Future<void> addItemToListy({
    required String path,
    required String listyTitle,
    required EntityType entityType,
  }) async {
    //* checking if the item already exists in the list
    bool exist = await itemExistInAListy(path: path, listyTitle: listyTitle);
    if (exist) {
      throw Exception('Item already exist in that list');
    }
    ListyItemModel listyItemModel = ListyItemModel(
      id: Uuid().v4(),
      path: path,
      listyTitle: listyTitle,
      createdAt: DateTime.now(),
      entityType: entityType,
    );
    String id = listyByTitle(listyTitle).id;
    await (await HiveBox.customBox(id))
        .put(listyItemModel.path, listyItemModel);
  }

//? to delete item from listy
  Future<void> removeItemFromListy({
    required String path,
    required String listyTitle,
  }) async {
    String id = listyByTitle(listyTitle).id;

    (await HiveBox.customBox(id)).delete(path);
  }

  //? get listy items
  Future<List<ListyItemModel>> getListyItems(String listyTitle) async {
    String id = listyByTitle(listyTitle).id;

    var box = await HiveBox.customBox(id);
    return box.values.toList().cast();
  }

//? remove a whole listy
  Future removeListy(String listyTitle) async {
    int index = _listy.indexWhere((element) => element.title == listyTitle);
    String id = listyByTitle(listyTitle).id;
    _listy.removeAt(index);
    notifyListeners();

    (await HiveBox.customBox(id)).deleteFromDisk();
    (await HiveBox.listy).deleteAt(index);
  }
}
