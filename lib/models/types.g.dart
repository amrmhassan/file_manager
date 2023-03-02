// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntityTypeAdapter extends TypeAdapter<EntityType> {
  @override
  final int typeId = 11;

  @override
  EntityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EntityType.file;
      case 1:
        return EntityType.folder;
      default:
        return EntityType.file;
    }
  }

  @override
  void write(BinaryWriter writer, EntityType obj) {
    switch (obj) {
      case EntityType.file:
        writer.writeByte(0);
        break;
      case EntityType.folder:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntityTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskStatusAdapter extends TypeAdapter<TaskStatus> {
  @override
  final int typeId = 12;

  @override
  TaskStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskStatus.pending;
      case 1:
        return TaskStatus.paused;
      case 2:
        return TaskStatus.downloading;
      case 3:
        return TaskStatus.finished;
      case 4:
        return TaskStatus.failed;
      default:
        return TaskStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, TaskStatus obj) {
    switch (obj) {
      case TaskStatus.pending:
        writer.writeByte(0);
        break;
      case TaskStatus.paused:
        writer.writeByte(1);
        break;
      case TaskStatus.downloading:
        writer.writeByte(2);
        break;
      case TaskStatus.finished:
        writer.writeByte(3);
        break;
      case TaskStatus.failed:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
