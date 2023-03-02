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

@HiveType(typeId: 12)
enum TaskStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  paused,
  @HiveField(2)
  downloading,
  @HiveField(3)
  finished,
  @HiveField(4)
  failed,
}
