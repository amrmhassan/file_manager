// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'white_block_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WhiteBlockListModelAdapter extends TypeAdapter<WhiteBlockListModel> {
  @override
  final int typeId = 7;

  @override
  WhiteBlockListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WhiteBlockListModel(
      deviceID: fields[0] as String,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WhiteBlockListModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.deviceID)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WhiteBlockListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
