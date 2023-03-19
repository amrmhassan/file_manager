// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/global/modals/show_modal_funcs.dart';
import 'package:explorer/helpers/router_system/helpers/req_res_tracker.dart';
import 'package:explorer/helpers/router_system/helpers/request_report.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class MiddleWares {
  static Future<ReqResTracker> getShareSpaceMiddleware(
    HttpRequest request,
    HttpResponse response,
  ) async {
    BuildContext? context = navigatorKey.currentContext;
    if (context == null) {
      response
        ..statusCode = HttpStatus.internalServerError
        ..write('An error with context')
        ..close();
      return ReqResTracker(
        request,
        response,
        closed: true,
        closeReason: 'Context error',
      );
    }
    var headers = request.headers;
    String? deviceID = headers.value(deviceIDHeaderKey);
    String? userName = headers.value(userNameHeaderKey);

    if (deviceID == null) {
      response
        ..statusCode = HttpStatus.badRequest
        ..headers.add(serverRefuseReasonHeaderKey, 'No device id provided')
        ..close();
      return ReqResTracker(
        request,
        response,
        closed: true,
        closeReason: 'No device id provided',
      );
    }
    if (userName == null) {
      response
        ..statusCode = HttpStatus.badRequest
        ..headers.add(serverRefuseReasonHeaderKey, 'No User name provided')
        ..close();
      return ReqResTracker(
        request,
        response,
        closed: true,
        closeReason: 'No user name provided',
      );
    }
    if (await serverPF(context).isPeerAllowed(deviceID)) {
      return ReqResTracker(request, response);
    } else if (await serverPF(context).isPeerBlocked(deviceID)) {
      response
        ..statusCode = HttpStatus.badRequest
        ..headers.add(serverRefuseReasonHeaderKey, 'You are blocked')
        ..close();
      return ReqResTracker(
        request,
        response,
        closed: true,
        closeReason: 'User is blocked',
      );
    }

    bool res = await showAskForShareSpaceModal(
      userName,
      deviceID,
      navigatorKey.currentContext!,
    );

    if (res) {
      return ReqResTracker(request, response);
    } else {
      response
        ..statusCode = HttpStatus.badRequest
        ..headers.add(serverRefuseReasonHeaderKey, 'You are blocked')
        ..close();
      return ReqResTracker(
        request,
        response,
        closed: true,
        closeReason: 'User is blocked',
      );
    }
  }

  static Future<ReqResTracker> checkIfConnectedMiddleWare(
    HttpRequest request,
    HttpResponse response,
  ) async {
    BuildContext? context = navigatorKey.currentContext;
    if (context == null) {
      response
        ..statusCode = HttpStatus.internalServerError
        ..write('An error with context')
        ..close();
      return ReqResTracker(
        request,
        response,
        closed: true,
        closeReason: 'error with context',
      );
    }
    var serverProvider = serverPF(context);
    String? ip = request.connectionInfo?.remoteAddress.address;
    int? port =
        int.tryParse(request.headers.value(myServerPortHeaderKey) ?? '');
    // if data not provided, just return
    if (ip == null || port == null) {
      response
        ..statusCode = HttpStatus.forbidden
        ..write('Fu** you hacker, we caught you and hacked your fuc** device')
        ..close();
      return ReqResTracker(
        request,
        response,
        closed: true,
        closeReason: 'loser hacker',
      );
    }
    // if he isn't connected, just return
    bool connected = serverProvider.ifPeerConnected(ip, port);
    if (!connected) {
      response
        ..statusCode = HttpStatus.forbidden
        ..write('Fu** you hacker, we caught you and hacked your fuc** device')
        ..close();
      return ReqResTracker(
        request,
        response,
        closed: true,
        closeReason: 'loser hacker',
      );
    }
    return ReqResTracker(
      request,
      response,
    );
  }

  static void requestLogger(RequestReportModel reportModel) {
    logger.i(
        '${reportModel.request.method.toUpperCase()}-${reportModel.request.uri.path} -${reportModel.timeTaken.inMilliseconds}ms -${reportModel.response.statusCode}');
  }
}
