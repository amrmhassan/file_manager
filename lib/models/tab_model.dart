import 'package:explorer/providers/util/explorer_provider.dart';
import 'package:path/path.dart' as path_operations;

class TabModel {
  String path;
  late String title;

  TabModel({
    required this.path,
  }) {
    title = mainDisksMapper[path] ?? path_operations.basename(path);
  }
}
