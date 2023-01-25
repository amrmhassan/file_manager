import 'dart:io';

import 'package:explorer/utils/server_utils/server_requests_utils.dart';

class ServerRouterModel {
  final String path;
  final HttpMethod method;
  final Function(HttpRequest request, HttpResponse response) callback;

  const ServerRouterModel({
    required this.path,
    required this.method,
    required this.callback,
  });
}
