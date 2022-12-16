// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/defaults_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/db_helper.dart';
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
    var data = await DBHelper.getData(listyListTableName, persistentDbName);
    if (data.isEmpty) {
      _listy = [...defaultListyList];
      notifyListeners();
      await DBHelper.insert(
        listyListTableName,
        defaultListyList.first.toJSON(),
        persistentDbName,
      );
      return;
    }
    for (var listy in data) {
      _listy.add(ListyModel.fromJSON(listy));
    }
    notifyListeners();
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
      title: title,
      createdAt: createdAt,
      icon: iconPath,
    );
    _listy.add(listyModel);
    notifyListeners();
    await DBHelper.insert(
      listyListTableName,
      listyModel.toJSON(),
      persistentDbName,
    );
  }

  //? to check if an entity is in a list
  Future<bool> itemExistInAListy({
    required String path,
    required String listyTitle,
  }) async {
    //! the error happens here
    var data = await DBHelper.getDataWhereMultiple(
      listyItemsTableName,
      [listyTitleString, pathString],
      [listyTitle, path],
      persistentDbName,
    );

    return data.isNotEmpty;
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

    await DBHelper.insert(
      listyItemsTableName,
      listyItemModel.toJSON(),
      persistentDbName,
    );
  }

//? to delete item from listy
  Future<void> removeItemFromListy({
    required String path,
    required String listyTitle,
  }) async {
    await DBHelper.deleteDataWhereMultiple(
      listyItemsTableName,
      [listyTitleString, pathString],
      [listyTitle, path],
      persistentDbName,
    );
  }

  //? get listy items
  Future<List<ListyItemModel>> getListyItems(String listyTitle) async {
    var data = await DBHelper.getDataWhereMultiple(
      listyItemsTableName,
      [listyTitleString],
      [listyTitle],
      persistentDbName,
    );
    return data.map((e) => ListyItemModel.fromJSON(e)).toList();
  }

  Future removeListy(String listyTitle) async {
    await DBHelper.deleteDataWhereMultiple(
      listyListTableName,
      [titleString],
      [listyTitle],
      persistentDbName,
    );
    _listy.removeWhere((element) => element.title == listyTitle);
    notifyListeners();
  }
}
