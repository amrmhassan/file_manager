import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

class CustomDio {
  Future<int> download(
    String url,
    String savePath, {
    Function(int total, int received, int chunkSize)? onReceiveProgress,
    CustomCancelToken? cancelToken,
    bool deleteIfExist = false,
    Map<String, dynamic>? headers,
    int? startByte,
  }) async {
    if (deleteIfExist) {
      File file = File(savePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    }

//! the error with downloading is here in this function
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
    if (received == length) {
      raf.closeSync();
      completer.complete(received);
    }
    late StreamSubscription responseSubscription;
    responseSubscription = response.listen((chunk) {
      if (cancelToken != null) {
        if (cancelToken.isCancelled) {
          raf.closeSync();
          responseSubscription.cancel();
          completer.complete(received);
          // throw Exception('Cancelled');
          return;
        }
      }
      received += chunk.length;
      raf.writeFromSync(chunk);
      if (onReceiveProgress != null) {
        onReceiveProgress(received, length, chunk.length);
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
  }
}

class CustomDioOriginalDio extends CustomDio {
  int received = 0;
  @override
  Future<int> download(
    String url,
    String savePath, {
    Function(
      int total,
      int received,
      int chunkSize,
    )?
        onReceiveProgress,
    CustomCancelToken? cancelToken,
    bool deleteIfExist = false,
    Map<String, dynamic>? headers,
    int? startByte,
  }) async {
    await Dio().download(
      url,
      savePath,
      options: Options(headers: headers),
      onReceiveProgress: (count, total) {
        if (onReceiveProgress != null) {
          onReceiveProgress(total, count, count - received);
        }
        received = count;
      },
    );
    return received;
  }
}
