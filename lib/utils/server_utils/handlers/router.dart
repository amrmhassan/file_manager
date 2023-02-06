import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/utils/server_utils/custom_router_system.dart';
import 'package:explorer/utils/server_utils/handlers/handlers.dart';
import 'package:explorer/utils/server_utils/server_requests_utils.dart';

//! i need to add the logic to authenticate users here
//! i mean in the main router before entering any Handler
//! the user will provide his deviceID and sessionID for each request and upon that i will authorize him or not

//! i also need to add the logic to decode or encode headers for arabic letters with Uri.decodeComponent before sending or receiving any headers
//! After adding video streaming i will implement this

//! you will also need to find a way to know when a device lost connection without waiting for the device to send that he will leave

//? this will add the server routers(end points), and it will refer to middle wares
CustomRouterSystem addServerRouters(
  ServerProvider serverProvider,
  ShareProvider shareProvider,
  ShareItemsExplorerProvider shareItemsExplorerProvider,
) {
  CustomRouterSystem customRouterSystem = CustomRouterSystem();
  customRouterSystem
    ..addRouter(
      addClientEndPoint,
      HttpMethod.POST,
      (request, response) => addClientHandler(
        request,
        response,
        serverProvider,
        shareProvider,
      ),
    )
    ..addRouter(
      getShareSpaceEndPoint,
      HttpMethod.GET,
      (request, response) => getShareSpaceHandler(
        request,
        response,
        serverProvider,
        shareProvider,
      ),
    )
    ..addRouter(
      clientAddedEndPoint,
      HttpMethod.POST,
      (request, response) => clientAddedHandler(
        request,
        response,
        serverProvider,
      ),
    )
    ..addRouter(
      clientLeftEndPoint,
      HttpMethod.POST,
      (request, response) => clientLeftHandler(
        request,
        response,
        serverProvider,
      ),
    )
    ..addRouter(
      fileAddedToShareSpaceEndPoint,
      HttpMethod.POST,
      (request, response) => fileAddedHandler(
        request,
        response,
        shareItemsExplorerProvider,
      ),
    )
    ..addRouter(
      fileRemovedFromShareSpaceEndPoint,
      HttpMethod.POST,
      (request, response) => fileRemovedHandler(
        request,
        response,
        shareItemsExplorerProvider,
      ),
    )
    ..addRouter(
      getFolderContentEndPointEndPoint,
      HttpMethod.GET,
      (request, response) => getFolderContentHandler(
        request,
        response,
        serverProvider,
        shareProvider,
      ),
    )
    ..addRouter(
      streamAudioEndPoint,
      HttpMethod.GET,
      streamAudioHandler,
    )
    ..addRouter(
      streamVideoEndPoint,
      HttpMethod.GET,
      streamVideoHandler,
    )
    ..addRouter(
      downloadFileEndPoint,
      HttpMethod.GET,
      downloadFileHandler,
    )
    ..addRouter(
      wsServerConnLinkEndPoint,
      HttpMethod.GET,
      (request, response) => getWsServerConnLink(
        request,
        response,
        serverProvider,
      ),
    );
  return customRouterSystem;
}
