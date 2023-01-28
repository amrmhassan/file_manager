// ignore_for_file: constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

//? used
enum HttpMethod {
  GET,
  POST,
  DELETE,
  UNKNOWN,
}

//? to convert the method string from the request object to enum
HttpMethod stringToHttpMethod(String m) {
  if (m == 'GET') {
    return HttpMethod.GET;
  } else if (m == 'POST') {
    return HttpMethod.POST;
  } else if (m == 'DELETE') {
    return HttpMethod.DELETE;
  } else {
    return HttpMethod.UNKNOWN;
  }
}

String jsonify(Map<String, dynamic> obj) {
  return json.encode(obj);
}

Future<String> decodeRequest(HttpRequest request) async {
  Uint8List bodyBinary = await request.single;
  String bodyString = utf8.decode(bodyBinary);
  return bodyString;
}
