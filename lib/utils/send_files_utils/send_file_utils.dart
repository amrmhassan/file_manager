import 'dart:io';
import 'package:path/path.dart' as path_operations;

void serveFileListener(HttpRequest req, String filePath) async {
  var file = File(filePath);
  int length = file.lengthSync();
  String baseName = path_operations.basename(filePath);
  req.response.headers
    ..contentType = ContentType.parse('application/octet-stream')
    ..contentLength = length
    ..add('Content-Disposition',
        'attachment; filename="${Uri.encodeComponent(baseName)}"');
  // req.response.add(file.readAsBytesSync());
  await req.response.addStream(file.openRead());
  await req.response.close();
}
