import 'dart:io';

import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/helpers/router_system/router.dart';
import 'package:explorer/helpers/router_system/server.dart';

import 'package:explorer/utils/connect_laptop_utils/handlers/handlers.dart';
import 'package:explorer/utils/server_utils/handlers/handlers.dart';
import 'package:explorer/utils/server_utils/middlewares.dart';

Future<HttpServer> testingRunConnLaptopServerWithCustomServer() async {
  var router = CustomRouter()
      .addTrailersMiddleWare(MiddleWares.requestLogger)
      .get(EndPoints.getStorage, [], S2H.getStorageInfoHandler)
      .get(EndPoints.getDiskNames, [], S2H.getDiskNamesHandler)
      .get(EndPoints.getFolderContent, [], S2H.getPhoneFolderContentHandler)
      .get(EndPoints.streamAudio, [], S1H.streamAudioHandler)
      .get(EndPoints.streamVideo, [], S1H.streamVideoHandler)
      .get(EndPoints.getClipboard, [], S2H.getClipboardHandler)
      .get(EndPoints.getShareSpace, [], S2H.getPhoneShareSpaceHandler)
      .get(EndPoints.downloadFile, [], S1H.downloadFileHandler)
      .get(EndPoints.getFullFolderContent, [], S2H.getFolderChildrenRecursive)
      .get(EndPoints.getAndroidName, [], S2H.getAndroidNameHandler)
      .get(EndPoints.getAndroidID, [], S2H.getAndroidIdHandler)
      .post(EndPoints.sendText, [], S2H.sendTextHandler)
      .post(EndPoints.startDownloadFile, [], S2H.startDownloadActionHandler);

  CustomServer customServer = CustomServer(
    router,
    InternetAddress.anyIPv4,
    0,
  );

  return await customServer.bind();
}
