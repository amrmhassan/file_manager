import 'dart:io';

import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/helpers/router_system/router.dart';
import 'package:explorer/helpers/router_system/server.dart';

import 'package:explorer/utils/connect_laptop_utils/handlers/handlers.dart';
import 'package:explorer/utils/custom_router_system/custom_router_system.dart';
import 'package:explorer/utils/custom_router_system/helpers/server_requests_utils.dart';
import 'package:explorer/utils/server_utils/handlers/handlers.dart';

CustomRouterSystem connectLaptopRouter() {
  CustomRouterSystem customRouterSystem = CustomRouterSystem();

  //? adding handlers
  customRouterSystem
    ..addHandler(
      EndPoints.getStorage,
      HttpMethod.GET,
      S2H.getStorageInfoHandler,
    )
    ..addHandler(
      EndPoints.getDiskNames,
      HttpMethod.GET,
      S2H.getDiskNamesHandler,
    )
    ..addHandler(
      EndPoints.getPhoneFolderContent,
      HttpMethod.GET,
      S2H.getPhoneFolderContentHandler,
    )
    ..addHandler(
      EndPoints.streamAudio,
      HttpMethod.GET,
      S1H.streamAudioHandler,
    )
    ..addHandler(
      EndPoints.streamVideo,
      HttpMethod.GET,
      S1H.streamVideoHandler,
    )
    ..addHandler(
      EndPoints.getClipboard,
      HttpMethod.GET,
      S2H.getClipboardHandler,
    )
    ..addHandler(
      EndPoints.sendText,
      HttpMethod.POST,
      S2H.sendTextHandler,
    )
    ..addHandler(
      EndPoints.getShareSpace,
      HttpMethod.GET,
      S2H.getPhoneShareSpaceHandler,
    )
    ..addHandler(
      EndPoints.startDownloadFile,
      HttpMethod.POST,
      S2H.startDownloadActionHandler,
    )
    ..addHandler(
      EndPoints.downloadFile,
      HttpMethod.GET,
      S1H.downloadFileHandler,
    )
    ..addHandler(
      EndPoints.getFullFolderContent,
      HttpMethod.GET,
      S2H.getFolderChildrenRecursive,
    )
    ..addHandler(
      EndPoints.getAndroidName,
      HttpMethod.GET,
      S2H.getAndroidNameHandler,
    )
    ..addHandler(
      EndPoints.getAndroidID,
      HttpMethod.GET,
      S2H.getAndroidIdHandler,
    );
  return customRouterSystem;
}

//! add another type of middle wares that run after all handlers are done

Future<HttpServer> testingRunConnLaptopServerWithCustomServer() async {
  var router = CustomRouter()
      .get(EndPoints.getStorage, [], S2H.getStorageInfoHandler)
      .get(EndPoints.getDiskNames, [], S2H.getDiskNamesHandler)
      .get(
          EndPoints.getPhoneFolderContent, [], S2H.getPhoneFolderContentHandler)
      .get(EndPoints.streamAudio, [], S1H.streamAudioHandler)
      .get(EndPoints.streamVideo, [], S1H.streamVideoHandler)
      .get(EndPoints.getClipboard, [], S2H.getClipboardHandler)
      .post(EndPoints.sendText, [], S2H.sendTextHandler)
      .get(EndPoints.getShareSpace, [], S2H.getPhoneShareSpaceHandler)
      .post(EndPoints.startDownloadFile, [], S2H.startDownloadActionHandler)
      .get(EndPoints.downloadFile, [], S1H.downloadFileHandler)
      .get(EndPoints.getFullFolderContent, [], S2H.getFolderChildrenRecursive)
      .get(EndPoints.getAndroidName, [], S2H.getAndroidNameHandler)
      .get(EndPoints.getAndroidID, [], S2H.getAndroidIdHandler);

  CustomServer customServer = CustomServer(
    router,
    InternetAddress.anyIPv4,
    0,
  );

  return await customServer.bind();
}
