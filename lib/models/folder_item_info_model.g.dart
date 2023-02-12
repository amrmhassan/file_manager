// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_item_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FolderItemInfoModelAdapter extends TypeAdapter<FolderItemInfoModel> {
  @override
  final int typeId = 2;

  @override
  FolderItemInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FolderItemInfoModel(
      path: fields[0] as String,
      name: fields[1] as String,
      itemCount: fields[2] as int?,
      dateCaptured: fields[3] as DateTime,
      size: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, FolderItemInfoModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.itemCount)
      ..writeByte(3)
      ..write(obj.dateCaptured)
      ..writeByte(4)
      ..write(obj.size);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderItemInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
