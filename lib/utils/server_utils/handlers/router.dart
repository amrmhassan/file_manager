import 'dart:io';

import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/helpers/router_system/router.dart';
import 'package:explorer/helpers/router_system/server.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/utils/connect_laptop_utils/handlers/handlers.dart';
import 'package:explorer/utils/server_utils/handlers/handlers.dart';
import 'package:explorer/utils/server_utils/middlewares.dart';

Future<HttpServer> testingRunServerWithCustomServer(
  ServerProvider serverProvider,
  ShareProvider shareProvider,
  ShareItemsExplorerProvider shareItemsExplorerProvider,
) async {
  var router = CustomRouter()
      // .addGlobalMiddleWare((request, response) {
      //   return ReqResTracker(request, response);
      // })
      .addTrailersMiddleWare(MiddleWares.requestLogger)
      .get(
        EndPoints.areYouAlive,
        [],
        (request, response) => response
          ..write('Yes i am a live')
          ..close(),
      )
      .post(
        EndPoints.serverCheck,
        [],
        S1H.serverCheckHandler,
      )
      .post(
        EndPoints.addClient,
        [],
        S1H.addClientHandler,
      )
      .get(
        EndPoints.getShareSpace,
        [
          MiddleWares.checkIfConnectedMiddleWare,
          MiddleWares.getShareSpaceMiddleware,
        ],
        S1H.getShareSpaceHandler,
      )
      .post(
        EndPoints.clientAdded,
        [],
        S1H.clientAddedHandler,
      )
      .post(
        EndPoints.clientLeft,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.clientLeftHandler,
      )
      .post(
        EndPoints.fileAddedToShareSpace,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.fileAddedHandler,
      )
      .post(
        EndPoints.fileRemovedFromShareSpace,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.fileRemovedHandler,
      )
      .get(
        EndPoints.getFolderContentEndPoint,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.getFolderContentHandler,
      )
      .get(
        EndPoints.streamAudio,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.streamAudioHandler,
      )
      .get(
        EndPoints.streamVideo,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.streamVideoHandler,
      )
      .get(
        EndPoints.downloadFile,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.downloadFileHandler,
      )
      .get(
        EndPoints.wsServerConnLink,
        [],
        S1H.getWsServerConnLinkHandler,
      )
      .get(
        EndPoints.getPeerImagePath,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.getUserImageHandler,
      )
      .get(
        EndPoints.getListy,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.getUserListyHandler,
      )
      .get(
        EndPoints.getFullFolderContent,
        [MiddleWares.checkIfConnectedMiddleWare],
        S2H.getFolderChildrenRecursive,
      );

  CustomServer customServer = CustomServer(
    router,
    InternetAddress.anyIPv4,
    0,
  );
  return await customServer.bind();
}
