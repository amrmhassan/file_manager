// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extension_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExtensionInfoAdapter extends TypeAdapter<ExtensionInfo> {
  @override
  final int typeId = 10;

  @override
  ExtensionInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExtensionInfo(
      count: fields[0] as int,
      ext: fields[1] as String,
      size: fields[2] as int,
      filesPath: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExtensionInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.count)
      ..writeByte(1)
      ..write(obj.ext)
      ..writeByte(2)
      ..write(obj.size)
      ..writeByte(3)
      ..write(obj.filesPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExtensionInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
