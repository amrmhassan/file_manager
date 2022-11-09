//? file info
import 'package:explorer/models/types.dart';

class LocalFileInfo {
  final String parentPath;
  final String path;
  final DateTime modified;
  final DateTime accessed;
  final DateTime changed;
  final EntityType entityType;
  final String fileBaseName;
  final int size;
  final String ext;

  const LocalFileInfo({
    required this.size,
    required this.parentPath,
    required this.path,
    required this.modified,
    required this.accessed,
    required this.changed,
    required this.entityType,
    required this.fileBaseName,
    required this.ext,
  });
}
