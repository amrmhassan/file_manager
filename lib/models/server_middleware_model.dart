import 'dart:io';

import 'package:explorer/utils/server_utils/server_requests_utils.dart';

class ServerMiddlewareModel {
  final List<String> paths;
  final HttpMethod httpMethod;
  final Function(HttpRequest request, HttpResponse response) callback;

  const ServerMiddlewareModel({
    required this.paths,
    required this.httpMethod,
    required this.callback,
  });
}
