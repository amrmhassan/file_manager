import 'dart:async';
import 'dart:io';

import 'package:explorer/constants/global_constants.dart';

import 'req_res_tracker.dart';
import 'request_report.dart';
import '../router.dart';
import 'utils.dart';

class RequestHandler {
  final FutureOr Function(RequestReportModel tracker)? afterEachResponse;
  late ReqResTracker tracker;
  final CustomRouter router;
  late DateTime requestReceived;
  late DateTime responseClosed;

  RequestHandler(this.router, this.afterEachResponse) {
    requestReceived = DateTime.now();
  }

  //? to distribute the listening event for the request
  void handleManageListenEvent(HttpRequest request) async {
    HttpResponse response = request.response;
    // first of all, execute global middlewares
    // second execute for each path
    // third handle all paths
    //? global middlewares
    tracker = await _handleRunMiddlewares(
      router.globalMiddlewares,
      request,
      response,
    );
    //? closing the
    if (tracker.closed) return _closed();
    tracker = await _handleRouteToPath(
      tracker.request,
      tracker.response,
    );

    _closed();

    //? for running function what will have access to the response result, after each request is closed
    _handleRunTrailerMiddlewares(
      router.trailersMiddlewares,
      request,
      response,
    );
  }

  FutureOr<ReqResTracker> _handleRouteToPath(
    HttpRequest request,
    HttpResponse response,
  ) async {
    String path = request.uri.path;
    HttpMethod method = stringToHttpMethod(request.method);
    //? getting right pipeLines
    var pipeLines = router.pipeLines.where(
      (element) =>
          (element.path == path && element.method == method) ||
          element.method == HttpMethod.ANY,
    );
    //? no pipeLine match close
    if (pipeLines.isEmpty && router.onNotFound != null) {
      // not found
      await router.onNotFound!(tracker.request, tracker.response);
      return tracker
        ..closed = true
        ..closeReason = 'Not Found path, onNotFound is null';
    } else if (pipeLines.isEmpty && router.onNotFound == null) {
      request.response
        ..write('Not found')
        ..close();
      return tracker
        ..closed = true
        ..closeReason = 'Not Found';
    }
    if (pipeLines.length > 1) {
      throw Exception('More than one path can match the request');
    }
    //
    tracker = await _handleRunMiddlewares(
      pipeLines.first.middleWares,
      request,
      response,
    );
    if (tracker.closed) return tracker;
    await _handleRunHandlers(pipeLines.first.handler, request, response);

    return tracker;
  }

  FutureOr<void> _handleRunTrailerMiddlewares(
    List<FutureOr<dynamic> Function(HttpRequest, HttpResponse)>
        trailersMiddlewares,
    HttpRequest request,
    HttpResponse response,
  ) {
    for (var trailerWare in trailersMiddlewares) {
      trailerWare(request, response);
    }
  }

  FutureOr<ReqResTracker> _handleRunMiddlewares(
    List<FutureOr<dynamic> Function(HttpRequest, HttpResponse)> middleWares,
    HttpRequest request,
    HttpResponse response,
  ) async {
    var reqResTracker =
        ReqResTracker(request, response, closed: false, closeReason: null);
    for (var middleware in middleWares) {
      var data = await middleware(request, response);
      if (data.closed) return data;
      reqResTracker = data;
    }
    return reqResTracker;
  }

  FutureOr _handleRunHandlers(
    FutureOr<dynamic> Function(HttpRequest, HttpResponse) handler,
    HttpRequest request,
    HttpResponse response,
  ) async {
    await handler(request, response);
  }

  FutureOr _closed() {
    responseClosed = DateTime.now();
    try {
      tracker.response.close();
    } catch (e) {
      logger.e(e);
    }

    if (afterEachResponse != null) {
      afterEachResponse!(RequestReportModel(
        requestReceived: requestReceived,
        responseClosed: responseClosed,
        closeReason: tracker.closeReason,
        request: tracker.request,
        response: tracker.response,
      ));
    }
  }
}
