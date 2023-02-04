import 'dart:async';
import 'dart:io';

import 'package:explorer/utils/general_utils.dart';

class CustomDio {
  Future<int> download(
    String url,
    String savePath, {
    Function(int total, int received)? onReceiveProgress,
    CustomCancelToken? cancelToken,
    bool deleteIfExist = false,
    Map<String, dynamic>? headers,
  }) async {
    if (deleteIfExist) {
      File file = File(savePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
    Completer<int> completer = Completer<int>();
    Uri uri = Uri.parse(url);
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.getUrl(uri);
    headers?.forEach((key, value) {
      request.headers.add(key, value);
    });
    HttpClientResponse response = await request.close();
    int received = 0;
    int length =
        int.parse(response.headers.value(HttpHeaders.contentLengthHeader)!);
    var raf = await File(savePath).open(mode: FileMode.append);

    late StreamSubscription responseSubscription;
    responseSubscription = response.listen((chunk) {
      if (cancelToken != null) {
        if (cancelToken.isCancelled) {
          raf.closeSync();
          responseSubscription.cancel();
          completer.complete(received);
          return;
        }
      }
      received += chunk.length;
      raf.writeFromSync(chunk);
      if (onReceiveProgress != null) {
        onReceiveProgress(length, received);
      }
      if (received == length) {
        raf.closeSync();
        completer.complete(received);
        responseSubscription.cancel();
      }
    });

    return completer.future;
  }
}

class CustomCancelToken {
  bool _isCancelled = false;
  bool get isCancelled => _isCancelled;
  void cancel() {
    _isCancelled = true;
    printOnDebug('cancelled');
  }
}
