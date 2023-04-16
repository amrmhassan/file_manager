// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_clicked_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntityClickedModelAdapter extends TypeAdapter<EntityClickedModel> {
  @override
  final int typeId = 19;

  @override
  EntityClickedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EntityClickedModel(
      path: fields[2] as String,
      times: fields[0] as int,
      lastTimeClicked: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EntityClickedModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.times)
      ..writeByte(1)
      ..write(obj.lastTimeClicked)
      ..writeByte(2)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntityClickedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
