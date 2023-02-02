import 'package:explorer/helpers/string_to_type.dart';

enum ErrorType {
  info,
  error,
}

class ErrorLoggerModel {
  final String id;
  final String error;
  final String stackTrace;
  final DateTime date;
  final ErrorType errorType;

  const ErrorLoggerModel({
    required this.id,
    required this.error,
    required this.stackTrace,
    required this.date,
    this.errorType = ErrorType.info,
  });

  Map<String, String> toJSON() {
    return {
      errorIdString: id,
      errorMessageString: error,
      errorStackTraceString: stackTrace,
      errorDateString: date.toIso8601String(),
      errorTypeString: errorType.name,
    };
  }

  static ErrorLoggerModel fromJSON(Map<String, dynamic> errorJSON) {
    String id = errorJSON[errorIdString];
    String error = errorJSON[errorMessageString];
    String stackTrace = errorJSON[errorStackTraceString];
    DateTime date = DateTime.parse(errorJSON[errorDateString]);
    return ErrorLoggerModel(
      id: id,
      error: error,
      stackTrace: stackTrace,
      date: date,
      errorType: stringToEnum(errorJSON[errorTypeString], ErrorType.values),
    );
  }

  static String toSqliteString() {
    return 'CREATE TABLE $errorsLoggerTableName ($errorIdString TEXT PRIMARY KEY, $errorMessageString TEXT, $errorStackTraceString TEXT, $errorDateString TEXT, $errorTypeString TEXT)';
  }
}

//? error model keys
const String errorIdString = 'errorIdString';
const String errorMessageString = 'errorMessageString';
const String errorStackTraceString = 'errorStackTraceString';
const String errorDateString = 'errorDateString';
const String errorTypeString = 'errorTypeString';

//? table name
const String errorsLoggerTableName = 'errorsLoggerTableName';
