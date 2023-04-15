import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<dynamic> decodeRequest(
  HttpRequest request, [
  bool jsonify = true,
]) async {
  try {
    String requestBody = await utf8.decoder.bind(request).join();
    if (jsonify) {
      var jsonData = json.decode(requestBody);

      return jsonData;
    }
    var decoded = requestBody;
    return decoded;
  } catch (e) {
    return null;
  }
}

String jsonify(Map<String, dynamic> obj) {
  return json.encode(obj);
}

List<int> encodeRequest(dynamic data) {
  return utf8.encode(data);
}
