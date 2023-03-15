import 'dart:convert';
import 'dart:io';

Future<dynamic> decodeRequest(
  HttpRequest request, [
  bool jsonify = true,
]) async {
  try {
    if (jsonify) {
      return json.decode(utf8.decode(await request.single));
    }
    return utf8.decode(await request.single);
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
