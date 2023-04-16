import 'package:hive_flutter/hive_flutter.dart';

part 'entity_clicked_model.g.dart';

@HiveType(typeId: 19)
class EntityClickedModel {
  @HiveField(0)
  final int times;
  @HiveField(1)
  final String lastTimeClicked;
  @HiveField(2)
  final String path;

  const EntityClickedModel({
    required this.path,
    required this.times,
    required this.lastTimeClicked,
  });
}
