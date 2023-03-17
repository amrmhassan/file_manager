// import 'dart:async';
// import 'dart:io';

// import 'package:explorer/constants/global_constants.dart';
// import 'package:explorer/services/connect_laptop_service/path_split.dart';
// import 'package:explorer/services/services_constants.dart';
// import 'package:explorer/utils/connect_laptop_utils/handlers/connect_laptop_router.dart';
// import 'package:explorer/utils/custom_router_system/custom_router_system.dart';
// import 'package:explorer/utils/server_utils/encoding_utils.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';

// // working from background service
// //file explorer--, stream audio, video, download file--
// //? need context
// //? share space, copy clipboard, send text, send file

// late List<Directory> backgroundServiceInitlaDirs;

// class ConnectLaptopService {
//   final ServiceInstance _service;

//   ConnectLaptopService(this._service);

//   HttpServer? httpServer;

//   Future<void> openServer(Map<String, dynamic>? event) async {
//     int port = event!['port'];
//     backgroundServiceInitlaDirs = (event['intialDirs'] as List<dynamic>)
//         .map((e) => Directory(e))
//         .toList();
//     //
//     httpServer = await HttpServer.bind(InternetAddress.anyIPv4, port);
//     //! i need to empty the request object from it's info and pass them to the main isolate for the listener on the ConnLaptopServiceController, yo might need to extract the request body , path , method for the outside main isolate
//     //! and you might need to warn the user before clicking the back button with the connect laptop server is open
//     CustomRouterSystem customRouterSystem = connectLaptopRouter();
//     httpServer!.listen(
//       (request) async {
//         //? this should contain a map of headers and response body, there will be an error with downloading, streaming file,
//         //?  because this will slow the downloading speed, so i will split them,
//         //? some will be from the main isolate, and others will be from this isolate, but check if the path is in this isolate first

//         if (workingPathsFromBackground.contains(request.uri.path)) {
//           customRouterSystem.pipeline(request);
//         } else {
//           try {
//             var response = await _sendRequestToMainIsolate(_service, request);
//             var headers = response['headers'] as Map<String, dynamic>;
//             var body = response['body'];

//             headers.forEach((key, value) {
//               request.response.headers.add(key, value);
//             });
//             request.response
//               ..add(body)
//               ..close();
//           } catch (e) {
//             request.response
//               ..statusCode = HttpStatus.internalServerError
//               ..write('An error occurred with background service')
//               ..close();
//           }
//         }
//       },
//     );
//     port = httpServer!.port;
//     _service.invoke(ServiceResActions.setLaptopServerPort, {
//       'port': port,
//     });
//   }

//   Future<dynamic> _sendRequestToMainIsolate(
//     ServiceInstance s,
//     HttpRequest request,
//   ) async {
//     StreamSubscription? sub;
//     Map<String, dynamic> headers = {};
//     request.headers.forEach((name, values) {
//       try {
//         headers[name] = values.first;
//       } catch (e) {
//         logger.e(e);
//       }
//     });
//     var requestBody = await decodeRequest(request, true);

//     Completer completer = Completer();
//     var requestInfo = {
//       'path': request.uri.path,
//       'method': request.method,
//       'content': requestBody,
//       'remoteIp': request.connectionInfo?.remoteAddress.address,
//       'remotePort': request.connectionInfo?.remotePort,
//       'headers': headers,
//     };

//     s.invoke(
//       ServiceResActions.connLaptopRequests,
//       requestInfo,
//     );

//     sub = s.on(ServiceActions.sendResponse).listen((event) {
//       completer.complete(event);
//       sub?.cancel();
//     });

//     return completer.future;
//   }
// }
