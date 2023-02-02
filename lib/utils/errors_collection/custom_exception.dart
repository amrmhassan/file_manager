// ignore_for_file: prefer_const_constructors

import 'package:explorer/utils/errors_collection/custom_logger.dart';
import 'package:explorer/utils/errors_collection/error_logger_model.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

final CustomLogger customLogger = CustomLogger();

class CustomException implements Exception {
  StackTrace? s;
  Object e;
  bool rethrowError;

  CustomException({
    required this.e,
    required this.s,
    this.rethrowError = false,
  }) {
    if (rethrowError) {
      throw Exception(e);
    }
    if (kDebugMode) {
      print(e);
      print(s);
    }
    //? save the log
    ErrorLoggerModel error = ErrorLoggerModel(
      id: Uuid().v4(),
      error: e.toString(),
      stackTrace: s.toString(),
      date: DateTime.now(),
    );
    customLogger.addError(error);
  }
  @override
  String toString() {
    return e.toString().replaceAll('Exception: ', '');
  }
}
