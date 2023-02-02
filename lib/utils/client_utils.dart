import 'dart:io';

import 'package:dio/dio.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/server_utils/connection_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path_operations;

//! make a function to send utf8 requests and handles them on the server side by reading the utf8
//! and add the header
//! actually i just needed to handle the server side by decoding the utf8 request
//? to send add client request
Future addClient(
  String connLink,
  ShareProvider shareProvider,
  ServerProvider serverProvider,
  ShareItemsExplorerProvider shareItemsExplorerProvider,
  BuildContext context,
) async {
  await serverProvider.openServer(shareProvider, shareItemsExplorerProvider);
  String deviceID = shareProvider.myDeviceId;
  String name = 'Client Name';
  String myIp = serverProvider.myIp!;
  int myPort = serverProvider.myPort;
  await Dio().post(
    '$connLink$addClientEndPoint',
    data: {
      nameString: name,
      deviceIDString: deviceID,
      portString: myPort,
      ipString: myIp,
    },
  );
}

//? to send a client left request
Future unsubscribeClient(
  ServerProvider serverProviderFalse,
  ShareProvider shareProviderFalse,
) async {
  PeerModel me = serverProviderFalse.me(shareProviderFalse);
  for (var peer in serverProviderFalse.peers) {
    if (peer.sessionID == me.sessionID) continue;
    await Dio().post(
      '${getConnLink(peer.ip, peer.port)}$clientLeftEndPoint',
      data: {
        sessionIDString: me.sessionID,
      },
    );
  }
}

//? get a peer share space
Future<void> getPeerShareSpace(
  String sessionID,
  ServerProvider serverProvider,
  ShareProvider shareProvider,
  ShareItemsExplorerProvider shareItemsExplorerProvider,
  String deviceID,
) async {
  shareItemsExplorerProvider.setLoadingItems(true);
  PeerModel peerModel = serverProvider.peerModelWithSessionID(sessionID);
  String connLink = peerModel.getMyLink(getShareSpaceEndPoint);
  var res = await Dio().get(connLink);
  var data = res.data;
  List<ShareSpaceItemModel> items =
      (data as List).map((e) => ShareSpaceItemModel.fromJSON(e)).toList();
  shareItemsExplorerProvider.updateShareSpaceScreenInfo(
    viewedUserSessionId: sessionID,
    viewedUserDeviceId: deviceID,
    viewedItems: items,
    serverProvider: serverProvider,
    shareProvider: shareProvider,
  );
  shareItemsExplorerProvider.setLoadingItems(false);
}

//? to broadcast file removal from share space
Future<void> broadCastFileRemovalFromShareSpace({
  required ServerProvider serverProvider,
  required ShareProvider shareProvider,
  required List<String> paths,
}) async {
  if (serverProvider.myIp == null) {
    return printOnDebug('you  aren\'t connected to make broadcast');
  }
  PeerModel me = serverProvider.me(shareProvider);
  await _broadcast(
    serverProvider: serverProvider,
    shareProvider: shareProvider,
    endPoint: fileRemovedFromShareSpaceEndPoint,
    headers: {
      ownerSessionIDString: me.sessionID,
      ownerDeviceIDString: me.deviceID,
      // 'Content-Type': 'application/json; charset=utf-8',
    },
    data: paths,
  );
}

//? to broadcast file added to share space
Future<void> broadCastFileAddedToShareSpace({
  required ServerProvider serverProvider,
  required ShareProvider shareProvider,
  required List<ShareSpaceItemModel> addedItems,
}) async {
  if (serverProvider.myIp == null) {
    return printOnDebug('you  aren\'t connected to make broadcast');
  }
  PeerModel me = serverProvider.me(shareProvider);
  await _broadcast(
    serverProvider: serverProvider,
    shareProvider: shareProvider,
    endPoint: fileAddedToShareSpaceEndPoint,
    headers: {
      ownerSessionIDString: me.sessionID,
      ownerDeviceIDString: me.deviceID,
      // 'Content-Type': 'application/json; charset=utf-8',
    },
    data: addedItems.map((e) {
      e.size = File(e.path).statSync().size;
      return e.toJSON();
    }).toList(),
  );
}

