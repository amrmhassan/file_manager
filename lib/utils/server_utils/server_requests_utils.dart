// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/server_utils/custom_router_system.dart';

//? used
enum HttpMethod {
  GET,
  POST,
  DELETE,
  UNKNOWN,
}

//? to convert the method string from the request object to enum
HttpMethod stringToHttpMethod(String m) {
  if (m == 'GET') {
    return HttpMethod.GET;
  } else if (m == 'POST') {
    return HttpMethod.POST;
  } else if (m == 'DELETE') {
    return HttpMethod.DELETE;
  } else {
    return HttpMethod.UNKNOWN;
  }
}

//? this will add the server routers(end points)
CustomRouterSystem addServerRouters(
  ServerProvider serverProvider,
  ShareProvider shareProvider,
) {
  CustomRouterSystem customRouterSystem = CustomRouterSystem();
  customRouterSystem
    ..addRouter('/addClient', HttpMethod.GET, (request, response) {
      var headers = request.headers;
      String name = headers.value('name') as String;
      String deviceID = headers.value('deviceID') as String;
      serverProvider.addClient(deviceID, name);
    })
    ..addRouter('/getShareSpace', HttpMethod.GET, (request, response) {
      List<Map<String, String>> sharedItemsMap = shareProvider.sharedItems
          .map((e) => {
                'path': e.path,
                'entityType': e.entityType.toString(),
                'ownerID': e.ownerID,
              })
          .toList();
      String jsonResponse = json.encode(sharedItemsMap);
      response
        ..headers.contentType = ContentType.json
        ..write(jsonResponse);
    })
    ..addRouter('/test', HttpMethod.GET, (request, response) {
      response.write('test end point hit');
    });
  return customRouterSystem;
}
