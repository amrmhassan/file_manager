import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';

import 'file_info.dart';

class ExtensionProfile {
  final String ext;
  final LocalFileInfo localFileInfo;

  const ExtensionProfile({
    required this.ext,
    required this.localFileInfo,
  });
}
