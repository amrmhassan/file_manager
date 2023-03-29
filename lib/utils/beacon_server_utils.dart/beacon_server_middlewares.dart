import 'dart:io';

import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/global/modals/show_modal_funcs.dart';
import 'package:explorer/helpers/router_system/helpers/req_res_tracker.dart';
import 'package:flutter/material.dart';

class BSM {
  static Future<ReqResTracker> getMyConnLink(
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

    //? you must get the client user device id from the headers
    String? deviceID = request.headers.value(KHeaders.deviceIDHeaderKey);
    String? userName = request.headers.value(KHeaders.userNameHeaderKey);
    if (deviceID == null || userName == null) {
      response
        ..statusCode = HttpStatus.badRequest
        ..headers.add(
          KHeaders.serverRefuseReasonHeaderKey,
          'deviceID or userName aren\'t provided in headers',
        )
        ..close();
      return ReqResTracker(
        request,
        response,
        closed: true,
        closeReason: 'deviceID or userName aren\'t provided in headers',
      );
    }
    //! here check if device id is allowed or not
    //! here check if device id is allowed or not

    //
    var res = await showAskForConnLinkModal(context, userName);
    if (res == true) {
      return ReqResTracker(request, response);
    } else {
      response
        ..statusCode = HttpStatus.badRequest
        ..headers.add(KHeaders.serverRefuseReasonHeaderKey, 'Host refused you')
        ..close();
      return ReqResTracker(
        request,
        response,
        closed: true,
        closeReason: 'User is blocked',
      );
    }
  }
}
