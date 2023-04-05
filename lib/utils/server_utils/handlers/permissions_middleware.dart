// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/global/modals/show_modal_funcs.dart';
import 'package:explorer/helpers/router_system/helpers/req_res_tracker.dart';
import 'package:explorer/models/peer_permissions_model.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class PermissionsMiddlewares {
  static Future<ReqResTracker> handlePermissions(
    HttpRequest request,
    HttpResponse response,
    PermissionName permissionName,
  ) async {
    //? getting the context
    BuildContext? context = navigatorKey.currentContext;
    if (context == null) {
      return _blockUser(request, response, 'An error with context');
    }

    //? getting user info from headers like deviceID and user device name
    var headers = request.headers;
    String? deviceID = headers.value(KHeaders.deviceIDHeaderKey);
    String? userName = headers.value(KHeaders.userNameHeaderKey);

    //? checking if the user provided his id or not
    if (deviceID == null) {
      return _blockUser(request, response, 'No device id provided');
    }

    //? checking if the user provided his name or not
    if (userName == null) {
      return _blockUser(request, response, 'No User name provided');
    }
    var permissionsProvider = permissionsPF(context);

    PermissionStatus permissionStatus = permissionsProvider.getPermissionStatus(
      deviceID,
      permissionName: permissionName,
      userName: userName,
    );
    String refuseMessage =
        PermissionsNamesUtils.blockPermissionReadable(permissionName);

    if (permissionStatus == PermissionStatus.allowed) {
      //? here the device is allowed and you can pass him
      return ReqResTracker(request, response);
    } else if (permissionStatus == PermissionStatus.blocked) {
      //! here the device is blocked and you should prevent him and send an error message

      return _blockUser(
        request,
        response,
        refuseMessage,
      );
    } else if (permissionStatus == PermissionStatus.ask) {
      // here i want to show a modal that ask the current user about the permission
      bool res = await showAskForFeaturePermissionModal(
        userName,
        deviceID,
        permissionName,
        context,
      );
      if (res) {
        //? this means that the user is accepted so accept ( no care if it is remembered or not)
        return ReqResTracker(request, response);
      } else {
        //? this means the user is refused so refuse ( no care if it is remembered or not)
        return _blockUser(
          request,
          response,
          refuseMessage,
        );
      }
    }

    response
      ..statusCode = HttpStatus.badRequest
      ..headers
          .add(KHeaders.serverRefuseReasonHeaderKey, 'Unknown reason to block')
      ..close();
    return ReqResTracker(
      request,
      response,
      closed: true,
      closeReason: 'Unknown reason to block',
    );
  }

  static ReqResTracker _blockUser(
    HttpRequest request,
    HttpResponse response,
    String refuseMessage,
  ) {
    response
      ..statusCode = HttpStatus.forbidden
      ..headers
          .add(KHeaders.serverRefuseReasonHeaderKey, utf8.encode(refuseMessage))
      ..write(refuseMessage)
      ..close();
    return ReqResTracker(
      request,
      response,
      closed: true,
      closeReason: refuseMessage,
    );
  }
}
