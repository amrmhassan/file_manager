class FolderItemInfo {
  final int scrollingTo;
  final List<String> directChildren;
  final int itemCount;

  const FolderItemInfo({
    required this.directChildren,
    required this.scrollingTo,
    required this.itemCount,
  });
}
