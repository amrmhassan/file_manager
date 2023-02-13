// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_folder_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalFolderInfoAdapter extends TypeAdapter<LocalFolderInfo> {
  @override
  final int typeId = 9;

  @override
  LocalFolderInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalFolderInfo(
      parentPath: fields[0] as String,
      path: fields[1] as String,
      modified: fields[2] as DateTime,
      accessed: fields[3] as DateTime,
      changed: fields[4] as DateTime,
      dateCaptured: fields[6] as DateTime,
      entityType: fields[5] as EntityType,
    );
  }

  @override
  void write(BinaryWriter writer, LocalFolderInfo obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.parentPath)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.modified)
      ..writeByte(3)
      ..write(obj.accessed)
      ..writeByte(4)
      ..write(obj.changed)
      ..writeByte(5)
      ..write(obj.entityType)
      ..writeByte(6)
      ..write(obj.dateCaptured);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalFolderInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
