class FileItemInfo {
  int? size;
  final String name;
  final String ext;
  final String path;

  FileItemInfo({
    this.size,
    required this.ext,
    required this.name,
    required this.path,
  });
}
