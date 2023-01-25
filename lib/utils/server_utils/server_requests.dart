// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';

enum HttpMethod {
  GET,
  POST,
  DELETE,
  UNKNOWN,
}

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

//? to handle the server requests in the share provider(for server part)
void handleServerRequests(HttpRequest request) {}

//? this will handle adding routers like /, /addfile, /done, /info, etc...
class CustomRouterSystem {
  List<RouterModel> routers = [];

  void addRouter(
    String path,
    HttpMethod method,
    Function(HttpRequest request) callback,
  ) {
    RouterModel routerModel = RouterModel(
      path: path,
      method: method,
      callback: callback,
    );
    routers.add(routerModel);
  }

  void applyRouters() {
    for (var router in routers) {}
  }
}

class RouterModel {
  final String path;
  final HttpMethod method;
  final Function(HttpRequest request) callback;

  const RouterModel({
    required this.path,
    required this.method,
    required this.callback,
  });
}

void router(
  String path,
  HttpMethod method,
  HttpRequest request,
  VoidCallback callback,
) {
  String requestedPath = request.uri.path;
  HttpMethod method = stringToHttpMethod(request.method);
  if (requestedPath == '/') {
    request.response
      ..write('this is testing response')
      ..close();
  } else if (requestedPath == '/done') {
    request.response.close();
  } else if (requestedPath == '/filename') {
    request.response
      ..write('this is supposed to send the file name')
      ..close();
  }
}
