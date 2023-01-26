import 'package:dio/dio.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:flutter/cupertino.dart';

class ClientProvider extends ChangeNotifier {
  Future addClient(
    String connLink,
    ShareProvider shareProvider,
    ServerProvider serverProvider,
  ) async {
    await serverProvider.openServer(shareProvider);
    String deviceID = shareProvider.myDeviceId;
    String name = 'This is me client name';
    String myIp = serverProvider.myIp!;
    int myPort = serverProvider.myPort;
    var response = await Dio().get(
      '$connLink/addClient',
      options: Options(
        headers: {
          'name': name,
          'deviceID': deviceID,
          'port': myPort,
          'ip': myIp,
        },
      ),
    );
    print(response.data);
  }
}
