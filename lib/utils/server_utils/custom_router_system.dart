import 'dart:io';

import 'package:explorer/models/server_router_model.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/server_utils/server_requests_utils.dart';

class CustomRouterSystem {
  List<ServerRouterModel> routers = [];

  void addRouter(
    String path,
    HttpMethod method,
    Function(HttpRequest request, HttpResponse response) callback,
  ) {
    if (routers
        .any((element) => element.path == path && element.method == method)) {
      throw Exception(
          'This endpoint(router) is already defined : $path $method');
    }
    ServerRouterModel routerModel = ServerRouterModel(
      path: path,
      method: method,
      callback: callback,
    );
    routers.add(routerModel);
  }

  void handleListen(HttpRequest request) async {
    HttpMethod method = stringToHttpMethod(request.method);
    for (var router in routers) {
      Uri uri = Uri.parse(router.path);
      if (request.uri.path.contains(uri.path) && router.method == method) {
        await router.callback(request, request.response);
        //? i added this close statement here to skip typing it in each request
        try {
          request.response.close();
        } catch (e) {
          printOnDebug(e);
          printOnDebug('Can\'nt close the stream');
        }
        //? to break from the loop if the wanted endpoint satisfied
        break;
      }
    }
  }
}
