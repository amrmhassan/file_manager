import 'package:explorer/utils/general_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';

class CustomLoggerModel extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.levelColors[event.level];
    final emoji = PrettyPrinter.levelColors[event.level];
    final message = event.message;
    final stackTrace = event.stackTrace;

    try {
      FirebaseAnalytics.instance.logEvent(
        name: message,
        parameters: {
          'level': event.level.name,
          'stackTrace': stackTrace.toString(),
        },
        callOptions: AnalyticsCallOptions(global: true),
      );
    } catch (e) {
      printOnDebug('can\'t record the flutter logging error on firebase ');
    }

    return [color!('$emoji $message\n$stackTrace')];
  }

  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(LogEvent(Level.info, message, error, stackTrace));
  }

  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(LogEvent(Level.error, message, error, stackTrace));
  }

  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    log(LogEvent(Level.warning, message, error, stackTrace));
  }
}
