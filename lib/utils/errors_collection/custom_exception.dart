// ignore_for_file: prefer_const_constructors

import 'package:explorer/utils/errors_collection/custom_logger.dart';
import 'package:explorer/utils/errors_collection/error_logger_model.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

final CustomLogger customLogger = CustomLogger();

class CustomException implements Exception {
  StackTrace? stackTrace;
  Object errString;
  bool rethrowError;

  CustomException({
    required this.errString,
    this.stackTrace,
    this.rethrowError = false,
  }) {
    if (rethrowError) {
      throw Exception(errString);
    }
    if (kDebugMode) {
      print(errString);
      print(stackTrace);
    }
    //? save the log
    ErrorLoggerModel error = ErrorLoggerModel(
      id: Uuid().v4(),
      error: errString.toString(),
      stackTrace: stackTrace.toString(),
      date: DateTime.now(),
    );
    customLogger.addError(error);
  }
  @override
  String toString() {
    return errString.toString().replaceAll('Exception: ', '');
  }
}
