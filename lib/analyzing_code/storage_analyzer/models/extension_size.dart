class ExtensionSize {
  int size;
  final String ext;

  ExtensionSize({
    required this.size,
    required this.ext,
  });

  void addSizeToExtension(int s) {
    size += s;
  }
}
