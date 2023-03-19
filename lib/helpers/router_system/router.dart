// router => have many paths
import 'dart:async';
import 'dart:io';

import 'package:explorer/helpers/router_system/helpers/request_report.dart';

import 'helpers/pipeline.dart';
import 'helpers/req_res_tracker.dart';
import 'helpers/utils.dart';

class CustomRouter {
  final FutureOr Function(
    HttpRequest request,
    HttpResponse response,
  )? onNotFound;

  final List<PipeLine> pipeLines = [];

  final List<
      FutureOr<ReqResTracker> Function(
    HttpRequest request,
    HttpResponse response,
  )> globalMiddlewares = [];
  final List<
      FutureOr<void> Function(
    RequestReportModel requestReport,
  )> trailersMiddlewares = [];

  CustomRouter({this.onNotFound});

  //? to add a new pipe line or a path branch
  CustomRouter addPipeLine(
      String path,
      HttpMethod method,
      List<
              FutureOr<ReqResTracker> Function(
                  HttpRequest request, HttpResponse response)>
          middleWares,
      FutureOr Function(HttpRequest request, HttpResponse response) handler) {
    pipeLines.add(PipeLine(path, method, middleWares, handler));
    return this;
  }

  //? to add a global middleware that will run on each request
  CustomRouter addGlobalMiddleWare(
      FutureOr<ReqResTracker> Function(
    HttpRequest request,
    HttpResponse response,
  )
          m) {
    globalMiddlewares.add(m);
    return this;
  }

  //? to add a global middleware that will run after each response is done
  CustomRouter addTrailersMiddleWare(
      FutureOr<void> Function(
    RequestReportModel reportModel,
  )
          m) {
    trailersMiddlewares.add(m);
    return this;
  }

//? to add a get method
  CustomRouter get(
      String path,
      List<
              FutureOr<ReqResTracker> Function(
    HttpRequest request,
    HttpResponse response,
  )>
          middleWares,
      FutureOr Function(
    HttpRequest request,
    HttpResponse response,
  )
          handler) {
    return addPipeLine(path, HttpMethod.GET, middleWares, handler);
  }

//? to add a post method
  CustomRouter post(
      String path,
      List<
              FutureOr<ReqResTracker> Function(
    HttpRequest request,
    HttpResponse response,
  )>
          middleWares,
      FutureOr Function(
    HttpRequest request,
    HttpResponse response,
  )
          handler) {
    return addPipeLine(path, HttpMethod.POST, middleWares, handler);
  }
}
