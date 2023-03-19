import 'dart:io';

import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/helpers/router_system/helpers/req_res_tracker.dart';
import 'package:explorer/helpers/router_system/router.dart';
import 'package:explorer/helpers/router_system/server.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/utils/connect_laptop_utils/handlers/handlers.dart';
import 'package:explorer/utils/server_utils/handlers/handlers.dart';
import 'package:explorer/utils/server_utils/middlewares.dart';

//! i need to add the logic to authenticate users here
//! i mean in the main router before entering any Handler
//! the user will provide his deviceID and sessionID for each request and upon that i will authorize him or not

//! i also need to add the logic to decode or encode headers for arabic letters with Uri.decodeComponent before sending or receiving any headers
//! After adding video streaming i will implement this

//! you will also need to find a way to know when a device lost connection without waiting for the device to send that he will leave

//? this will add the server routers(end points), and it will refer to middle wares
// CustomRouterSystem addServerRouters(
//   ServerProvider serverProvider,
//   ShareProvider shareProvider,
//   ShareItemsExplorerProvider shareItemsExplorerProvider,
// ) {
//   CustomRouterSystem customRouterSystem = CustomRouterSystem();
//   //? adding middlewares
//   customRouterSystem
//     ..addMiddleware(
//       [
//! look for this middle ware
//         getShareSpaceEndPoint,
//         clientLeftEndPoint,
//         fileAddedToShareSpaceEndPoint,
//         fileRemovedFromShareSpaceEndPoint,
//         getFolderContentEndPointEndPoint,
//         getListyEndPoint,
//       ],
//       null,
//       (request, response) => checkIfConnectedMiddleWare(
//         request,
//         response,
//         serverProvider,
//       ),
//     )
//     ..addMiddleware([], null, (request, response) async {
//       logger.i('Got Request ${request.method} - ${request.uri.path}');
//       return MiddlewareReturn(request: request, response: response);
//     })
//     ..addMiddleware(
//       [getShareSpaceEndPoint],
//       HttpMethod.GET,
//       (request, response) => getShareSpaceMiddleware(
//         request,
//         response,
//         serverProvider,
//         shareProvider,
//       ),
//     )
//     ..addHandler(
//       areYouAliveEndPoint,
//       HttpMethod.GET,
//       (request, response) => response
//         ..write('Yes i am a live')
//         ..close(),
//     )
//     ..addHandler(
//       serverCheckEndPoint,
//       HttpMethod.POST,
//       (request, response) => serverCheckHandler(
//         request,
//         response,
//         serverProvider,
//         shareProvider,
//       ),
//     )
//     ..addHandler(
//       addClientEndPoint,
//       HttpMethod.POST,
//       (request, response) => addClientHandler(
//         request,
//         response,
//         serverProvider,
//         shareProvider,
//       ),
//     )
//     ..addHandler(
//       getShareSpaceEndPoint,
//       HttpMethod.GET,
//       (request, response) => getShareSpaceHandler(
//         request,
//         response,
//         serverProvider,
//         shareProvider,
//       ),
//     )
//     ..addHandler(
//       clientAddedEndPoint,
//       HttpMethod.POST,
//       (request, response) => clientAddedHandler(
//         request,
//         response,
//         serverProvider,
//       ),
//     )
//     ..addHandler(
//       clientLeftEndPoint,
//       HttpMethod.POST,
//       (request, response) => clientLeftHandler(
//         request,
//         response,
//         serverProvider,
//       ),
//     )
//     ..addHandler(
//       fileAddedToShareSpaceEndPoint,
//       HttpMethod.POST,
//       (request, response) => fileAddedHandler(
//         request,
//         response,
//         shareItemsExplorerProvider,
//       ),
//     )
//     ..addHandler(
//       fileRemovedFromShareSpaceEndPoint,
//       HttpMethod.POST,
//       (request, response) => fileRemovedHandler(
//         request,
//         response,
//         shareItemsExplorerProvider,
//       ),
//     )
//     ..addHandler(
//       getFolderContentEndPointEndPoint,
//       HttpMethod.GET,
//       (request, response) => getFolderContentHandler(
//         request,
//         response,
//         serverProvider,
//         shareProvider,
//       ),
//     )
//     ..addHandler(
//       streamAudioEndPoint,
//       HttpMethod.GET,
//       streamAudioHandler,
//     )
//     ..addHandler(
//       streamVideoEndPoint,
//       HttpMethod.GET,
//       streamVideoHandler,
//     )
//     ..addHandler(
//       downloadFileEndPoint,
//       HttpMethod.GET,
//       downloadFileHandler,
//     )
//     ..addHandler(
//       wsServerConnLinkEndPoint,
//       HttpMethod.GET,
//       (request, response) => getWsServerConnLinkHandler(
//         request,
//         response,
//         serverProvider,
//       ),
//     )
//     ..addHandler(
//       getPeerImagePathEndPoint,
//       HttpMethod.GET,
//       (request, response) => getUserImageHandler(
//         request,
//         response,
//         shareProvider,
//       ),
//     )
//     ..addHandler(
//       getListyEndPoint,
//       HttpMethod.GET,
//       getUserListyHandler,
//     );
//   return customRouterSystem;
// }

