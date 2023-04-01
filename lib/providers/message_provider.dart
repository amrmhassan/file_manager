// ignore_for_file: prefer_const_constructors

import 'package:explorer/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class MessageProvider extends ChangeNotifier {
  List<MessageModel> _messages = [];

  Iterable<MessageModel> get messages => [..._messages.reversed];

  Iterable<MessageModel> get viewedLaptopMessages =>
      _messages.where((element) => element.viewed);

  Iterable<MessageModel> get notViewedMessages =>
      _messages.where((element) => !element.viewed);

  // Iterable<MessageModel> getUserMessages(String userID) {
  //   return _messages.where((element) => element.senderID == userID);
  // }

  void addLaptopMessage({
    required String msg,
    required String senderID,
    required String senderName,
  }) {
    var model = MessageModel(
      msg: msg,
      at: DateTime.now(),
      id: Uuid().v4(),
      senderID: senderID,
      senderName: senderName,
    );
    _messages.add(model);
    notifyListeners();
  }

  void markAllMessagesAsViewed([bool notify = true]) {
    _messages = [
      ..._messages.map((e) {
        e.viewed = true;
        return e;
      })
    ];
    try {
      if (notify) notifyListeners();
    } catch (e) {
      //
    }
  }

  void removeMessage(String msgID) {
    _messages.removeWhere((element) => element.id == msgID);
    notifyListeners();
  }
}
