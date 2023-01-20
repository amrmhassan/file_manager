import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ShareProvider extends ChangeNotifier {
  String ppp = '0Mb/s';
  double percentSent = 0;
  int serverPort = 3000;

  Future receiveFile(String ip) async {
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
        ppp = realTimeSpeed;
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
}
