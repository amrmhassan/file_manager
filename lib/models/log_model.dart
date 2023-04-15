import 'package:hive_flutter/hive_flutter.dart';

part 'log_model.g.dart';

@HiveType(typeId: 18)
class LogModel {
  @HiveField(0)
  final String level;
  @HiveField(1)
  final String message;
  @HiveField(2)
  final String error;
  @HiveField(3)
  final String stackTrace;
  @HiveField(4)
  final String dateTime;

  const LogModel({
    required this.level,
    required this.message,
    required this.error,
    required this.stackTrace,
    required this.dateTime,
  });
}
