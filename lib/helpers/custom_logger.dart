import 'dart:io';

import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class CustomLogger extends Logger {
  @override
  void log(Level level, message, [error, StackTrace? stackTrace]) {
    try {
      super.log(level, message, error, stackTrace);
      final file = File(logFilePath);
      final sink = file.openWrite(mode: FileMode.append);
      String logLine = logBeautifier(level, message, error, stackTrace);
      sink.write(logLine);
      sink.close();
    } catch (e) {
      //
    }
  }

  String logBeautifier(Level level, message, [error, StackTrace? stackTrace]) {
    String levelString = '[${level.name.toUpperCase()}]';
    String messageString = message.toString();
    String errorString = error?.toString() ?? '';
    String stackTraceString = stackTrace?.toString() ?? '';
    String dateTime = DateFormat('yy/MM/dd HH:mm:ss').format(DateTime.now());
    return "$levelString $dateTime \n$messageString \n$errorString \n $stackTraceString";
  }
}
