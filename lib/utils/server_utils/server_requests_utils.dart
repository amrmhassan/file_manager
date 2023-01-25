// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

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
CustomRouterSystem addServerRouters() {
  CustomRouterSystem customRouterSystem = CustomRouterSystem();
  customRouterSystem
    ..addRouter('/', HttpMethod.GET, (request, response) {
      response
        ..headers.contentType = ContentType.json
        ..write(json.encode({
          'name': 'Amr Mohamed Hassan',
          'age': 20,
        }));
    })
    ..addRouter('/test', HttpMethod.GET, (request, response) {
      response.write('test end point hit');
    });
  return customRouterSystem;
}
