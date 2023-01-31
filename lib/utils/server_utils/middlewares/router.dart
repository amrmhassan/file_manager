import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/utils/server_utils/custom_router_system.dart';
import 'package:explorer/utils/server_utils/middlewares/middle_wares.dart';
import 'package:explorer/utils/server_utils/server_requests_utils.dart';

//! i need to add the logic to authenticate users here
//! i mean in the main router before entering any middleware
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
      (request, response) => addClientMiddleWare(
        request,
        response,
        serverProvider,
      ),
    )
    ..addRouter(
      getShareSpaceEndPoint,
      HttpMethod.GET,
      (request, response) => getShareSpaceMiddleWare(
        request,
        response,
        serverProvider,
        shareProvider,
      ),
    )
    ..addRouter(
      clientAddedEndPoint,
      HttpMethod.GET,
      (request, response) => clientAddedMiddleWare(
        request,
        response,
        serverProvider,
      ),
    )
    ..addRouter(
      clientLeftEndPoint,
      HttpMethod.POST,
      (request, response) => clientLeftMiddleWare(
        request,
        response,
        serverProvider,
      ),
    )
    ..addRouter(
      fileAddedToShareSpaceEndPoint,
      HttpMethod.POST,
      (request, response) => fileAddedMiddleWare(
        request,
        response,
        shareItemsExplorerProvider,
      ),
    )
    ..addRouter(
      fileRemovedFromShareSpaceEndPoint,
      HttpMethod.POST,
      (request, response) => fileRemovedMiddleWare(
        request,
        response,
        shareItemsExplorerProvider,
      ),
    )
    ..addRouter(
      getFolderContentEndPointEndPoint,
      HttpMethod.GET,
      (request, response) => getFolderContentMiddleWare(
        request,
        response,
        serverProvider,
        shareProvider,
      ),
    )
    ..addRouter(
      streamAudioEndPoint,
      HttpMethod.GET,
      streamAudioMiddleWare,
    )
    ..addRouter(
      streamVideoEndPoint,
      HttpMethod.GET,
      streamVideoMiddleWare,
    )
    ..addRouter(
      downloadFileEndPoint,
      HttpMethod.GET,
      downloadFileMiddleWare,
    );
  return customRouterSystem;
}
