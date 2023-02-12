// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listy_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListyModelAdapter extends TypeAdapter<ListyModel> {
  @override
  final int typeId = 4;

  @override
  ListyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListyModel(
      title: fields[0] as String,
      icon: fields[1] as String,
      createdAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ListyModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.icon)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
