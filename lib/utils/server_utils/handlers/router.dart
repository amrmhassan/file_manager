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
        EndPoints1.areYouAliveEndPoint,
        [],
        (request, response) => response
          ..write('Yes i am a live')
          ..close(),
      )
      .post(
        EndPoints1.serverCheckEndPoint,
        [],
        S1H.serverCheckHandler,
      )
      .post(
        EndPoints1.addClientEndPoint,
        [],
        S1H.addClientHandler,
      )
      .get(
        EndPoints1.getShareSpaceEndPoint,
        [
          MiddleWares.checkIfConnectedMiddleWare,
          MiddleWares.getShareSpaceMiddleware,
        ],
        S1H.getShareSpaceHandler,
      )
      .post(
        EndPoints1.clientAddedEndPoint,
        [],
        S1H.clientAddedHandler,
      )
      .post(
        EndPoints1.clientLeftEndPoint,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.clientLeftHandler,
      )
      .post(
        EndPoints1.fileAddedToShareSpaceEndPoint,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.fileAddedHandler,
      )
      .post(
        EndPoints1.fileRemovedFromShareSpaceEndPoint,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.fileRemovedHandler,
      )
      .get(
        EndPoints1.getFolderContentEndPointEndPoint,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.getFolderContentHandler,
      )
      .get(
        EndPoints1.streamAudioEndPoint,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.streamAudioHandler,
      )
      .get(
        EndPoints1.streamVideoEndPoint,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.streamVideoHandler,
      )
      .get(
        EndPoints1.downloadFileEndPoint,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.downloadFileHandler,
      )
      .get(
        EndPoints1.wsServerConnLinkEndPoint,
        [],
        S1H.getWsServerConnLinkHandler,
      )
      .get(
        EndPoints1.getPeerImagePathEndPoint,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.getUserImageHandler,
      )
      .get(
        EndPoints1.getListyEndPoint,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.getUserListyHandler,
      )
      .get(
        EndPoints1.getFolderContentRecursiveEndPoint,
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
