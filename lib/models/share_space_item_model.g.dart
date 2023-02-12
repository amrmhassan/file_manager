// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_space_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShareSpaceItemModelAdapter extends TypeAdapter<ShareSpaceItemModel> {
  @override
  final int typeId = 6;

  @override
  ShareSpaceItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShareSpaceItemModel(
      blockedAt: (fields[2] as List).cast<String>(),
      entityType: fields[1] as EntityType,
      path: fields[0] as String,
      ownerDeviceID: fields[3] as String,
      ownerSessionID: fields[4] as String?,
      addedAt: fields[5] as DateTime,
      size: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ShareSpaceItemModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.entityType)
      ..writeByte(2)
      ..write(obj.blockedAt)
      ..writeByte(3)
      ..write(obj.ownerDeviceID)
      ..writeByte(4)
      ..write(obj.ownerSessionID)
      ..writeByte(5)
      ..write(obj.addedAt)
      ..writeByte(6)
      ..write(obj.size);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShareSpaceItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
