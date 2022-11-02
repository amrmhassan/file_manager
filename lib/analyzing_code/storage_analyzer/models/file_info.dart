import 'dart:io';

extension FileSize on int {
  double get toKB {
    return (this / 1024);
  }

  double get toMB {
    return toKB / 1024;
  }

  double get toGB {
    return toMB / 1024;
  }
}

class FileInfo {
  FileSystemEntity fileSystemEntity;
  int size;

  FileInfo({
    required this.fileSystemEntity,
    required this.size,
  });
  double get sizeInKB {
    return size.toKB;
  }

  double get sizeInMB {
    return size.toMB;
  }

  double get sizeInGB {
    return size.toGB;
  }
}
