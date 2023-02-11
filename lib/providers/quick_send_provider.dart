import 'dart:io';

import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/server_utils/connection_utils.dart';
import 'package:explorer/utils/server_utils/ip_utils.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class QuickSendProvider extends ChangeNotifier {
  String? myIp;
  int port = 0;
  String? fileConnLink;
  HttpServer? httpServer;

  Future<void> quickShareFile(String filePath, bool wifi) async {
    try {
      myIp = await getMyIpAddress(wifi);
      if (myIp == null) {
        throw CustomException(
          e: wifi ? 'No Connected' : 'Open Your HotSpot please',
          s: StackTrace.current,
          rethrowError: true,
        );
      }
      httpServer = await HttpServer.bind(InternetAddress.anyIPv4, port);
      fileConnLink = getConnLink(myIp!, port);

      if (httpServer == null) {
        throw CustomException(e: 'Error occurred during opening server');
      }
      httpServer!.listen((HttpRequest req) {
        var file = File(filePath);
        int length = file.lengthSync();
        String? mime = lookupMimeType(filePath);

        req.response.statusCode = HttpStatus.partialContent;
        req.response.headers
          ..contentType = ContentType.parse(mime ?? 'audio/mpeg')
          ..contentLength = length;
        file.openRead().pipe(req.response);
      });
    } catch (e) {
      await closeSend();
      rethrow;
    }
  }

  Future<void> closeSend() async {
    await httpServer?.close();
    httpServer = null;
    fileConnLink = null;
    myIp = null;
    notifyListeners();
  }
}
