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

class FileSizeClass {}
