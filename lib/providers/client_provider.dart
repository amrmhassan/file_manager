import 'package:dio/dio.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:flutter/cupertino.dart';

class ClientProvider extends ChangeNotifier {
  Future addClient(
    String connLink,
    ShareProvider shareProvider,
    ServerProvider serverProvider,
    BuildContext context,
  ) async {
    await serverProvider.openServer(shareProvider);
    String deviceID = shareProvider.myDeviceId;
    String name = 'Client Name';
    String myIp = serverProvider.myIp!;
    int myPort = serverProvider.myPort;
    await Dio().get(
      '$connLink$addClientEndPoint',
      options: Options(
        headers: {
          nameString: name,
          deviceIDString: deviceID,
          portString: myPort,
          ipString: myIp,
        },
      ),
    );
  }
}
