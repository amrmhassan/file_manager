// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
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
  String? myDeviceId;
  List<ShareSpaceItemModel> sharedItems = [];

  //# connection parameters
  String speedText = '0Mb/s';
  double percentSent = 0;
  int serverPort = 3000;
  String? myConnLink;
  int myServerOpenPort = 0;
  bool sharing = false;
  Uint8List? sharedFile;
  String? fileName;
  MemberType? memberType;

  //? i will give this device an id in the first run of the app
  //? and if it is there just don't change it
  Future<void> giveDeviceAnId() async {
    String? savedId = await SharedPrefHelper.getString(deviceIdKey);

    if (savedId == null) {
      myDeviceId = Uuid().v4();
      notifyListeners();
      await SharedPrefHelper.setString(deviceIdKey, myDeviceId!);
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
    sharedItems.removeWhere((element) => element.path == path);
    notifyListeners();
    await DBHelper.deleteById(path, shareSpaceItemsTableName, persistentDbName);
  }

  //? add multiple files to share space
  Future addMultipleFilesToShareSpace(List<StorageItemModel> items) async {
    for (var item in items) {
      await _addToShareSpace(item);
    }
  }

  //? add file to share space
  Future _addToShareSpace(StorageItemModel storageItemModel) async {
    ShareSpaceItemModel shareSpaceItemModel = ShareSpaceItemModel(
      blockedAt: [],
      entityType: storageItemModel.entityType,
      path: storageItemModel.path,
      ownerID: myDeviceId!,
      addedAt: DateTime.now(),
    );
    sharedItems.add(shareSpaceItemModel);
    notifyListeners();
    await DBHelper.insert(
      shareSpaceItemsTableName,
      shareSpaceItemModel.toJSON(),
      persistentDbName,
    );
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

  //! the following code need some checks and some more thinking

  //? send file
  Future openServer([bool wifi = true]) async {
    HttpServer httpServer =
        await HttpServer.bind(InternetAddress.anyIPv4, myServerOpenPort);
    myServerOpenPort = httpServer.port;
    String? myWifiIp = await getMyIpAddress(wifi);
    if (myWifiIp == null) {
      throw Exception('Ip is null');
    }
    myConnLink = 'http://$myWifiIp:$myServerOpenPort';
    sharing = true;
    notifyListeners();

    httpServer.listen((HttpRequest request) async {
      if (request.uri.path == '/') {
        request.response
          ..headers.contentType = ContentType('application', 'octet-stream')
          ..headers.add('content-disposition', 'attachment; filename=$fileName')
          ..headers.add('Content-Length', sharedFile!.length)
          ..headers.add('fileName', fileName!)
          ..add(sharedFile!)
          ..close();
      } else if (request.uri.path == '/done') {
        request.response.close();
        httpServer.close();
      } else if (request.uri.path == '/filename') {
        request.response
          ..write(fileName)
          ..close();
      }
    });
  }

  //? to start the host who have the hotspot
  void startHost() {
    memberType = MemberType.host;
    notifyListeners();
    openServer(false);
  }

  //? to start a client and connect it to the host
  void startClient(String ip) {
    memberType = MemberType.client;
    notifyListeners();
    connectToServer(ip);
  }

  //? receive file
  Future connectToServer(String ip) async {
    String fileName =
        (await Dio().get('http://$ip:$serverPort/filename')).data as String;
    int? t;
    DateTime before = DateTime.now();
    await Dio().download(
      'http://$ip:$serverPort',
      '/sdcard/$fileName',
      onReceiveProgress: (count, total) {
        DateTime after = DateTime.now();

        t ??= total;
        double percent = (count / total) * 100;
        double instantTime = after.difference(before).inMicroseconds / 1000000;
        String realTimeSpeed =
            '${((count / (1024 * 1024)) / instantTime).toStringAsFixed(2)}Mb/s';
        speedText = realTimeSpeed;
        percentSent = percent / 100;
        notifyListeners();

        // stdout.write('Progress: ${percent.toStringAsFixed(2)}%\r');
        if (count == total) {
          double time = after.difference(before).inMicroseconds / 1000000;
          double size = t! / (1024 * 1024);
          String speed = (size / time).toStringAsFixed(2);

          Dio().post('http://$ip:$serverPort/done',
              options: Options(
                headers: {
                  'speed': speed,
                },
              ));
        }
      },
    );
  }

  //? get my wifi address
  Future<String?> getMyIpAddress([bool wifi = true]) async {
    //! this might change for other devices
    // 192.168.43.99   => wlan0 == mostly wifi
    // 192.168.118.237 => wlan1 == mostly hotspot
    try {
      var interfaces = await NetworkInterface.list();
      var wifiInterface = interfaces.firstWhere((element) =>
          element.name.contains(wifi ? 'wlan0' : 'wlan1') ||
          element.name.contains('wifi'));
      // return null;
      return wifiInterface.addresses.first.address;
    } catch (e) {
      return null;
    }
  }
}
