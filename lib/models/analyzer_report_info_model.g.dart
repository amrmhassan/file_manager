// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analyzer_report_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnalyzerReportInfoModelAdapter
    extends TypeAdapter<AnalyzerReportInfoModel> {
  @override
  final int typeId = 0;

  @override
  AnalyzerReportInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalyzerReportInfoModel(
      dateDone: fields[0] as DateTime,
      folderCount: fields[1] as int,
      filesCount: fields[2] as int,
      extensionsCount: fields[3] as int,
      totalFilesSize: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AnalyzerReportInfoModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dateDone)
      ..writeByte(1)
      ..write(obj.folderCount)
      ..writeByte(2)
      ..write(obj.filesCount)
      ..writeByte(3)
      ..write(obj.extensionsCount)
      ..writeByte(4)
      ..write(obj.totalFilesSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyzerReportInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
