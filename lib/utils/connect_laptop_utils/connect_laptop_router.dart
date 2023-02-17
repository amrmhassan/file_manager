import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/providers/connect_laptop_provider.dart';
import 'package:explorer/utils/custom_router_system/custom_router_system.dart';
import 'package:explorer/utils/custom_router_system/helpers/server_requests_utils.dart';

CustomRouterSystem connectLaptopRouter(ConnectLaptopProvider connectLaptopPF) {
  CustomRouterSystem customRouterSystem = CustomRouterSystem();

  //? adding handlers
  customRouterSystem.addHandler(
    getPeerImagePathEndPoint,
    HttpMethod.GET,
    (request, response) => null,
  );
  return customRouterSystem;
}
