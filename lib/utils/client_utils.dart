import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/working_ip_model.dart';
import 'package:explorer/providers/connect_laptop_provider.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/server_utils/connection_utils.dart';
import 'package:explorer/utils/simple_encryption_utils/simple_encryption_utils.dart';
import 'package:explorer/utils/websocket_utils/custom_client_socket.dart';

//! make a function to send utf8 requests and handles them on the server side by reading the utf8
//! and add the header
//! actually i just needed to handle the server side by decoding the utf8 request
//? to send add client request
Future addClient(
  String connLink,
  ShareProvider shareProvider,
  ServerProvider serverProviderFalse,
  ShareItemsExplorerProvider shareItemsExplorerProvider,
) async {
  try {
    String? mySessionID =
        await connectToWsServer(connLink, serverProviderFalse);
    if (mySessionID == null) {
      throw CustomException(
        e: 'My Session ID is null',
        s: StackTrace.current,
      );
    }
    // await serverProviderFalse.openServer(
    //   shareProvider,
    //   MemberType.client,
    //   shareItemsExplorerProvider,
    // );
    String deviceID = shareProvider.myDeviceId;
    String name = shareProvider.myName;
    String myIp = serverProviderFalse.myIp!;
    int myPort = serverProviderFalse.myPort;
    await Dio().post(
      '$connLink${EndPoints.addClient}',
      data: {
        nameString: name,
        deviceIDString: deviceID,
        portString: myPort,
        ipString: myIp,
        sessionIDString: mySessionID,
      },
    );
    foregroundServiceController.shareSpaceServerStarted();
  } on DioError catch (e, s) {
    logger.e(e.response?.data);
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

//?
// the user will ask for the other peer image then i will be headed to the other user handler asking for his image
// then if he has one he will reply with his one as a Uint8List
// otherwise he will reply with a 404 error which will cause this getPeerImage function to return null
//
Future<Uint8List?> getPeerImage(String connLink) async {
  try {
    String url = '$connLink${EndPoints.getPeerImagePath}';
    Uri uri = Uri.parse(url);
    HttpClient client = HttpClient();
    var request = await client.getUrl(uri);
    var res = await request.close();
    if (res.statusCode == 404) throw Exception('No image');
    List<int> bytes = [];
    await for (var chunk in res) {
      bytes.addAll(chunk);
    }

    return Uint8List.fromList(bytes);
  } on DioError catch (e) {
    logger.e(e.response?.data);

    return null;
  }
}

Future unsubscribeMe(ServerProvider serverProviderFalse) async {
  // if i left, this will tell the server about that
  // then the server will tell every one else about me
  //! here check if i am a client or a server
  //! if client just leave it as it is
  //! or close the server instead
  if (serverProviderFalse.myType == MemberType.client) {
    try {
      serverProviderFalse.myClientWsSink
          .close(null, 'user normally left the group');
    } catch (e) {
      logger.e(e);
    }
  } else if (serverProviderFalse.myType == MemberType.host) {
    serverProviderFalse.closeWsServer();
  }
}

//? to send a client left request
Future broadcastUnsubscribeClient(
  ServerProvider serverProviderFalse,
  ShareProvider shareProviderFalse,
  String customSessionID,
) async {
  // this should be called from the server to notify all other clients that a device has been disconnected
  // with his session id to be removed from the group
  try {
    PeerModel me = serverProviderFalse.me(shareProviderFalse);
    List<PeerModel> peersCopied = [...serverProviderFalse.peers];
    for (var peer in peersCopied) {
      if (peer.sessionID == me.sessionID) continue;
      await Dio().post(
        '${getConnLink(peer.ip, peer.port)}${EndPoints.clientLeft}',
        data: {
          sessionIDString: customSessionID,
          KHeaders.myServerPortHeaderKey: serverProviderFalse.myPort,
        },
      );
    }
  } on DioError catch (e, s) {
    logger.e(e.response?.data);
    CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

//? get a peer share space
Future<List<ShareSpaceItemModel>?> getPeerShareSpace(
  String sessionID,
  ServerProvider serverProvider,
  ShareProvider shareProvider,
  ShareItemsExplorerProvider shareItemsExplorerProvider,
  String deviceID,
) async {
  try {
    shareItemsExplorerProvider.setLoadingItems(true);
    PeerModel peerModel = serverProvider.peerModelWithSessionID(sessionID);
    String connLink = peerModel.getMyLink(EndPoints.getShareSpace);
    var res = await Dio().get(
      connLink,
      options: Options(
        headers: {
          KHeaders.deviceIDHeaderKey: shareProvider.myDeviceId,
          KHeaders.userNameHeaderKey: shareProvider.myName,
          KHeaders.myServerPortHeaderKey: serverProvider.myPort,
        },
        receiveDataWhenStatusError: false,
      ),
    );
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
    return items;
  } on DioError catch (e) {
    shareItemsExplorerProvider.setLoadingItems(false);
    String? reason =
        e.response?.headers.value(KHeaders.serverRefuseReasonHeaderKey);
    throw CustomException(
      e: reason ?? 'Unknown Reason',
      s: StackTrace.current,
    );
  }
}

//? to broadcast file removal from share space
Future<void> broadCastFileRemovalFromShareSpace({
  required ServerProvider serverProvider,
  required ShareProvider shareProvider,
  required List<String> paths,
}) async {
  try {
    if (serverProvider.myIp == null) {
      return printOnDebug('you  aren\'t connected to make broadcast');
    }
    PeerModel me = serverProvider.me(shareProvider);
    await _broadcast(
      serverProvider: serverProvider,
      shareProvider: shareProvider,
      endPoint: EndPoints.fileRemovedFromShareSpace,
      headers: {
        ownerSessionIDString: me.sessionID,
        ownerDeviceIDString: me.deviceID,
        KHeaders.myServerPortHeaderKey: serverProvider.myPort,

        // 'Content-Type': 'application/json; charset=utf-8',
      },
      data: paths,
    );
  } on DioError catch (e, s) {
    logger.e(e.response?.data);

    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

//? to broadcast file added to share space
Future<void> broadCastFileAddedToShareSpace({
  required ServerProvider serverProvider,
  required ShareProvider shareProvider,
  required List<ShareSpaceItemModel> addedItems,
}) async {
  try {
    if (serverProvider.myIp == null) {
      return printOnDebug('you  aren\'t connected to make broadcast');
    }
    PeerModel me = serverProvider.me(shareProvider);
    await _broadcast(
      serverProvider: serverProvider,
      shareProvider: shareProvider,
      endPoint: EndPoints.fileAddedToShareSpace,
      headers: {
        ownerSessionIDString: me.sessionID,
        ownerDeviceIDString: me.deviceID,
        KHeaders.myServerPortHeaderKey: serverProvider.myPort,

        // 'Content-Type': 'application/json; charset=utf-8',
      },
      data: addedItems.map((e) {
        e.size = File(e.path).statSync().size;
        return e.toJSON();
      }).toList(),
    );
  } on DioError catch (e, s) {
    logger.e(e.response?.data);

    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

Future<void> getFolderContent({
  required ServerProvider serverProvider,
  required String folderPath,
  required ShareProvider shareProvider,
  required String userSessionID,
  required ShareItemsExplorerProvider shareItemsExplorerProvider,
}) async {
  try {
    shareItemsExplorerProvider.setLoadingItems(true);
    PeerModel me = serverProvider.me(shareProvider);
    PeerModel otherPeer = serverProvider.peerModelWithSessionID(userSessionID);
    String connLink = getConnLink(otherPeer.ip, otherPeer.port);
    var res = await Dio().get(
      '$connLink${EndPoints.getFolderContentEndPoint}',
      options: Options(
        headers: {
          KHeaders.folderPathHeaderKey: Uri.encodeComponent(folderPath),
          KHeaders.sessionIDHeaderKey: me.sessionID,
          KHeaders.myServerPortHeaderKey: serverProvider.myPort,
        },
      ),
    );
    var data = res.data as List;
    var items = data.map((e) => ShareSpaceItemModel.fromJSON(e)).toList();
    shareItemsExplorerProvider.updatePath(folderPath, items);

    shareItemsExplorerProvider.setLoadingItems(false, false);
  } on DioError catch (e, s) {
    logger.e(e.response?.data);

    shareItemsExplorerProvider.setLoadingItems(false);
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

//? to broadcast data to all servers except me
Future<void> _broadcast({
  required ServerProvider serverProvider,
  required ShareProvider shareProvider,
  required String endPoint,
  Map<String, dynamic>? headers,
  dynamic data,
}) async {
  try {
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
  } on DioError catch (e, s) {
    logger.e(e.response?.data);

    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

//! check the method of addclient
//! i am calling openServer, debug if the client opens add a peer model with server name, and host or not
Future<String?> connectToWsServer(
  String connLink,
  ServerProvider serverProviderFalse,
) async {
  try {
    CustomClientSocket clientSocket = CustomClientSocket();
    String wsConnLink = (await Dio().get(
      '$connLink${EndPoints.wsServerConnLink}',
      options: Options(
        headers: {
          KHeaders.myServerPortHeaderKey: serverProviderFalse.myPort,
        },
      ),
    ))
        .data;

    clientSocket.client(wsConnLink, serverProviderFalse);
    String mySessionID = await clientSocket.getMySessionID();
    serverProviderFalse.setMyWsChannel(clientSocket.clientChannel.sink);
    return mySessionID;
  } on DioError catch (e, s) {
    logger.e(e.response?.data);
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

//# new way of initiating connection

Future<String?> shareSpaceGetWorkingLink(
  String code,
  ServerProvider serverProviderFalse,
  ShareProvider shareProviderFalse,
  ShareItemsExplorerProvider shareItemsExplorerProviderFalse,
) async {
  await serverProviderFalse.openServer(
    shareProviderFalse,
    MemberType.client,
    shareItemsExplorerProviderFalse,
  );
  var res = await getWorkingIpFromCode(
    code: code,
    myPort: serverProviderFalse.myPort,
  );
  if (res == null) return null;
  serverProviderFalse.setMyIpAsClient(res.myIp);

  return '${res.serverIp}:${res.serverPort}';
}

Future<WorkingIpModel?> getWorkingIpFromCode({
  required String code,
  required int myPort,
  int? timeout,
}) async {
  // this will return a working ip from the server with the port(connLink)
  // and on done will return my working ip that the server replied with
  List<dynamic> nulls = [];
  String decrypted = SimpleEncryption(code).decrypt();
  var data = decrypted.split('||');
  int port = int.parse(data.last);
  var ips = data.first.split('|');
  Completer<WorkingIpModel?> completer = Completer<WorkingIpModel?>();

  Dio dio = Dio();
  dio.options.sendTimeout = timeout ?? 5000;
  dio.options.connectTimeout = timeout ?? 5000;
  dio.options.receiveTimeout = timeout ?? 5000;

  for (var ip in ips) {
    String connLink = getConnLink(ip, port, EndPoints.serverCheck);
    dio
        .post(
      connLink,
      data: myPort,
    )
        .then((data) async {
      // here is teh right thing, the server response have the
      logger.i('My ip is ${data.data}, got from server');

      completer.complete(WorkingIpModel(
          myIp: data.data, myPort: myPort, serverIp: ip, serverPort: port));
    }).catchError((error) {
      nulls.add(null);
      if (nulls.length == ips.length) {
        completer.complete(null);
      }
    });
  }
  return completer.future;
}

Future<String> getLaptopID(ConnectLaptopProvider connectLaptopProvider) async {
  String connLink =
      connectLaptopProvider.getPhoneConnLink(EndPoints.getLaptopDeviceID);
  var data = await Dio().get(connLink);
  if (data.data.toString().isEmpty) {
    throw Exception('cant get laptop id');
  }
  return data.data.toString();
}

Future<String> getLaptopName(
  ConnectLaptopProvider connectLaptopProvider,
) async {
  String connLink =
      connectLaptopProvider.getPhoneConnLink(EndPoints.getLaptopDeviceName);
  var data = await Dio().get(connLink);
  if (data.data.toString().isEmpty) {
    throw Exception('cant get laptop name');
  }
  return data.data.toString();
}
