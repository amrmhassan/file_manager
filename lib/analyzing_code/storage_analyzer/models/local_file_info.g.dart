// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_file_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalFileInfoAdapter extends TypeAdapter<LocalFileInfo> {
  @override
  final int typeId = 8;

  @override
  LocalFileInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalFileInfo(
      size: fields[8] as int,
      parentPath: fields[1] as String,
      path: fields[0] as String,
      modified: fields[2] as DateTime,
      accessed: fields[3] as DateTime,
      changed: fields[4] as DateTime,
      entityType: fields[5] as EntityType,
      fileBaseName: fields[6] as String,
      ext: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalFileInfo obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.parentPath)
      ..writeByte(2)
      ..write(obj.modified)
      ..writeByte(3)
      ..write(obj.accessed)
      ..writeByte(4)
      ..write(obj.changed)
      ..writeByte(5)
      ..write(obj.entityType)
      ..writeByte(6)
      ..write(obj.fileBaseName)
      ..writeByte(7)
      ..write(obj.ext)
      ..writeByte(8)
      ..write(obj.size);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalFileInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
