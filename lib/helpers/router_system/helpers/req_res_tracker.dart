import 'dart:io';

class ReqResTracker {
  HttpRequest request;
  HttpResponse response;
  bool closed;
  String? closeReason;

  ReqResTracker(
    this.request,
    this.response, {
    this.closed = false,
    this.closeReason,
  });
}
