import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/providers/connect_laptop_provider.dart';
import 'package:explorer/utils/connect_laptop_utils/handlers/handlers.dart'
    as laptop_handlers;
import 'package:explorer/utils/custom_router_system/custom_router_system.dart';
import 'package:explorer/utils/custom_router_system/helpers/server_requests_utils.dart';
import 'package:explorer/utils/server_utils/handlers/handlers.dart'
    as normal_handlers;

CustomRouterSystem connectLaptopRouter(ConnectLaptopProvider connectLaptopPF) {
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
    );
  return customRouterSystem;
}
