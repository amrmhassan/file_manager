import 'dart:io';

class RequestReportModel {
  late Duration duration;
  DateTime requestReceived;
  DateTime responseClosed;
  String? closeReason;
  HttpRequest request;
  HttpResponse response;

  RequestReportModel({
    required this.requestReceived,
    required this.responseClosed,
    required this.closeReason,
    required this.request,
    required this.response,
  }) {
    duration = responseClosed.difference(requestReceived);
  }
}
