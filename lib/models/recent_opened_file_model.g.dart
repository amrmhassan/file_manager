// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_opened_file_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentOpenedFileModelAdapter extends TypeAdapter<RecentOpenedFileModel> {
  @override
  final int typeId = 5;

  @override
  RecentOpenedFileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentOpenedFileModel(
      dateOpened: fields[1] as DateTime,
      path: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecentOpenedFileModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.dateOpened);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentOpenedFileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
