import 'dart:io';

import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/helpers/router_system/router.dart';
import 'package:explorer/helpers/router_system/server.dart';
import 'package:explorer/models/peer_permissions_model.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/utils/connect_laptop_utils/handlers/handlers.dart';
import 'package:explorer/utils/server_utils/handlers/handlers.dart';
import 'package:explorer/utils/server_utils/handlers/permissions_middleware.dart';
import 'package:explorer/utils/server_utils/middlewares.dart';

Future<HttpServer> testingRunServerWithCustomServer(
  ServerProvider serverProvider,
  ShareProvider shareProvider,
  ShareItemsExplorerProvider shareItemsExplorerProvider,
) async {
  var router = CustomRouter()
      // this will print every request after it's done and it's response sent
      .addTrailersMiddleWare(MiddleWares.requestLogger)
      // this is a dummy endpoint for checking if the server is alive or not
      .get(
        EndPoints.areYouAlive,
        [],
        (request, response) => response
          ..write('Yes i am a live')
          ..close(),
      )
      // this is the server check handler that do all the logic of getting my ip
      .post(
        EndPoints.serverCheck,
        [],
        S1H.serverCheckHandler,
      )
      // to add a client
      .post(
        EndPoints.addClient,
        [],
        S1H.addClientHandler,
      )
      // to get my share space
      .get(
        EndPoints.getShareSpace,
        [
          MiddleWares.checkIfConnectedMiddleWare,
          // MiddleWares.getShareSpaceMiddleware,
          (request, response) => PermissionsMiddlewares.getShareSpaceMiddleware(
                request,
                response,
                PermissionName.shareSpace,
              ),
        ],
        S1H.getShareSpaceHandler,
      )
      // to listen for client adding(if i am not the host the host will call this for every client)
      .post(
        EndPoints.clientAdded,
        [],
        S1H.clientAddedHandler,
      )
      // to listen for client left(if i am not the host the host will call this for every client)
      .post(
        EndPoints.clientLeft,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.clientLeftHandler,
      )
      // to notify about files adding to share space
      .post(
        EndPoints.fileAddedToShareSpace,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.fileAddedHandler,
      )
      // to notify about files removed to share space
      .post(
        EndPoints.fileRemovedFromShareSpace,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.fileRemovedHandler,
      )
      // to get a folder content
      .get(
        EndPoints.getFolderContentEndPoint,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.getFolderContentHandler,
      )
      //
      .get(
        EndPoints.streamAudio,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.streamAudioHandler,
      )
      //
      .get(
        EndPoints.streamVideo,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.streamVideoHandler,
      )
      //
      .get(
        EndPoints.downloadFile,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.downloadFileHandler,
      )
      // to get my websocket server link
      .get(
        EndPoints.wsServerConnLink,
        [],
        S1H.getWsServerConnLinkHandler,
      )
      .get(
        EndPoints.getPeerImagePath,
        // i removed this image to allow users see the beacon server image
        [],
        S1H.getUserImageHandler,
      )
      // to get my listy
      .get(
        EndPoints.getListy,
        [MiddleWares.checkIfConnectedMiddleWare],
        S1H.getUserListyHandler,
      )
      // to get full folder content(recursive)
      .get(
        EndPoints.getFullFolderContent,
        [MiddleWares.checkIfConnectedMiddleWare],
        S2H.getFolderChildrenRecursive,
      )
      //? new features endpoints
      .get(
        EndPoints.getDiskNames,
        [
          MiddleWares.checkIfConnectedMiddleWare,
          (request, response) => PermissionsMiddlewares.getShareSpaceMiddleware(
                request,
                response,
                PermissionName.fileExploring,
              ),
        ],
        S2H.getDiskNamesHandler,
      )
      .get(
        EndPoints.getFolderContent,
        [MiddleWares.checkIfConnectedMiddleWare],
        S2H.getPhoneFolderContentHandler,
      )
      .get(
        EndPoints.getClipboard,
        [
          MiddleWares.checkIfConnectedMiddleWare,
          (request, response) => PermissionsMiddlewares.getShareSpaceMiddleware(
                request,
                response,
                PermissionName.copyClipboard,
              ),
        ],
        S2H.getClipboardHandler,
      )
      .get(
        EndPoints.getAndroidName,
        [MiddleWares.checkIfConnectedMiddleWare],
        S2H.getAndroidNameHandler,
      )
      .post(
        EndPoints.sendText,
        [
          MiddleWares.checkIfConnectedMiddleWare,
          (request, response) => PermissionsMiddlewares.getShareSpaceMiddleware(
                request,
                response,
                PermissionName.sendText,
              ),
        ],
        S2H.sendTextHandler,
      )
      .post(
        EndPoints.startDownloadFile,
        [
          MiddleWares.checkIfConnectedMiddleWare,
          (request, response) => PermissionsMiddlewares.getShareSpaceMiddleware(
                request,
                response,
                PermissionName.sendFile,
              ),
        ],
        S1H.startDownloadActionHandler,
      );

  CustomServer customServer = CustomServer(
    router,
    InternetAddress.anyIPv4,
    0,
  );
  return await customServer.bind();
}