Future<void> getFolderContent({
  required ServerProvider serverProvider,
  required String folderPath,
  required ShareProvider shareProvider,
  required String userSessionID,
  required ShareItemsExplorerProvider shareItemsExplorerProvider,
}) async {
  shareItemsExplorerProvider.setLoadingItems(true);
  PeerModel me = serverProvider.me(shareProvider);
  PeerModel otherPeer = serverProvider.peerModelWithSessionID(userSessionID);
  String connLink = getConnLink(otherPeer.ip, otherPeer.port);
  var res = await Dio().get(
    '$connLink$getFolderContentEndPointEndPoint',
    options: Options(
      headers: {
        folderPathHeaderKey: Uri.encodeComponent(folderPath),
        sessionIDHeaderKey: me.sessionID,
      },
    ),
  );
  var data = res.data as List;
  var items = data.map((e) => ShareSpaceItemModel.fromJSON(e)).toList();
  shareItemsExplorerProvider.updatePath(folderPath, items);

  shareItemsExplorerProvider.setLoadingItems(false, false);
}

//? to broadcast data to all servers except me
Future<void> _broadcast({
  required ServerProvider serverProvider,
  required ShareProvider shareProvider,
  required String endPoint,
  Map<String, dynamic>? headers,
  dynamic data,
}) async {
  if (serverProvider.myIp == null) {
    return printOnDebug('you  aren\'t connected to make broadcast');
  }
  Iterable<PeerModel> allPeersButMe = serverProvider.allPeersButMe;
  for (var peer in allPeersButMe) {
    String remoteLink = '${peer.connLink}$endPoint';

    await Dio().post(
      remoteLink,
      data: data,
      options: Options(
        headers: headers,
        // requestEncoder: (request, options) {
        //   return utf8.encode(request);
        // },
      ),
    );
  }
}

Future<int> chunkedDownloadFile({
  required String url,
  required String downloadPath,
  required Function(int p) setProgress,
  Function(double speed)? setSpeed,
  required Map<String, dynamic> headers,
  bool onlyLength = false,
}) async {
  //? this function will support continue corrupted downloads later by downloading the stopped chunks
  // initializing chunk size to be 8MB per request
  Dio dio = Dio();
  const chunkSize = 1024 * 1024 * 8;
  // getting file info from the server endpoints
  int length = int.parse((await dio.get(
    '$url/length',
    options: Options(
      headers: {
        reqIntentPathHeaderKey: 'length',
        filePathHeaderKey: headers[filePathHeaderKey],
      },
    ),
  ))
      .data);
  if (onlyLength) return length;
  int received = 0;
  String fileName =
      path_operations.basename(Uri.decodeComponent(headers[filePathHeaderKey]));
  // getting the chunks number for the final file
  int chunksNumber = (length / chunkSize).ceil();
  // making the temp dir for that will hold the temp files
  Directory tempDir =
      Directory('${path_operations.dirname(downloadPath)}/.tmp');
  if (!tempDir.existsSync()) tempDir.createSync();
  String tempDirPath = tempDir.path;

  // splitting the final file into sub requests and mark them for download
  var futures = <Future>[];
  List<String> files = [];
  List<int> progressList = List.generate(chunksNumber, (index) => 0);
  for (var i = 0; i < chunksNumber; i++) {
    var start = i * chunkSize;
    var end = (i + 1) * chunkSize;
    if (end >= length) {
      end = length - 1;
    }
    var range = 'bytes=$start-$end';
    files.add('$tempDirPath/$fileName-$i');

    DateTime before = DateTime.now();
    // to merge the headers, user headers and this function headers
    Map<String, dynamic> mergedHeaders = <String, dynamic>{};
    mergedHeaders.addAll({
      HttpHeaders.rangeHeader: range,
    });
    mergedHeaders.addAll(headers);

    futures.add(
      dio.download(
        url,
        files[i],
        onReceiveProgress: (count, total) {
          progressList[i] = count;
          received = progressList.fold(
              0, (previousValue, element) => previousValue + element);
          setProgress(received);
          if (setSpeed != null) {
            DateTime after = DateTime.now();
            int diff = after.difference(before).inMilliseconds;
            double speed = (received / 1024 / 1024) / (diff / 1000);
            setSpeed(speed);
          }
        },
        options: Options(
          headers: mergedHeaders,
          responseType: ResponseType.stream,
        ),
      ),
    );
  }

  // wait for all sub files to download
  await Future.wait(futures);
  // initializing the final file to collect it
  var finalFile = await File(downloadPath).open(mode: FileMode.append);
  // collecting the final file from sub files
  for (var subFilePath in files) {
    File subFile = File(subFilePath);
    await finalFile.writeFrom(subFile.readAsBytesSync());
  }
  // deleting temp files
  finalFile.closeSync();
  tempDir.deleteSync(recursive: true);
  return length;
}
