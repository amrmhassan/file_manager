import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/utils/connect_laptop_utils/handlers/handlers.dart'
    as laptop_handlers;
import 'package:explorer/utils/custom_router_system/custom_router_system.dart';
import 'package:explorer/utils/custom_router_system/helpers/server_requests_utils.dart';
import 'package:explorer/utils/server_utils/handlers/handlers.dart'
    as normal_handlers;

CustomRouterSystem connectLaptopRouter() {
  CustomRouterSystem customRouterSystem = CustomRouterSystem();

  //? adding handlers
  customRouterSystem
    ..addHandler(
      getStorageEndPoint,
      HttpMethod.GET,
      laptop_handlers.getStorageInfoHandler,
    )
    ..addHandler(
      getDiskNamesEndPoint,
      HttpMethod.GET,
      laptop_handlers.getDiskNamesHandler,
    )
    ..addHandler(
      getPhoneFolderContentEndPoint,
      HttpMethod.GET,
      laptop_handlers.getPhoneFolderContentHandler,
    )
    ..addHandler(
      streamAudioEndPoint,
      HttpMethod.GET,
      normal_handlers.streamAudioHandler,
    )
    ..addHandler(
      streamVideoEndPoint,
      HttpMethod.GET,
      normal_handlers.streamVideoHandler,
    )
    ..addHandler(
      getClipboardEndPoint,
      HttpMethod.GET,
      laptop_handlers.getClipboardHandler,
    )
    ..addHandler(
      sendTextEndpoint,
      HttpMethod.POST,
      laptop_handlers.sendTextHandler,
    )
    ..addHandler(
      getShareSpaceEndPoint,
      HttpMethod.GET,
      laptop_handlers.getPhoneShareSpaceHandler,
    )
    ..addHandler(
      startDownloadFileEndPoint,
      HttpMethod.POST,
      laptop_handlers.startDownloadActionHandler,
    )
    ..addHandler(
      downloadFileEndPoint,
      HttpMethod.GET,
      normal_handlers.downloadFileHandler,
    )
    ..addHandler(
      getFolderContentRecursiveEndPoint,
      HttpMethod.GET,
      laptop_handlers.getFolderChildrenRecursive,
    )
    ..addHandler(
      getAndroidNameEndPoint,
      HttpMethod.GET,
      laptop_handlers.getAndroidNameHandler,
    )
    ..addHandler(
      getAndroidIDEndPoint,
      HttpMethod.GET,
      laptop_handlers.getAndroidIdHandler,
    );
  return customRouterSystem;
}
