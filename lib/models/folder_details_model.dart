class FolderDetailsModel {
  final String path;
  int? filesCount;
  int? folderCount;
  int? size;

  FolderDetailsModel({
    required this.path,
    this.filesCount,
    this.folderCount,
    this.size,
  });
}
