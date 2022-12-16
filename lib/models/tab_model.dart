import 'package:path/path.dart' as path_operations;

class TabModel {
  String path;
  late String title;

  TabModel({
    required this.path,
  }) {
    title = path_operations.basename(path);
  }
}
