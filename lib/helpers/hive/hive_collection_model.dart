// hive collection contain multiple hive boxes
// so a collection is like a database and a box in like a column

import 'package:hive/hive.dart';

class CustomHiveCollection {
  final List<Future<Box<dynamic>>> boxes;

  const CustomHiveCollection({
    required this.boxes,
  });

  Future<void> deleteCollection() async {
    for (var box in boxes) {
      await (await box).deleteFromDisk();
    }
  }

  Future<void> addBox(Future<Box<dynamic>> box) async {
    boxes.add(box);
  }
}
