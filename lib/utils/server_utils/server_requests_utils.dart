// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/server_utils/custom_router_system.dart';
import 'package:explorer/utils/server_utils/server_feedback_utils.dart';

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

String jsonify(Map<String, dynamic> obj) {
  return json.encode(obj);
}

//? this will add the server routers(end points)
CustomRouterSystem addServerRouters(
  ServerProvider serverProvider,
  ShareProvider shareProvider,
) {
  CustomRouterSystem customRouterSystem = CustomRouterSystem();
  customRouterSystem
    //? a new client added
    ..addRouter('/addClient', HttpMethod.GET, (request, response) async {
      var headers = request.headers;
      String name = headers.value('name') as String;
      String deviceID = headers.value('deviceID') as String;
      String ip = headers.value('ip') as String;
      int port = int.parse(headers.value('port') as String);
      String sessionID = serverProvider.addPeer(deviceID, name, ip, port);
      response
        ..headers.contentType = ContentType.json
        ..write(
          jsonify(
            {
              'sessionID': sessionID,
              'deviceID': deviceID,
              'name': name,
              'ip': ip,
              'port': port,
            },
          ),
        );
      await peerAdded(serverProvider);
    })
    //? to get the share space
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
