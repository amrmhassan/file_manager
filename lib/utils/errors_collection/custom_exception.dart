// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/global_constants.dart';

class CustomException implements Exception {
  StackTrace? s;
  Object e;
  bool rethrowError;

  CustomException({
    required this.e,
    this.s,
    this.rethrowError = false,
  }) {
    logger.e(e);
  }
  @override
  String toString() {
    return e.toString().replaceAll('Exception: ', '');
  }
}
