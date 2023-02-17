import 'dart:async';
import 'package:dio/dio.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/providers/connect_laptop_provider.dart';
import 'package:explorer/utils/server_utils/connection_utils.dart';

Future<String?> getWorkingIp(Iterable<String> ips, int port,
    ConnectLaptopProvider connectLaptopPF) async {
  Completer<String?> completer = Completer<String?>();

  Dio dio = Dio();
  dio.options.sendTimeout = 2000;
  dio.options.connectTimeout = 2000;
  dio.options.receiveTimeout = 2000;

  for (var ip in ips) {
    dio
        .post(
      getConnLink(ip, port, serverCheckEndPoint),
      data: connectLaptopPF.myPort,
    )
        .then((data) {
      connectLaptopPF.connected(data.data, ip, port);

      completer.complete(ip);
    }).catchError((error) {
      int index = ips.toList().indexOf(ip);
      if (index == ips.length - 1) {
        completer.complete(null);
      }
    });
  }
  return completer.future;
}
