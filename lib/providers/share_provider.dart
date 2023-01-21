import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

enum MemberType {
  server,
  client,
}

class ShareProvider extends ChangeNotifier {
  String speedText = '0Mb/s';
  double percentSent = 0;
  int serverPort = 3000;
  String? myConnLink;
  int myServerOpenPort = 0;
  List<String> sharedLinks = [];
  bool sharing = false;
  Uint8List? sharedFile;
  String? fileName;

//? receive file
  Future connectToServer(String ip) async {
    String fileName =
        (await Dio().get('http://$ip:$serverPort/filename')).data as String;
    int? t;
    DateTime before = DateTime.now();
    await Dio().download(
      'http://$ip:$serverPort',
      '/sdcard/$fileName',
      onReceiveProgress: (count, total) {
        DateTime after = DateTime.now();

        t ??= total;
        double percent = (count / total) * 100;
        double instantTime = after.difference(before).inMicroseconds / 1000000;
        String realTimeSpeed =
            '${((count / (1024 * 1024)) / instantTime).toStringAsFixed(2)}Mb/s';
        speedText = realTimeSpeed;
        percentSent = percent / 100;
        notifyListeners();

        // stdout.write('Progress: ${percent.toStringAsFixed(2)}%\r');
        if (count == total) {
          double time = after.difference(before).inMicroseconds / 1000000;
          double size = t! / (1024 * 1024);
          String speed = (size / time).toStringAsFixed(2);

          Dio().post('http://$ip:$serverPort/done',
              options: Options(
                headers: {
                  'speed': speed,
                },
              ));
        }
      },
    );
  }

//? add file to
  void addToShareSpace(String path) async {
    sharedLinks.clear();
    sharedLinks.add(path);
    fileName = sharedLinks.first.split('/').last;
    sharedFile = await File(sharedLinks.first).readAsBytes();
    notifyListeners();
  }

//? send file
  Future openServer() async {
    HttpServer httpServer =
        await HttpServer.bind(InternetAddress.anyIPv4, myServerOpenPort);
    myServerOpenPort = httpServer.port;
    print('I am using $myServerOpenPort as a port');
    String? myWifiIp = await getMyIpAddress();
    myConnLink = 'http://$myWifiIp:$myServerOpenPort';
    sharing = true;
    notifyListeners();

    print('Waiting for the client to connect');
    httpServer.listen((HttpRequest request) async {
      if (request.uri.path == '/') {
        print('Client connected');
        request.response
          ..headers.contentType = ContentType('application', 'octet-stream')
          ..headers.add('content-disposition', 'attachment; filename=$fileName')
          ..headers.add('Content-Length', sharedFile!.length)
          ..headers.add('fileName', fileName!)
          ..add(sharedFile!)
          ..close();
      } else if (request.uri.path == '/done') {
        String data = request.headers['speed']?.first ?? 'null';
        print('File sent with speed $data Mb/s');
        request.response.close();
        httpServer.close();
      } else if (request.uri.path == '/filename') {
        print('Sending file $fileName');
        request.response
          ..write(fileName)
          ..close();
      }
    });
  }

//? get my wifi address
  Future<String?> getMyIpAddress() async {
    try {
      var interfaces = await NetworkInterface.list();
      var wifiInterface = interfaces.firstWhere((element) =>
          element.name.contains('wlan') || element.name.contains('wifi'));
      return wifiInterface.addresses.first.address;
    } catch (e) {
      return null;
    }
  }
}
