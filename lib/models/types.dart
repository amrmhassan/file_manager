import 'package:hive_flutter/hive_flutter.dart';

part 'types.g.dart';

enum SnackBarType {
  info,
  error,
  success,
}

@HiveType(typeId: 11)
enum EntityType {
  @HiveField(0)
  file,
  @HiveField(1)
  folder,
}
