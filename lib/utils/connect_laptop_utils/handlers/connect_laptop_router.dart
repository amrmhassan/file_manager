import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/providers/connect_laptop_provider.dart';
import 'package:explorer/utils/connect_laptop_utils/handlers/handlers.dart';
import 'package:explorer/utils/custom_router_system/custom_router_system.dart';
import 'package:explorer/utils/custom_router_system/helpers/server_requests_utils.dart';

CustomRouterSystem connectLaptopRouter(ConnectLaptopProvider connectLaptopPF) {
  CustomRouterSystem customRouterSystem = CustomRouterSystem();

  //? adding handlers
  customRouterSystem
    ..addHandler(
      getStorageEndPoint,
      HttpMethod.GET,
      getStorageInfoHandler,
    )
    ..addHandler(
      getDiskNamesEndPoint,
      HttpMethod.GET,
      getDiskNamesHandler,
    )
    ..addHandler(
      getPhoneFolderContentEndPoint,
      HttpMethod.GET,
      getPhoneFolderContentHandler,
    );
  return customRouterSystem;
}
