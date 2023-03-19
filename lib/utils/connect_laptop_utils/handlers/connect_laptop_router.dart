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
      EndPoints1.getStorageEndPoint,
      HttpMethod.GET,
      S2H.getStorageInfoHandler,
    )
    ..addHandler(
      EndPoints1.getDiskNamesEndPoint,
      HttpMethod.GET,
      S2H.getDiskNamesHandler,
    )
    ..addHandler(
      EndPoints1.getPhoneFolderContentEndPoint,
      HttpMethod.GET,
      S2H.getPhoneFolderContentHandler,
    )
    ..addHandler(
      EndPoints1.streamAudioEndPoint,
      HttpMethod.GET,
      S1H.streamAudioHandler,
    )
    ..addHandler(
      EndPoints1.streamVideoEndPoint,
      HttpMethod.GET,
      S1H.streamVideoHandler,
    )
    ..addHandler(
      EndPoints1.getClipboardEndPoint,
      HttpMethod.GET,
      S2H.getClipboardHandler,
    )
    ..addHandler(
      EndPoints1.sendTextEndpoint,
      HttpMethod.POST,
      S2H.sendTextHandler,
    )
    ..addHandler(
      EndPoints1.getShareSpaceEndPoint,
      HttpMethod.GET,
      S2H.getPhoneShareSpaceHandler,
    )
    ..addHandler(
      EndPoints1.startDownloadFileEndPoint,
      HttpMethod.POST,
      S2H.startDownloadActionHandler,
    )
    ..addHandler(
      EndPoints1.downloadFileEndPoint,
      HttpMethod.GET,
      S1H.downloadFileHandler,
    )
    ..addHandler(
      EndPoints1.getFolderContentRecursiveEndPoint,
      HttpMethod.GET,
      S2H.getFolderChildrenRecursive,
    )
    ..addHandler(
      EndPoints1.getAndroidNameEndPoint,
      HttpMethod.GET,
      S2H.getAndroidNameHandler,
    )
    ..addHandler(
      EndPoints1.getAndroidIDEndPoint,
      HttpMethod.GET,
      S2H.getAndroidIdHandler,
    );
  return customRouterSystem;
}

//! add another type of middle wares that run after all handlers are done

Future<HttpServer> testingRunConnLaptopServerWithCustomServer() async {
  var router = CustomRouter()
      .get(EndPoints1.getStorageEndPoint, [], S2H.getStorageInfoHandler)
      .get(EndPoints1.getDiskNamesEndPoint, [], S2H.getDiskNamesHandler)
      .get(EndPoints1.getPhoneFolderContentEndPoint, [],
          S2H.getPhoneFolderContentHandler)
      .get(EndPoints1.streamAudioEndPoint, [], S1H.streamAudioHandler)
      .get(EndPoints1.streamVideoEndPoint, [], S1H.streamVideoHandler)
      .get(EndPoints1.getClipboardEndPoint, [], S2H.getClipboardHandler)
      .post(EndPoints1.sendTextEndpoint, [], S2H.sendTextHandler)
      .get(EndPoints1.getShareSpaceEndPoint, [], S2H.getPhoneShareSpaceHandler)
      .post(EndPoints1.startDownloadFileEndPoint, [],
          S2H.startDownloadActionHandler)
      .get(EndPoints1.downloadFileEndPoint, [], S1H.downloadFileHandler)
      .get(EndPoints1.getFolderContentRecursiveEndPoint, [],
          S2H.getFolderChildrenRecursive)
      .get(EndPoints1.getAndroidNameEndPoint, [], S2H.getAndroidNameHandler)
      .get(EndPoints1.getAndroidIDEndPoint, [], S2H.getAndroidIdHandler);

  CustomServer customServer = CustomServer(
    router,
    InternetAddress.anyIPv4,
    0,
  );

  return await customServer.bind();
}
