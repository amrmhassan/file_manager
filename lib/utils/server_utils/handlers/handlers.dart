import 'dart:convert';
import 'dart:io';

import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/server_utils/encoding_utils.dart';
import 'package:explorer/utils/server_utils/server_feedback_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';

void addClientHandler(
  HttpRequest request,
  HttpResponse response,
  ServerProvider serverProvider,
  ShareProvider shareProviderFalse,
) async {
  try {
    Map body = await decodeRequest(request);
    String name = body[nameString] as String;
    String deviceID = body[deviceIDString] as String;
    String ip = body[ipString] as String;
    int port = body[portString];
    String sessionID = body[sessionIDString];

    PeerModel peerModel =
        serverProvider.addPeer(sessionID, deviceID, name, ip, port);
    response
      ..headers.contentType = ContentType.json
      ..write(
        jsonify(peerModel.toJSON()),
      );
    await peerAddedServerFeedBack(serverProvider, shareProviderFalse);
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

void getShareSpaceHandler(
  HttpRequest request,
  HttpResponse response,
  ServerProvider serverProvider,
  ShareProvider shareProvider,
) {
  try {
    List<Map<String, dynamic>> sharedItemsMap =
        shareProvider.sharedItems.map((e) {
      ShareSpaceItemModel shareSpaceItemModel = e;
      shareSpaceItemModel.ownerSessionID =
          serverProvider.me(shareProvider).sessionID;
      return shareSpaceItemModel.toJSON();
    }).toList();
    String jsonResponse = json.encode(sharedItemsMap);
    response
      ..headers.contentType = ContentType.json
      ..add(encodeRequest(jsonResponse));
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

//? this is from the server feedback to all peers after a client is added by one of the devices in the group
Future<void> clientAddedHandler(
  HttpRequest request,
  HttpResponse response,
  ServerProvider serverProvider,
) async {
  try {
    List<dynamic> decodedRequest = await decodeRequest(request, true);
    List<PeerModel> listOfAllPeers =
        decodedRequest.map((e) => PeerModel.fromJSON(e)).toList();
    serverProvider.updateAllPeers(listOfAllPeers);
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

void clientLeftHandler(
  HttpRequest request,
  HttpResponse response,
  ServerProvider serverProvider,
) async {
  try {
    String sessionID = (await decodeRequest(request))[sessionIDString];

    serverProvider.peerLeft(sessionID);
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

void fileAddedHandler(
  HttpRequest request,
  HttpResponse response,
  ShareItemsExplorerProvider shareItemsExplorerProvider,
) async {
  try {
    //? here make a provider to handle peer share space items then update the items if the viewed items are for the updated peer
    var headers = request.headers;
    var senderSessionID = (headers[ownerSessionIDString])!.first;

    List<dynamic> bodyJson = await decodeRequest(request);
    List<ShareSpaceItemModel> addedItemsModels = bodyJson.map((e) {
      ShareSpaceItemModel s = ShareSpaceItemModel.fromJSON(e);
      s.ownerSessionID = senderSessionID;
      return s;
    }).toList();

    shareItemsExplorerProvider.addToPeerShareSpaceScreen(
      addedItems: addedItemsModels,
      sessionId: senderSessionID,
    );
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }

  // print(headers);
}

void fileRemovedHandler(
  HttpRequest request,
  HttpResponse response,
  ShareItemsExplorerProvider shareItemsExplorerProvider,
) async {
  try {
    //? here make a provider to handle peer share space items then update the items if the viewed items are for the updated peer
    List<dynamic> bodyJson = await decodeRequest(request);
    List<String> removedItemsPaths = bodyJson.map((e) => e as String).toList();
    var headers = request.headers;
    var senderSessionID = (headers[ownerSessionIDString])!.first;

    shareItemsExplorerProvider.removeFromPeerShareSpace(
      removedItems: removedItemsPaths,
      sessionId: senderSessionID,
    );
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

Future<void> getFolderContentHandler(
  HttpRequest request,
  HttpResponse response,
  ServerProvider serverProvider,
  ShareProvider shareProvider,
) async {
  try {
    var headers = request.headers;
    String folderPath =
        Uri.decodeComponent(headers[folderPathHeaderKey]!.first);
    // i will need the peer session id to know that if it is allowed or not
    // String peerSessionID = headers[sessionIDHeaderKey]!.first;
    Directory directory = Directory(folderPath);
    if (directory.existsSync()) {
      PeerModel me = serverProvider.me(shareProvider);
      var folderChildren = await compute(getFolderChildren, folderPath);
      List<Map<String, dynamic>> sharedItems = folderChildren.map((entity) {
        FileStat fileStat = entity.statSync();

        return ShareSpaceItemModel(
          blockedAt: [],
          entityType: fileStat.type == FileSystemEntityType.file
              ? EntityType.file
              : EntityType.folder,
          path: entity.path,
          ownerDeviceID: me.deviceID,
          ownerSessionID: me.sessionID,
          addedAt: DateTime.now(),
          size: fileStat.size,
        ).toJSON();
      }).toList();
      var encodedData = encodeRequest(json.encode(sharedItems));

      response
        ..headers.add('Content-Type', 'application/json; charset=utf-8')
        ..add(encodedData);
    }
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

Future<void> streamAudioHandler(
  HttpRequest req,
  HttpResponse response,
) async {
  try {
    String audioPath = req.headers.value(filePathHeaderKey)!;
    audioPath = Uri.decodeComponent(audioPath);

    // var headers = req.headers;
//  i will need them to check for authorization
    // String sessionID = headers.value(sessionIDHeaderKey)![0];
    // String deviceID = headers.value(deviceIDString)![0];

    File file = File(audioPath);
    int length = await file.length();

    // this formate 'bytes=0-' means that i want the bytes from the 0 to the end
    // so the end here means the end of the file
    // if it was 'bytes=0-1000' this means that i need the bytes from 0 to 1000
    String range = req.headers.value('range') ?? 'bytes=0-';
    List<String> parts = range.split('=');
    List<String> positions = parts[1].split('-');
    int start = int.parse(positions[0]);
    int end = positions.length < 2 || int.tryParse(positions[1]) == null
        ? length
        : int.parse(positions[1]);
    String? mime = lookupMimeType(audioPath);
    // print('Needed bytes from $start to $end');

    response.statusCode = HttpStatus.partialContent;
    response.headers
      ..contentType = ContentType.parse(mime ?? 'audio/mpeg')
      ..contentLength = end - start
      ..add('Accept-Ranges', 'bytes')
      ..add('Content-Range', 'bytes $start-$end/$length');
    file.openRead(start, end).pipe(req.response);
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

Future<void> streamVideoHandler(
  HttpRequest req,
  HttpResponse response,
) async {
  try {
    String videoPath = req.headers.value(filePathHeaderKey)!;
    videoPath = Uri.decodeComponent(videoPath);

    // var headers = req.headers;
//  i will need them to check for authorization
    // String sessionID = headers.value(sessionIDHeaderKey)![0];
    // String deviceID = headers.value(deviceIDString)![0];

    File file = File(videoPath);
    int length = await file.length();

    // this formate 'bytes=0-' means that i want the bytes from the 0 to the end
    // so the end here means the end of the file
    // if it was 'bytes=0-1000' this means that i need the bytes from 0 to 1000
    String range = req.headers.value('range') ?? 'bytes=0-';
    List<String> parts = range.split('=');
    List<String> positions = parts[1].split('-');
    int start = int.parse(positions[0]);
    int end = positions.length < 2 || int.tryParse(positions[1]) == null
        ? length
        : int.parse(positions[1]);
    String? mime = lookupMimeType(videoPath);
    // print('Needed bytes from $start to $end');

    response.statusCode = HttpStatus.partialContent;
    response.headers
      ..contentType = ContentType.parse(mime ?? 'video/mp4')
      ..contentLength = end - start
      ..add('Accept-Ranges', 'bytes')
      ..add('Content-Range', 'bytes $start-$end/$length')
      ..add('Access-Control-Allow-Origin', '*');
    file.openRead(start, end).pipe(req.response);
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

Future<void> downloadFileHandler(
  HttpRequest req,
  HttpResponse response,
) async {
  try {
    String? intent = req.headers.value(reqIntentPathHeaderKey);
    String filePath =
        Uri.decodeComponent(req.headers.value(filePathHeaderKey)!);
    File file = File(filePath);
    int length = await file.length();
    if (intent == 'length') {
      req.response
        ..write(length)
        ..close();
      return;
    }

    // this formate 'bytes=0-' means that i want the bytes from the 0 to the end
    // so the end here means the end of the file
    // if it was 'bytes=0-1000' this means that i need the bytes from 0 to 1000
    String range = req.headers.value('range') ?? 'bytes=0-';
    List<String> parts = range.split('=');
    List<String> positions = parts[1].split('-');
    int start = int.parse(positions[0]);
    int end = positions.length < 2 || int.tryParse(positions[1]) == null
        ? length
        : int.parse(positions[1]);
    String? mime = lookupMimeType(filePath);
    // print('Needed bytes from $start to $end');

    req.response.statusCode = HttpStatus.partialContent;
    req.response.headers
      ..contentType = ContentType.parse(mime ?? 'audio/mpeg')
      ..contentLength = end - start
      ..add('Accept-Ranges', 'bytes')
      ..add('Content-Range', 'bytes $start-$end/$length');
    file.openRead(start, end).pipe(req.response);
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

// the isolate that will get any folder children then return it when finished
List<FileSystemEntity> getFolderChildren(String folderPath) {
  return Directory(folderPath).listSync();
}

Future<void> getWsServerConnLinkHandler(
  HttpRequest request,
  HttpResponse response,
  ServerProvider serverProvider,
) async {
  response.write(serverProvider.myWSConnLink);
}

Future<void> getUserImageHandler(
  HttpRequest request,
  HttpResponse response,
  ShareProvider shareProvider,
) async {
  bool exist = File(shareProvider.myImagePath!).existsSync();
  if (shareProvider.myImagePath == null || !exist) {
    response
      ..statusCode = HttpStatus.notFound
      ..write('Not Found')
      ..close();
    return;
  }
  File file = File(shareProvider.myImagePath!);
  var bytes = file.readAsBytesSync();

  response
    ..headers.contentType = ContentType.binary
    ..contentLength = bytes.length
    ..add(bytes)
    ..close();
}
