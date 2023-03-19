import 'dart:io';

class RequestReportModel {
  DateTime requestReceived;
  DateTime responseClosed;
  String? closeReason;
  HttpRequest request;
  HttpResponse response;
  late Duration timeTaken;

  RequestReportModel({
    required this.requestReceived,
    required this.responseClosed,
    required this.closeReason,
    required this.request,
    required this.response,
  }) {
    timeTaken = responseClosed.difference(requestReceived);
  }
}
