import 'dart:async';
import 'dart:io';

class MiddlewareModel {
  final FutureOr Function(HttpRequest request, HttpResponse response) callback;
  final bool closed;
  final String? closeReason;

  const MiddlewareModel(this.callback, [this.closed = false, this.closeReason]);
}
