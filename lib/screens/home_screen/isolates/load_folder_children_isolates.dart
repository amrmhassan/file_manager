import 'dart:io';

List<FileSystemEntity> getFolderChildrenIsolate(String path) {
  Directory directory = Directory(path);
  var data = directory.listSync();
  return data.map((e) => e).toList();
}