//! add another type of middle wares that run after all handlers are done

Future<HttpServer> testingRunServerWithCustomServer(
  ServerProvider serverProvider,
  ShareProvider shareProvider,
  ShareItemsExplorerProvider shareItemsExplorerProvider,
) async {
  var router = CustomRouter()
      // .addGlobalMiddleWare((request, response) {
      //   return ReqResTracker(request, response);
      // })
      .addTrailersMiddleWare(requestLogger)
      .get(
        areYouAliveEndPoint,
        [],
        (request, response) => response
          ..write('Yes i am a live')
          ..close(),
      )
      .post(
        serverCheckEndPoint,
        [],
        serverCheckHandler,
      )
      .post(
        addClientEndPoint,
        [],
        addClientHandler,
      )
      .get(
        getShareSpaceEndPoint,
        [
          checkIfConnectedMiddleWare,
          getShareSpaceMiddleware,
        ],
        getShareSpaceHandler,
      )
      .post(
        clientAddedEndPoint,
        [],
        clientAddedHandler,
      )
      .post(
        clientLeftEndPoint,
        [checkIfConnectedMiddleWare],
        clientLeftHandler,
      )
      .post(
        fileAddedToShareSpaceEndPoint,
        [checkIfConnectedMiddleWare],
        fileAddedHandler,
      )
      .post(
        fileRemovedFromShareSpaceEndPoint,
        [checkIfConnectedMiddleWare],
        fileRemovedHandler,
      )
      .get(
        getFolderContentEndPointEndPoint,
        [checkIfConnectedMiddleWare],
        getFolderContentHandler,
      )
      .get(
        streamAudioEndPoint,
        [checkIfConnectedMiddleWare],
        streamAudioHandler,
      )
      .get(
        streamVideoEndPoint,
        [checkIfConnectedMiddleWare],
        streamVideoHandler,
      )
      .get(
        downloadFileEndPoint,
        [checkIfConnectedMiddleWare],
        downloadFileHandler,
      )
      .get(
        wsServerConnLinkEndPoint,
        [],
        getWsServerConnLinkHandler,
      )
      .get(
        getPeerImagePathEndPoint,
        [checkIfConnectedMiddleWare],
        getUserImageHandler,
      )
      .get(
        getListyEndPoint,
        [checkIfConnectedMiddleWare],
        getUserListyHandler,
      )
      .get(
        getFolderContentRecursiveEndPoint,
        [checkIfConnectedMiddleWare],
        getFolderChildrenRecursive,
      );

  CustomServer customServer = CustomServer(
    router,
    InternetAddress.anyIPv4,
    0,
  );
  return await customServer.bind();
}
