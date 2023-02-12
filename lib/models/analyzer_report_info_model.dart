import 'package:hive/hive.dart';

part 'analyzer_report_info_model.g.dart';

@HiveType(typeId: 0)
class AnalyzerReportInfoModel {
  @HiveField(0)
  final DateTime dateDone;
  @HiveField(1)
  final int folderCount;
  @HiveField(2)
  final int filesCount;
  @HiveField(3)
  final int extensionsCount;
  @HiveField(4)
  final int totalFilesSize;

  const AnalyzerReportInfoModel({
    required this.dateDone,
    required this.folderCount,
    required this.filesCount,
    required this.extensionsCount,
    required this.totalFilesSize,
  });

  // Map<String, String> toJSON() {
  //   return {
  //     dateDoneString: dateDone.toIso8601String(),
  //     folderCountString: folderCount.toString(),
  //     filesCountString: filesCount.toString(),
  //     extensionsCountString: extensionsCount.toString(),
  //     totalFilesSizeString: totalFilesSize.toString(),
  //   };
  // }

  // static AnalyzerReportInfoModel fromJSON(Map<String, dynamic> jsonOBJ) {
  //   return AnalyzerReportInfoModel(
  //     dateDone: DateTime.parse(jsonOBJ[dateDoneString]),
  //     folderCount: int.parse(jsonOBJ[folderCountString]),
  //     filesCount: int.parse(jsonOBJ[filesCountString]),
  //     extensionsCount: int.parse(jsonOBJ[extensionsCountString]),
  //     totalFilesSize: int.parse(jsonOBJ[totalFilesSizeString]),
  //   );
  // }

  // static String toSQLString() {
  //   return 'CREATE TABLE $analyzerReportInfoTableName ($dateDoneString TEXT PRIMARY KEY,$folderCountString TEXT, $filesCountString TEXT, $extensionsCountString TEXT, $totalFilesSizeString TEXT)';
  // }
}
