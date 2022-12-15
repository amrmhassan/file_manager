// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/defaults_constants.dart';
import 'package:explorer/helpers/db_helper.dart';
import 'package:explorer/models/listy_model.dart';
import 'package:flutter/cupertino.dart';
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
      return;
    }
    for (var listy in data) {
      _listy.add(ListyModel.fromJSON(listy));
    }
    notifyListeners();
  }

//? to create a new listy
  Future addListy({required String title, String? icon}) async {
    DateTime createdAt = DateTime.now();
    String iconPath = icon ?? 'assets/icons/listy.png';
    bool titleExists = _listy.any((element) => element.title == title);
    if (titleExists) throw Exception('This list already exist');
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
}
