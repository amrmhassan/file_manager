import 'dart:io';

import 'package:explorer/utils/server_utils/server_requests_utils.dart';

class ServerMiddlewareModel {
  final List<String> paths;
  final HttpMethod httpMethod;
  final Future<MiddlewareReturn> Function(
      HttpRequest request, HttpResponse response) callback;

  const ServerMiddlewareModel({
    required this.paths,
    required this.httpMethod,
    required this.callback,
  });
}

class MiddlewareReturn {
  final HttpRequest request;
  final HttpResponse response;
  final bool closed;
  final String? closeReason;

  const MiddlewareReturn({
    required this.request,
    required this.response,
    this.closed = false,
    this.closeReason,
  });
}
