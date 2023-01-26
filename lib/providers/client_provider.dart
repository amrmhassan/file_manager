import 'package:dio/dio.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/general_utils.dart';
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
          nameString: name,
          deviceIDString: deviceID,
          portString: myPort,
          ipString: myIp,
        },
      ),
    );
    printOnDebug(response.data);
  }
}
