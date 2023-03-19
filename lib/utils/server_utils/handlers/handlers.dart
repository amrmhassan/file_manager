import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/screens/share_screen/share_screen.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:explorer/utils/server_utils/connection_utils.dart';
import 'package:explorer/utils/server_utils/encoding_utils.dart';
import 'package:explorer/utils/server_utils/server_feedback_utils.dart';
import 'package:explorer/utils/websocket_utils/custom_server_socket.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

//! window video and audio player can't send header right now , so i will handle window video, audio players manually from the path
BuildContext getContext() {
  BuildContext? context = navigatorKey.currentContext;
  if (context == null) {
    throw Exception('error with context getting');
  }
  return context;
}

void addClientHandler(
  HttpRequest request,
  HttpResponse response,
) async {
  try {
    BuildContext context = getContext();
    ShareProvider shareProviderFalse = sharePF(context);

    var serverProvider = serverPF(context);
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
  ShareProvider shareProvider, [
  bool recursive = false,
  bool connectPhone = false,
]) async {
  Completer completer = Completer();
  try {
    var headers = request.headers;
    String folderPath =
        Uri.decodeComponent(headers.value(folderPathHeaderKey)!);
    // i will need the peer session id to know that if it is allowed or not
    // String peerSessionID = headers[sessionIDHeaderKey]!.first;
    Directory directory = Directory(folderPath);
    if (directory.existsSync()) {
      late PeerModel me;
      if (!connectPhone) {
        me = serverProvider.me(shareProvider);
      }
      var folderChildren = await compute(
          (message) => getFolderChildren(folderPath, recursive), false);
      // hide marked 'hidden' elements
      List<Map<String, dynamic>> sharedItems = [];
      for (var entity in folderChildren) {
        if (shareProvider.hiddenEntitiesPaths.contains(entity.path)) continue;
        FileStat fileStat = entity.statSync();
        sharedItems.add(ShareSpaceItemModel(
          blockedAt: [],
          entityType: fileStat.type == FileSystemEntityType.file
              ? EntityType.file
              : EntityType.folder,
          path: entity.path,
          ownerDeviceID: connectPhone ? laptopID : me.deviceID,
          ownerSessionID: connectPhone ? laptopID : me.sessionID,
          addedAt: DateTime.now(),
          size: fileStat.size,
        ).toJSON());
      }

      var encodedData = encodeRequest(json.encode(sharedItems));

      response
        ..headers.add('Content-Type', 'application/json; charset=utf-8')
        ..add(encodedData);
      completer.complete();
    }
  } catch (e, s) {
    response
      ..statusCode = HttpStatus.internalServerError
      ..close();
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
  return completer.future;
}

Future<void> streamAudioHandler(
  HttpRequest req,
  HttpResponse response,
) async {
  try {
    String audioPath = req.headers.value(filePathHeaderKey) ?? '';
    audioPath = Uri.decodeComponent(audioPath);
    if (audioPath.isEmpty) {
      // this means that the file is being played through a windows app, that can't send header
      //! you need to edit router to route to this even though the path is different
      audioPath = req.uri.path.replaceFirst('$streamAudioEndPoint/', '');
      audioPath = Uri.decodeComponent(audioPath);
    }

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
    String videoPath = req.headers.value(filePathHeaderKey) ?? '';
    videoPath = Uri.decodeComponent(videoPath);
    if (videoPath.isEmpty) {
      // this means that the file is being played through a windows app, that can't send header
      //! you need to edit router to route to this even though the path is different
      videoPath = req.uri.path.replaceFirst('$streamVideoEndPoint/', '');
      videoPath = Uri.decodeComponent(videoPath);
    }

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
List<FileSystemEntity> getFolderChildren(String folderPath,
    [bool rec = false]) {
  return Directory(folderPath).listSync(recursive: rec);
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
  if (shareProvider.myImagePath == null) {
    response
      ..statusCode = HttpStatus.notFound
      ..write('Not Found')
      ..close();
    return;
  }
  File file = File(shareProvider.myImagePath!);
  if (!file.existsSync()) {
    response
      ..statusCode = HttpStatus.notFound
      ..write('image path deleted or moved')
      ..close();
    return;
  }
  var bytes = file.readAsBytesSync();

  response
    ..headers.contentType = ContentType.binary
    ..contentLength = bytes.length
    ..add(bytes)
    ..close();
}

//# connect to phone handlers
void serverCheckHandler(
  HttpRequest request,
  HttpResponse response,
  ServerProvider serverProvider,
  ShareProvider shareProvider,
) async {
  String remoteIp = request.connectionInfo!.remoteAddress.address;
  String myIp = (request.headers.value('host')!).split(':').first;
  int remoteServerPort = int.parse(utf8.decode(await request.single));
  logger.i(
      'got server check with remote $remoteIp:$remoteServerPort \nlocal $myIp:${serverProvider.myPort}');

  // i made this because if laptop is connected to a wifi and the phone is connected to laptop hotspot
  // when the phone checks for the laptop ip which is on wifi, it responds
  // so i think in this case the phone has access to wifi ips, and this mean that he can access router page even if the phone is connected to laptop hotspot
  // so if the remote ip is the same as my ip this means that i getting a request through myself(my phone through wifi that i am connected to, when phone is connected to my hotspot)
  if (remoteIp == myIp) {
    response.statusCode = HttpStatus.badRequest;
    response.write(
        'You are connected to me through wifi, while you are connected to my hotspot');
    response.close();
    return;
  }
  //? 1] the first user will give me my ip
  //? 2] i will set my ip as he provided me with it
  //? 3] i will give him his ip

  //? 4] other users will give me my ip, i will compare it with my ip provided from the first user
  //? 5] if it is diff then this is bad, and no connection will be established
  //? 6] if not, then i will provide the user with his ip (done)

  if (myIp != serverProvider.myIp && serverProvider.myIp != null) {
    logger.w('devices are\'nt connected to the same network');
    response
      ..statusCode = HttpStatus.badRequest
      ..write('You aren\'t connected to the same network')
      ..close();
  }
  if (serverProvider.myIp == null) {
    logger.i('setting my ip(host) to be $myIp');
    serverProvider.firstConnected(myIp, shareProvider, MemberType.host);
    //!
    var customServerSocket =
        CustomServerSocket(myIp, serverProvider, shareProvider);
    var wsServer = await customServerSocket.getWsConnLink();
    var myWSConnLink = getConnLink(myIp, wsServer.port, null, true);

    serverProvider.setMyServerSocket(customServerSocket);
    serverProvider.setMyWSConnLink(myWSConnLink);
    foregroundServiceController.shareSpaceServerStarted();
  }
  //!
// i know my port, but i don't know which of my ips will work
// so client will provide my ip for me,
// and i will get his port from his
// and i will provide him with his working ip

  response
    ..write(remoteIp)
    ..close();

  if (navigatorKey.currentContext == null) return;
  try {
    Navigator.popUntil(navigatorKey.currentContext!,
        (route) => route.settings.name == ShareScreen.routeName);
  } catch (e) {
    logger.e(e);
  }
}

//! just move this to laptop router and handlers
Future<void> getUserListyHandler(
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
  var listyList = listyPF(context).listyList;
  var data = listyList.map((e) => e.toJSON()).toList();
  var encodedData = encodeRequest(json.encode(data));
  response
    ..add(encodedData)
    ..close();
}
