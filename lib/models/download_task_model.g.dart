// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadTaskModelAdapter extends TypeAdapter<DownloadTaskModel> {
  @override
  final int typeId = 1;

  @override
  DownloadTaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadTaskModel(
      remoteDeviceName: fields[4] as String,
      remoteDeviceID: fields[5] as String,
      id: fields[0] as String,
      remoteFilePath: fields[1] as String,
      addedAt: fields[3] as DateTime,
      size: fields[6] as int?,
    )..localFilePath = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, DownloadTaskModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.remoteFilePath)
      ..writeByte(2)
      ..write(obj.localFilePath)
      ..writeByte(3)
      ..write(obj.addedAt)
      ..writeByte(4)
      ..write(obj.remoteDeviceName)
      ..writeByte(5)
      ..write(obj.remoteDeviceID)
      ..writeByte(6)
      ..write(obj.size);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadTaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
