import 'dart:io';

class FolderViewModel {
  final int scrollingTo;
  final List<FileSystemEntity> directChildren;

  const FolderViewModel({
    required this.directChildren,
    required this.scrollingTo,
  });
}
