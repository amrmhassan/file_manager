import 'dart:async';
import 'dart:io';

import 'utils.dart';

class PipeLine {
  final String path;
  final HttpMethod method;
  final List<FutureOr Function(HttpRequest request, HttpResponse response)>
      middleWares;
  final FutureOr Function(HttpRequest request, HttpResponse response) handler;

  const PipeLine(this.path, this.method, this.middleWares, this.handler);
}
