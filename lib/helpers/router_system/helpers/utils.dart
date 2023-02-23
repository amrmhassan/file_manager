// ignore_for_file: constant_identifier_names

enum HttpMethod {
  GET,
  POST,
  DELETE,
  ANY,
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
