// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listy_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListyItemModelAdapter extends TypeAdapter<ListyItemModel> {
  @override
  final int typeId = 3;

  @override
  ListyItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListyItemModel(
      id: fields[0] as String,
      path: fields[1] as String,
      listyTitle: fields[2] as String,
      createdAt: fields[3] as DateTime,
      entityType: fields[4] as EntityType,
    );
  }

  @override
  void write(BinaryWriter writer, ListyItemModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.listyTitle)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.entityType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListyItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
