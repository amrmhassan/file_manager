// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:explorer/utils/server_utils/encoding_utils.dart';
import 'package:explorer/utils/server_utils/handlers/handlers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> getStorageInfoHandler(
  HttpRequest request,
  HttpResponse response,
) async {
  BuildContext? context = navigatorKey.currentContext;
  if (context == null) {
    response
      ..statusCode = HttpStatus.internalServerError
      ..write('An error with context')
      ..close();
    return;
  }
  try {
    int totalSpace = await analyzerPF(context).getTotalDiskSpace();
    int freeSpace = await analyzerPF(context).getFreeDiskSpace();

    response
      ..headers.add(freeSpaceHeaderKey, freeSpace)
      ..headers.add(totalSpaceHeaderKey, totalSpace)
      ..write('Space is in headers')
      ..close();
  } catch (e) {
    response
      ..statusCode = HttpStatus.internalServerError
      ..write('An error getting free space and total space')
      ..close();
  }
}

Future<void> getDiskNamesHandler(
  HttpRequest request,
  HttpResponse response,
) async {
  BuildContext? context = navigatorKey.currentContext;
  if (context == null) {
    response
      ..statusCode = HttpStatus.internalServerError
      ..write('An error with context')
      ..close();
    return;
  }
  try {
    int totalSpace = await analyzerPF(context).getTotalDiskSpace();
    int freeSpace = await analyzerPF(context).getFreeDiskSpace();

    response
      ..headers.add(freeSpaceHeaderKey, freeSpace)
      ..headers.add(totalSpaceHeaderKey, totalSpace)
      ..write('Space is in headers')
      ..close();
  } catch (e) {
    response
      ..statusCode = HttpStatus.internalServerError
      ..write('An error getting free space and total space')
      ..close();
  }
}

Future<void> getPhoneFolderContentHandler(
  HttpRequest request,
  HttpResponse response,
) async {
  try {
    String folderPath = request.headers.value(folderPathHeaderKey)!;

    folderPath = Uri.decodeComponent(folderPath);
    if (folderPath == initialDirs.first.path) {
      // if it has only 2 children then it means we have only one disk
      if (initialDirs.length <= 2) {
        folderPath = initialDirs.last.path;
      } else {
        // here this mean i have more than one disk and i need to return only them
        await handleSendChildrenToClient(
          initialDirs.skip(1),
          folderPath,
          response,
        );

        return;
      }
    }
    // i will need the peer session id to know that if it is allowed or not
    // String peerSessionID = headers[sessionIDHeaderKey]!.first;
    Directory directory = Directory(folderPath);
    if (directory.existsSync()) {
      var folderChildren = await compute(getFolderChildren, folderPath);
      // hide marked 'hidden' elements
      await handleSendChildrenToClient(folderChildren, folderPath, response);
    }
  } catch (e, s) {
    logger.w(e);
    response
      ..statusCode = HttpStatus.internalServerError
      ..write('Can\'t open this folder')
      ..close();
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

Future<void> handleSendChildrenToClient(
  Iterable<dynamic> paths,
  String folderPath,
  HttpResponse response,
) async {
  List<Map<String, dynamic>> sharedItems = [];
  for (var entity in paths) {
    FileStat fileStat = entity.statSync();
    sharedItems.add(ShareSpaceItemModel(
      blockedAt: [],
      entityType: fileStat.type == FileSystemEntityType.file
          ? EntityType.file
          : EntityType.folder,
      path: entity.path,
      ownerDeviceID: 'phone',
      ownerSessionID: 'phone',
      addedAt: DateTime.now(),
      size: fileStat.size,
    ).toJSON());
  }

  var encodedData = encodeRequest(json.encode(sharedItems));

  response
    ..headers.add('Content-Type', 'application/json; charset=utf-8')
    ..headers.add(parentFolderPathHeaderKey, Uri.encodeComponent(folderPath))
    ..add(encodedData);
}
