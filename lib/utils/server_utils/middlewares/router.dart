import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/utils/server_utils/custom_router_system.dart';
import 'package:explorer/utils/server_utils/middlewares/middle_wares.dart';
import 'package:explorer/utils/server_utils/server_requests_utils.dart';

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
      HttpMethod.GET,
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
      HttpMethod.GET,
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
      (request, response) => streamAudioMiddleWare(
        request,
        response,
      ),
    );
  return customRouterSystem;
}
